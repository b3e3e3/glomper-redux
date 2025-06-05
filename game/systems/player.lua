local PlayerSystem = Concord.system({
    pool = { "controller", "position", "velocity", "physics" },
})

function PlayerSystem:update(dt)
    Input:update()
    for _, e in ipairs(self.pool) do
        local x, _ = Input:get('move')

        local xforce = x * e.controller.speed
        if Input:down('jump') then
            ECS.world:emit('jump', e)
        end

        e.velocity.x = xforce
    end
end

return PlayerSystem
