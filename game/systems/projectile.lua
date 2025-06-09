-- TODO: state machine?
local state = 'moving' --'idle'

local ProjectileSystem = Concord.system({
    pool = { "projectile", "position" },
})

function ProjectileSystem:update(dt)
    for _, e in ipairs(self.pool) do
        if state == 'idle' then
        elseif state == 'moving' then
            e.position.x = e.position.x + e.projectile.speed * dt
            if e.position.x < 0 or e.position.x > love.graphics.getWidth() then
                state = 'finished'
            end
        elseif state == 'finished' then
            e.projectile.onFinished()
            state = 'idle'
        end
    end
end

return ProjectileSystem
