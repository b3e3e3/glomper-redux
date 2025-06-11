local PlayerSystem = Concord.system({
    pool = { "controller", "position", "velocity", "physics" },
})

local tempAccel = 16
local tempDecel = 16

local tempReverseAccelMod = 2
local tempAirAccelMod = 0.6
local tempSprintSpeedMod = 1.76

function PlayerSystem.getMaxSpeed(e)
    local speed = e.controller.speed
    if not Game.Physics.isGrounded(e) then
        speed = e.controller.airSpeed
    end
    if Game.Input:down("sprint") then
        return speed * tempSprintSpeedMod
    end
    -- TODO: smooth transition between sprinting and not
    return speed
end
-- PlayerSystem.getMaxSpeed = Memoize(PlayerSystem.getMaxSpeed)

function PlayerSystem:jump(e)
    for _, v in ipairs(self.pool) do
        if e == v then
            if Game.Physics.isGrounded(e) then
                e.velocity.y = -e.controller.jumpForce
            end
        end
    end
end

function PlayerSystem:update(dt)
    for _, e in ipairs(self.pool) do
        local x = Game.Input:get('move')
        local dir = math.Sign(e.velocity.x)
        local maxSpeed = self.getMaxSpeed(e)

        local getAccel = function()
            local force = tempAccel * x
            if x == 0 then force = -tempDecel * dir
            elseif x ~= dir then force = tempDecel * tempReverseAccelMod * x end

            local air = (Game.Physics.isGrounded(e) and 1) or tempAirAccelMod
            return force * air
        end

        local xforce = math.Clamp(e.velocity.x + getAccel(), -maxSpeed, maxSpeed)
        if Game.Input:down('jump') then
            ECS.world:emit('jump', e)
        end

        e.velocity.x = xforce
        if e:has("direction") then
            if x ~= 0 then e.direction.last = x end
        end
    end
end

return PlayerSystem
