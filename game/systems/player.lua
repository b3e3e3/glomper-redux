local PlayerSystem = Concord.system({
    pool = { "controller", "position", "velocity", "physics" },
})

local tempAccel = 16
local tempDecel = 16

local tempReverseAccelMod = 2
local tempAirAccelMod = 0.6
local tempSprintSpeedMod = 1.76

function PlayerSystem.getMaxSpeed(e)
    local speed = e.controller.stats.speed
    if not Game.Physics.isGrounded(e) then
        speed = e.controller.stats.airSpeed
    end
    if Game.Input:down("sprint") then
        return speed * tempSprintSpeedMod
    end


    return speed
end
-- PlayerSystem.getMaxSpeed = Memoize(PlayerSystem.getMaxSpeed)

function PlayerSystem:update(dt)
    for _, e in ipairs(self.pool) do
        local x = Game.Input:get('move')
        local dir = math.Sign(e.velocity.x)
        local maxSpeed = self.getMaxSpeed(e)

        local getAccel = function()
            if x == 0 and e.velocity.x == 0 then return 0 end
            local force = tempAccel * x
            if x == 0 then force = -tempDecel * dir
            elseif x ~= dir then force = tempDecel * tempReverseAccelMod * x end

            local air = (Game.Physics.isGrounded(e) and 1) or tempAirAccelMod
            return force * air
        end

        local targetxforce = e.velocity.x + getAccel()
        -- TODO: smooth transition out of sprinting
        local xforce = math.Clamp(targetxforce, -maxSpeed, maxSpeed)
        
        if Game.Input:pressed('jump') then
            ECS.world:emit('jump', e, e.controller.stats.jumpForce)
        end

        -- e.velocity.x = xforce
        ECS.world:emit('move', e, xforce)
        if e:has("direction") then
            if x ~= 0 then
                e.direction.last = e.direction.current
                e.direction.current = x
            end
        end
    end
end

return PlayerSystem
