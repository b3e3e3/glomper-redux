local PhysicsSystem = Concord.system({
    physbody = { "physics", "position", "size", "velocity" },
    all = { "physics", "position", "size" },
})

function PhysicsSystem:onEntityAdded(e)
    if not self.all:has(e) then return end
    if Game.bumpWorld:hasItem(e) then return end
    Game.bumpWorld:add(e, e.position.x, e.position.y, e.size.w, e.size.h)
end

function PhysicsSystem:onEntityRemoved(e)
    if not Game.bumpWorld:hasItem(e) then return end

    Game.bumpWorld:remove(e)
end

function PhysicsSystem:freeze(e)
    local function freeze(e)
        e.physics.isFrozen = not e.physics.isFrozen
    end
    if e == nil then -- if none specified, freeze all
        for _, v in ipairs(self.all) do
            freeze(v)
        end
    else
        freeze(e)
    end

end

function PhysicsSystem:update(dt)
    local function applyGravity(e)
        e.velocity:apply(nil, -e.physics.gravity)
    end

    local function calculateGoalPos(e)
        return Game.Physics.calculateGoalPos(e.position, e.velocity)
    end

    local function moveAndCollide(e)       
        local goalX, goalY = calculateGoalPos(e)
        local actualX, actualY, cols = Game.Physics.checkCollision(e, goalX, goalY)

        -- if we are trying to fall but can't, we've landed on a surface
        if actualY ~= goalY and e.velocity.y > 0 then
            e.velocity.y = 0
        end

        e.position.x, e.position.y = actualX, actualY
        -- Game.bumpWorld:update(e, e.position.x, e.position.y)
    end

    for _, e in ipairs(self.physbody) do
        if e.physics.isFrozen then goto continue end
        if not Game.Physics.isGrounded(e) then
            applyGravity(e)
        end

        moveAndCollide(e)

        ::continue::
    end

    for _, e in ipairs(self.all) do
        -- if e.physics.isFrozen then goto continue end
        
        Game.bumpWorld:update(e, e.position.x, e.position.y)

        ::continue::
    end
end

return PhysicsSystem
