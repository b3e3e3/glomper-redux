local Timer = require 'libraries.knife.timer'

local GlompSystem = Concord.system({
    glompable = { "glompable", "position", "physics" },
    glomper = { "glomper", "position", "physics" },
    glomped = { "glomped", "position", "physics" },
})

function GlompSystem:glomp(by, other)
    if other:has("glomped") then return end
    other:give("glomped")

    if by:has("controller") then
        local speed = by.controller.speed * 0.5
        local jumpForce = by.controller.jumpForce * 0.7

        ECS.world:removeEntity(by)

        other:give("controller", 0, jumpForce, speed)
        other:give("glompsprite", "")
    end
end

function GlompSystem:jump(e)
    if not self.glomped:has(e) then return end
    if Game.Physics.isGrounded(e) then return end
    if not Game.Input:pressed("jump") then return end
    if e.physics.isFrozen then return end -- HACK: might be shit
    
    ECS.world:emit("throw", e)
end

function GlompSystem:throw(e)
    local player = Game.createPlayer(e.position.x, e.position.y)
    ECS.world:removeEntity(e)
    local projectile = Concord.entity(ECS.world)
    :assemble(ECS.a.projectile,
        e.position.x + 32,
        e.position.y
    )
    :give("testdraw")

    player.physics.isFrozen = true
    player.position.y = e.position.y - 32

    -- TODO: wait for animation
    Timer.after(0.3, function()
        player.physics.isFrozen = false
    end)
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
