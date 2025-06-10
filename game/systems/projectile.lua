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

function ProjectileSystem:draw()
    for _, e in ipairs(self.pool) do
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("I am a projectile!!", e.position.x, e.position.y)
    end
end

return ProjectileSystem
