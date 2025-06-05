local PhysicsSystem = Concord.system({
    pool = { "physics", "velocity" },
})

function PhysicsSystem:onEntityAdded(e)
    if not self.pool:has(e) then return end
    if Game.bumpWorld:hasItem(e) then return end
    Game.bumpWorld:add(e, e.position.x, e.position.y, 32, 32) -- TODO: width and height
end

function PhysicsSystem:onEntityRemoved(e)
    if not self.pool:has(e) then return end
    if not Game.bumpWorld:hasItem(e) then return end
    Game.bumpWorld:remove(e)
end

function PhysicsSystem:init()
    for _, e in ipairs(self.pool) do
        if not Game.bumpWorld:hasItem(e) then
            Game.bumpWorld:add(e, e.position.x, e.position.y, 32, 32) -- TODO: width and height
        end
    end
end

function PhysicsSystem.isGrounded(e) -- TODO: better refactor for this
    local _, _, cols = Game.bumpWorld:check(e, e.position.x, e.position.y + 1)
    return #cols > 0
end

function PhysicsSystem:jump(e)
    for _, v in ipairs(self.pool) do
        if e == v then
            if self.isGrounded(e) then
                e.velocity.y = e.controller.jumpForce
            end
        end
    end
end

function PhysicsSystem:update(dt)
    local function calculateGoalPos(pos, vel)
        return pos.x + vel.x * dt, pos.y + vel.y * dt
    end

    local function applyGravity(e)
        e.velocity:apply(nil, -e.physics.gravity)
    end

    local function moveAndCollide(e)
        local goalX, goalY = calculateGoalPos(e.position, e.velocity)
        local actualX, actualY, cols = Game.bumpWorld:check(e, goalX, goalY)

        for _, v in ipairs(cols) do
            if v ~= e then
                if not v.other.isSolid then
                    actualX, actualY = goalX, goalY
                    break
                end
            end
        end

        -- if we are trying to fall but can't, we've landed on a surface
        if actualY ~= goalY and e.velocity.y > 0 then
            e.velocity.y = 0
        end

        e.position.x, e.position.y = actualX, actualY
        Game.bumpWorld:update(e, e.position.x, e.position.y)
    end

    for _, e in ipairs(self.pool) do
        if not self.isGrounded(e) then
            applyGravity(e)
        end

        moveAndCollide(e)
    end
end

return PhysicsSystem
