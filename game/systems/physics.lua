local gravity = -9.8

local List = require 'libraries.concord.list'

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
    print("init physics")

    for _, e in ipairs(self.pool) do
        if not Game.bumpWorld:hasItem(e) then
            Game.bumpWorld:add(e, e.position.x, e.position.y, 32, 32) -- TODO: width and height
        end
    end
end

function PhysicsSystem.isGrounded(e) -- TODO: better refactor for this
    local _,_,cols = Game.bumpWorld:check(e, e.position.x, e.position.y + 1)
    return #cols > 0
end

function PhysicsSystem:applyForce(e, x, y)
    e.velocity.x = x or e.velocity.x
    e.velocity.y = y or e.velocity.y
end

function PhysicsSystem:update(dt)
    local function calculateGoalPos(pos, vel)
        return pos.x + vel.x * dt, pos.y + vel.y * dt
    end

    local function applyGravity(e)
        local yforce = e.velocity.y - gravity

        self:applyForce(e, nil, yforce)
    end

    local function move(e)
        local goalX, goalY = calculateGoalPos(e.position, e.velocity)
        local actualX, actualY, cols = Game.bumpWorld:check(e, goalX, goalY)
        
        for _,v in ipairs(cols) do
            if v ~= e then
                if not v.other.isSolid then
                    actualX, actualY = goalX, goalY
                    break
                end
            end
        end

        -- if we are trying to fall but can't, we've landed on a surface
        if actualY ~= goalY and e.velocity.y > 0 then
            self:applyForce(e, nil, 0)
        end

        e.position.x, e.position.y = actualX, actualY
        Game.bumpWorld:update(e, e.position.x, e.position.y)
    end
    
    for _, e in ipairs(self.pool) do
        if self.isGrounded(e) then
            print(e.velocity.y)
        else
            applyGravity(e)
        end
        move(e)
    end
end

return PhysicsSystem