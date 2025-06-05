local GlompSystem = Concord.system({
    glompable = { "glompable", "position", "physics" },
    glomper = { "controller", "position", "physics" }
})

function GlompSystem:update(dt)

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