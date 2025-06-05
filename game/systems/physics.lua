local input = require "input"
local PhysicsSystem = Concord.system({
    pool = { "physics", "velocity" },
})

function PhysicsSystem:onEntityAdded(e)
    -- print("Adding entity with:")
    -- for _,v in pairs(e:getComponents()) do
    --     print('- ' .. v:getName())
    -- end
    -- print("Adding entity")
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

function PhysicsSystem:getCols(e, xOffset, yOffset)
    local _, _, cols = self.checkCollision(e, e.position.x + (xOffset or 0), e.position.y + (yOffset or 0))
    return cols
end

function PhysicsSystem.isGrounded(e) -- TODO: better refactor for this
    return #PhysicsSystem:getCols(e, 0, 1) > 0
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

function PhysicsSystem:freeze(e)
    local function freeze(e)
        e.physics.isFrozen = not e.physics.isFrozen
    end
    if e == nil then
        for _, v in ipairs(self.pool) do
            freeze(v)
        end
    else
        freeze(e)
    end

end


function PhysicsSystem.checkCollision(e, goalX, goalY, filter)
    local count = 0
    local solidFilter = function(item, other)
        count = count+1
        if e.physics.isSolid ~= true or item.physics.isSolid ~= true then
            print(string.format('%s. nil %s', count, item:has("controller")))
            return 'cross'
        end
        return 'slide'
    end

    return Game.bumpWorld:check(e, goalX, goalY, filter or solidFilter)
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
        local actualX, actualY, cols = self.checkCollision(e, goalX, goalY)

        -- if we are trying to fall but can't, we've landed on a surface
        if actualY ~= goalY and e.velocity.y > 0 then
            e.velocity.y = 0
        end

        e.position.x, e.position.y = actualX, actualY
        Game.bumpWorld:update(e, e.position.x, e.position.y)
    end

    for _, e in ipairs(self.pool) do
        if e.physics.isFrozen then goto continue end
        if not self.isGrounded(e) then
            applyGravity(e)
        end

        moveAndCollide(e)
        ::continue::
    end
end

function PhysicsSystem:draw()
    for _, e in ipairs(self.pool) do
        if Game.bumpWorld:hasItem(e) then
            local cols = self:getCols(e, 0, 1)
            love.graphics.push()

            if #cols > 1 then
                love.graphics.setColor(0, 1, 0)
            else
                love.graphics.setColor(1, 0, 0)
            end

            local x, y, w, h = Game.bumpWorld:getRect(e)
            
            love.graphics.print(string.format("vel: %s, %s", e.velocity.x, e.velocity.y), x, y - 32)
            love.graphics.print(string.format("pos: %s, %s", e.position.x, e.position.y), x, y - 48)
            love.graphics.print(string.format("rect: %s, %s", x, y), x, y - 64)
            love.graphics.print(string.format("isSolid: %s", e.physics.isSolid), x, y - 80)
            love.graphics.print(string.format("isFrozen: %s", e.physics.isFrozen), x, y - 96)
            love.graphics.print(string.format("cols: %s", #cols), x, y - 112)

            love.graphics.pop()

            love.graphics.setColor(0,1,1)
            love.graphics.setLineWidth(4)
            love.graphics.rectangle("line", x, y, w, h)
        end
    end
end

return PhysicsSystem
