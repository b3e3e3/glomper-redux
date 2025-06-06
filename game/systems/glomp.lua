local GlompSystem = Concord.system({
    glompable = { "glompable", "position", "physics" },
    glomper = { "controller", "position", "physics" }
})

function GlompSystem:update(dt)
    local touchQueue = {}
    for _, e in ipairs(self.glompable) do
        local actualX, actualY, cols = Game.Physics.checkCollision(e, e.position.x, e.position.y + 1,
            function(item, other)
                if other == e then return nil end
                if other == item then return nil end
                return 'touch'
            end)
        for _, c in ipairs(cols) do
            print(c.position.x, c.position.y)
        end
    end

    for _, e in ipairs(self.glomper) do

    end
end

function GlompSystem:draw()
    love.graphics.push()
    for _, e in ipairs(self.glompable) do
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle("fill", e.position.x, e.position.y, 2)
        love.graphics.print("glompable", e.position.x, e.position.y - 16)
    end
    for _, e in ipairs(self.glomper) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", e.position.x, e.position.y, 2)
        love.graphics.print("glomper", e.position.x, e.position.y - 16)
    end
    love.graphics.pop()
end

return GlompSystem
