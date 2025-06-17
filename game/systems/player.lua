local PlayerSystem = Concord.system({
    pool = { "controller", "position", "velocity", "physics" },
})

local tempCrawlSpeed = 120

local tempAccel = 16
local tempDecel = 16

local tempReverseAccelMod = 2
local tempAirAccelMod = 0.6
local tempSprintSpeedMod = 1.76

function PlayerSystem:doJump(e)
    ECS.world:emit('jump', e, e.controller.stats.jumpForce)
end

function PlayerSystem:doMove(e, force)
    ECS.world:emit('move', e, force)
end

local function updateDirection(e, xdir)
    -- 2nd condition ensures that tapping "right" while on a left wall will not cause
    -- us to jump off the wall next time we jump. only update last direction when we
    -- are not on the wall
    if xdir ~= 0 and not Game.Physics.isOnWall(e) then
        e.direction.last = e.direction.current
    end
    e.direction.current = xdir
end

function PlayerSystem:interactStart(with, other)
    Game.setFreeze(true, other)
    other.velocity:set(0,0) -- TODO: "stop" function
end

function PlayerSystem:interactFinish(with, other)
    Game.setFreeze(false, other)
end

function PlayerSystem:update(dt)
    for _, e in ipairs(self.pool) do
        local goalXDir, goalYDir = Game.Input:get('move')

        local _getMaxSpeed = function()
            local speed = e.controller.stats.speed
            if not Game.Physics.isGrounded(e) then
                speed = e.controller.stats.airSpeed
            end
            if Game.Input:down("sprint") then
                return speed * tempSprintSpeedMod
            end


            return speed
        end

        local _getAccel = function()
            local actualXDir = math.Sign(e.velocity.x)
            if goalXDir == 0 and e.velocity.x == 0 then return 0 end
            local force = tempAccel * goalXDir
            if goalXDir == 0 then
                force = -tempDecel * actualXDir
            elseif goalXDir ~= actualXDir then
                force = tempDecel * tempReverseAccelMod * goalXDir
            end

            local air = (Game.Physics.isGrounded(e) and 1) or tempAirAccelMod
            return force * air
        end

        local _getForce = function()
            local force = {}

            local maxSpeed = _getMaxSpeed()
            local goalXForce = e.velocity.x + _getAccel()

            -- TODO: smooth transition out of sprinting
            force.x = math.Clamp(goalXForce, -maxSpeed, maxSpeed)

            if goalYDir ~= 0 then -- if on wall and trying to crawl up
                force.y = goalYDir * tempCrawlSpeed
                -- print(force.y)
            end

            return force
        end

        if e.physics.isFrozen then goto continue end

        local force = _getForce()
        if Game.Input:pressed('jump') then
            self:doJump(e)
        end

        self:doMove(e, force)

        if e:has("direction") then
            updateDirection(e, goalXDir)
        end

        ::continue::
    end
end

return PlayerSystem
