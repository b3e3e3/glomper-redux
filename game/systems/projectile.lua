local ProjectileSystem = Concord.system({
    pool = { "projectile", "position", "direction", "size", "velocity" },
})

-- function GlompSystem:collide(by, other)
--     if other:has("glompable") then
--         if by:has("projectile") and by.projectile.state == 'moving' then
--             local e = Game.createProjectile(other)
--             e.velocity.x = -by.velocity.x
--             e.direction.last = by.direction.last

--             ECS.world:removeEntity(other)
--         end
--     end
-- end

function ProjectileSystem:collide(by, other)
    for _, e in ipairs(self.pool) do
        if by == e and e.projectile.state == 'moving' then
            local vel = e.velocity.x
            local dir = e.direction.last
            local y = e.position.y
            self.doCollide(e)
            if other:has("glompable") then
                ECS.world:removeEntity(other)
                local p = Game.createProjectile(other)
                p.position.y = y
                p.velocity.x = -vel
                e.direction.last = dir
                self.doCollide(p)
            end
        end
    end
end

function ProjectileSystem.doCollide(e)
    e.velocity.x = -e.velocity.x / 4
    e.velocity.y = -500
    e:give("physics", false)
    e.projectile.state = 'collided'
end

function ProjectileSystem:update(dt)
    local function idleUpdate(e)
        e.projectile.state = 'moving'
    end

    local function movingUpdate(e)
        e.velocity.x = e.projectile.speed * e.direction.last

        if e.position.x < -e.size.w or e.position.x > love.graphics.getWidth() then
            self.doCollide(e)
        end
    end

    local function spinoutUpdate(e)
        e.testdraw.angle = e.testdraw.angle + 18 * dt

        e.velocity.x = e.velocity.x - e.direction.last * 100 * dt
        e.velocity.y = e.velocity.y + 600 * dt
        
        if e.position.y < e.size.h or e.position.y > love.graphics.getHeight() then
            e.projectile.state = 'finished'
        end
    end

    local function finishedUpdate(e)
        e.projectile.onFinished(e)
        e.projectile.state = 'idle'
    end

    for _, e in ipairs(self.pool) do
        if e.projectile.state == 'idle' then idleUpdate(e)
        elseif e.projectile.state == 'moving' then movingUpdate(e)
        elseif e.projectile.state == 'collided' then
            e.projectile.state = 'spinout'
        elseif e.projectile.state == 'spinout' then spinoutUpdate(e)
        elseif e.projectile.state == 'finished' then finishedUpdate(e)
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
