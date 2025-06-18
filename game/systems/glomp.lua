local GlompSystem = Concord.system({
    glompable = { "glompable", "position", "physics" },
    glomper = { "glomper", "position", "physics" },
    glomped = { "glomped", "position", "physics" },
})

function GlompSystem:hitByProjectile(by, other)
    for _, e in ipairs(self.glompable) do
        if e == other then
            local p = Game.createProjectile(other)
            p.projectile.state = 'collided' -- <-- TODO: hacky
            p.position.y = by.position.y
            p.velocity.x = -by.velocity.x
            p.direction.current = -by.direction.last

            ECS.world:removeEntity(other)
        end
    end
end

function GlompSystem:glomp(by, other)
    if other:has("glomped") then return end
    other:give("glomped")
    -- other:ensure("physics")
    other.physics.isSolid = false

    by.velocity:set(0, 0)

    by.position.y = other.position.y
    by.position.x = other.position.x

    by.controller.stats:commit()

    by.controller.stats.airSpeed = by.controller.stats.speed * 0.5
    by.controller.stats.speed = 0
    by.controller.stats.jumpForce = by.controller.stats.jumpForce * 0.7

    by
        :give("offset", nil, -other.size.h)
        :give("glompsprite")

    ECS.world:removeEntity(other)
end

function GlompSystem:jump(e)
    -- if not self.glomped:has(e) then return end
    if not self.glomper:has(e) then return end
    if not e:has('glompsprite') then return end
    if Game.Physics.isGrounded(e) then return end
    if not Game.Input:pressed("jump") then return end
    if e.physics.isFrozen then return end -- HACK: might be shit

    -- ECS.world:emit("throw", e)
    self:throw(e)
end

function GlompSystem:throw(e)
    e
        :remove("offset")
        :remove("glompsprite")

    Game.setFreeze(true, e)
    e.physics.isSolid = false
    -- e.position.y = e.position.y - e.size.h

    local pe = Game.createProjectile(e)
    pe.projectile.onFinished = function(_)
        e.velocity.x, e.velocity.y = 0, 0
        e.physics.isSolid = true
        Game.setFreeze(false, e)

        -- TODO: RETURN ORIGINAL MOTION
        e.controller.stats:reset()
    end
end

-- GLOMPABLE
function GlompSystem:glompableUpdate(e, dt) end

function GlompSystem:glompableDraw(e)
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle("fill", e.position.x, e.position.y, 2)
    if e.glompable.other then
        love.graphics.rectangle("fill", e.position.x, e.position.y - e.size.h, e.size.w, e.size.h)
    end
end

-- GLOMPER
function GlompSystem:glomperUpdate(e, dt)
    local function glompFilter(item)
        if e:has("glomper") and e:has("glompsprite") then return nil end
        if not item:has("glompable") then return nil end
        return 'touch'
    end

    local x, y = e.glomper.hitbox:getOffsetPos(e.position.x, e.position.y)
    local items = Game.bumpWorld:queryRect(
        x, y,
        e.glomper.hitbox.width,
        e.glomper.hitbox.height,
        glompFilter
    )
    for _, i in ipairs(items) do
        ECS.world:emit("glomp", e, i)
    end
end

function GlompSystem:glomperDraw(e)
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", e.position.x, e.position.y, 2)

    local x, y = e.glomper.hitbox:getOffsetPos(e.position.x, e.position.y)

    love.graphics.rectangle(
        "line",
        x,
        y,
        e.glomper.hitbox.width, e.glomper.hitbox.height)
end

-- GLOMPED
function GlompSystem:glompedUpdate(e, dt) end

function GlompSystem:glompedDraw(e) end

------------------

function GlompSystem:update(dt)
    for _, e in ipairs(self.glompable) do
        self:glompableUpdate(e, dt)
    end

    for _, e in ipairs(self.glomper) do
        self:glomperUpdate(e, dt)
    end

    for _, e in ipairs(self.glomped) do
        self:glompedUpdate(e, dt)
    end
end

function GlompSystem:draw()
    love.graphics.push()
    for _, e in ipairs(self.glompable) do
        self:glompableDraw(e)
    end

    for _, e in ipairs(self.glomper) do
        self:glomperDraw(e)
    end

    for _, e in ipairs(self.glomped) do
        self:glompedDraw()
    end

    love.graphics.pop()
end

return GlompSystem
