local flux = require 'libraries.flux'
local ProjectileSystem = Concord.system({
    pool = { "projectile", "position", "direction", "size", "velocity" },
})

function ProjectileSystem:collide(by, other)
    for _, e in ipairs(self.pool) do
        if by == e then
            
        end
    end
end

function ProjectileSystem.doCollide(e)
    e.velocity.x = -e.velocity.x / 6
    e.velocity.y = -500
    e:give("physics", false, -20)
    e.projectile.state = 'collided'
end

function ProjectileSystem:update(dt)
    for _, e in ipairs(self.pool) do
        local pos = {x=e.position.x, y=e.position.y}
        -- print(e.projectile.state)
        if e.projectile.state == 'idle' then
            e.projectile.state = 'moving'
        elseif e.projectile.state == 'moving' then
            e.velocity.x = e.projectile.speed * e.direction.lastdir

            if e.position.x < -e.size.w or e.position.x > love.graphics.getWidth() then
                self.doCollide(e)
            end

        elseif e.projectile.state == 'collided' then
            e.projectile.state = 'spinout'
            
        elseif e.projectile.state == 'spinout' then
            -- print(Game.Physics.isOnScreen(e.position, e.size))
            if e.position.y < e.size.h or e.position.y > love.graphics.getHeight() then
                e.projectile.state = 'finished'
            end
        elseif e.projectile.state == 'finished' then
            e.projectile.onFinished(e)
            e.projectile.state = 'idle'
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
