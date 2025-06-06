local GlompSystem = Concord.system({
    glompable = { "glompable", "position", "physics" },
    glomper = { "glomper", "position", "physics" }
})

local oldPlayer = nil

function GlompSystem:update(dt)
    for _, e in ipairs(self.glomper) do
        local function glompFilter(item)
            if not item:has("glompable") then return nil end
            return 'touch'
        end

        local x, y = e.glomper.hitbox:getOffsetPos(e.position.x, e.position.y)
        local items, cols = Game.bumpWorld:queryRect(
            x, y,
            e.glomper.hitbox.width,
            e.glomper.hitbox.height,
            glompFilter
        )
        for _, i in ipairs(items) do
            -- print(c.other.position.x, c.other.position.y)
            ECS.world:emit("glomp", e, i)
        end
    end
end

function GlompSystem:draw()
    love.graphics.push()
    for _, e in ipairs(self.glompable) do
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle("fill", e.position.x, e.position.y, 2)
        if e.glompable.other then
            love.graphics.rectangle("fill", e.position.x, e.position.y - e.size.h, e.size.w, e.size.h)
        end
    end

    for _, e in ipairs(self.glomper) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", e.position.x, e.position.y, 2)

        local x, y = e.glomper.hitbox:getOffsetPos(e.position.x, e.position.y)

        love.graphics.rectangle(
            "line",
            x,
            y,
            e.glomper.hitbox.width, e.glomper.hitbox.height)
    end
    love.graphics.pop()
end

return GlompSystem
