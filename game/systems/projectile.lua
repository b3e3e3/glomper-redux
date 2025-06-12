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
        local spin = -e.velocity.x / 6 -- e.direction.last * 20
        e.testdraw.angle = e.testdraw.angle - spin * dt

        local ydamp = 800
        
        ---- 1. artificial drag
        -- local xmult = 0.98
        -- local xvel = (e.velocity.x * xmult) - e.direction.last * dt
        
        ---- 2. stokes drag
        local xvel = e.velocity.x - 1.5 * e.velocity.x * dt
        e.velocity.x = xvel
        
        local yvel = e.velocity.y + ydamp * dt
        e.velocity.y = yvel
        
        if e.position.y < e.size.h or e.position.y > love.graphics.getHeight() then
            e.projectile.state = 'finished'
        end
    end

    local function finishedUpdate(e)
        e.projectile.onFinished(e)
        ECS.world:removeEntity(e)

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
