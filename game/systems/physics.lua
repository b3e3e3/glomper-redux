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

function PhysicsSystem:move(e, xforce)
    if not Game.Physics.isOnWall(e) then
        e.velocity.x = xforce
    end
end

function PhysicsSystem:jump(e, force)
    for _, v in ipairs(self.physbody) do
        if e == v then
            if Game.Physics.canJump(e) then
                -- normal jump
                e.velocity.y = -force
                -- wall jump
                -- TODO: xgrav that brings you back to the wall after jumping
                if Game.Physics.isOnWall(e) then
                    e.velocity.x = -force * e.direction.last
                end
            end
        end
    end
end

function PhysicsSystem:update(dt)
    local function applyGravity(e)
        e.velocity:apply(nil, -e.physics.gravity)
    end

    local function moveAndCollide(e)       
        local goalX, goalY = Game.Physics.calculateGoalPos(e.position, e.velocity)
        local actualX, actualY, cols = Game.Physics.checkCollision(e, goalX, goalY)

        if #cols > 0 then
            for _, c in pairs(cols) do
                ECS.world:emit("collide", e, c.other)
            end
        end

        -- if we are trying to fall but can't, we've landed on a surface
        if actualY ~= goalY and e.velocity.y > 0 then
            e.velocity.y = 0
        end

        -- do something similar for the wall
        if Game.Physics.isOnWall(e) then
            if actualX ~= goalX and math.abs(e.velocity.x) > 0 then
                e.velocity.y = 0
                e.velocity.x = 0
            end
        end

        e.position.x, e.position.y = actualX, actualY
    end

    for _, e in ipairs(self.physbody) do
        if e.physics.isFrozen then goto continue end

        -- if we are not grounded nor on a wall, we want gravity applied
        if not Game.Physics.isGrounded(e) then
            if not Game.Physics.isOnWall(e) then
                applyGravity(e)
            end
        end

        moveAndCollide(e)

        ::continue::
    end

    for _, e in ipairs(self.all) do
        Game.bumpWorld:update(e, e.position.x, e.position.y)
    end
end

return PhysicsSystem
