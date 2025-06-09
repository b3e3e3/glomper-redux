local PlayerSystem = Concord.system({
    pool = { "controller", "position", "velocity", "physics" },
})

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

        local speed = e.controller.speed

        if not Game.Physics.isGrounded(e) then
            speed = e.controller.airSpeed
        end

        local xforce = x * speed
        if Game.Input:down('jump') then
            ECS.world:emit('jump', e)
        end

        e.velocity.x = xforce
    end
end

return PlayerSystem
