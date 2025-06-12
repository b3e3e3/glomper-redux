local ProjectileSystem = Concord.system({
    pool = { "projectile", "position", "direction", "size", "velocity" },
})

function ProjectileSystem:update(dt)
    local function idleUpdate(e)
        e.projectile.state = 'moving'
    end

    local function movingUpdate(e)
        e.velocity.x = e.projectile.speed * e.direction.last

        local goalX, goalY = Game.Physics.calculateGoalPos(e.position, e.velocity)
        local _,_, cols = Game.Physics.checkCollision(e, goalX, goalY)

        if e.position.x < -e.size.w or e.position.x > love.graphics.getWidth()
        or #cols > 0 then
            for _,c in pairs(cols) do ECS.world:emit("hitByProjectile", e, c.other) end
            e.projectile.state = 'collided'-- self.doCollide(e)
        end
    end

    local function collidedUpdate(e)
        e.velocity.x = -e.velocity.x / 4
        e.velocity.y = -500

        e:give("physics", false)

        e.projectile.state = 'spinout'
    end

    local function spinoutUpdate(e)
        e.testdraw.angle = e.testdraw.angle + 18 * dt
        
        local xdamp = 100
        local ydamp = 600
        e.velocity.x = e.velocity.x - e.direction.last * xdamp * dt

        e.velocity.y = e.velocity.y + ydamp * dt
        
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
        elseif e.projectile.state == 'collided' then collidedUpdate(e)
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
