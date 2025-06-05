local PhysicsSystem = require 'game.systems.physics'
local PlayerSystem = Concord.system({
    pool = { "controller", "position", "velocity", "physics" },
})

local function applyForce(e, x, y)
    e.velocity.x = x or e.velocity.x
    e.velocity.y = y or e.velocity.y
end

function PlayerSystem:update(dt)
    for _, e in ipairs(self.pool) do
        Input:update()
        local x, y = Input:get('move')

        local xforce = x * e.controller.speed
        local yforce = nil
        if Input:down('jump') then
            if PhysicsSystem.isGrounded(e) then
                yforce = -400
            end
        end

        applyForce(e, xforce, yforce)
    end
end

return PlayerSystem
