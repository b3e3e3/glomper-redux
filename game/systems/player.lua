local PlayerSystem = Concord.system({
    pool = { "controller", "position", "velocity", "physics" },
})

local tempAccel = 8
local tempDecel = 16
local tempReverseAccelMod = 2
local tempAirAccelMod = 0.8

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
    Game.Input:update()
    for _, e in ipairs(self.pool) do
        local x, _ = Game.Input:get('move')

        local targetSpeed = e.controller.speed
        if not Game.Physics.isGrounded(e) then
            targetSpeed = e.controller.airSpeed
        end
        
        local dir = math.Sign(e.velocity.x)

        local getAccel = function()
            local force = tempAccel * x
            if x == 0 then force = -tempDecel * dir
            -- elseif x ~= dir then force = force + tempDecel * dir
            elseif x ~= dir then force = tempDecel * tempReverseAccelMod * x
            end

            local air = 1
            if not Game.Physics.isGrounded(e) then air = tempAirAccelMod end

            return force * air
        end

        local xforce = math.Clamp(e.velocity.x + getAccel(), -targetSpeed, targetSpeed)
        if Game.Input:down('jump') then
            ECS.world:emit('jump', e)
        end

        e.velocity.x = xforce
    end
end

return PlayerSystem
