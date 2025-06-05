local GlompSystem = Concord.system({
    glompable = { "glompable", "position", "physics" },
    glomper = { "controller", "position", "physics" }
})

function GlompSystem:update(dt)
    for _, e in ipairs(self.glomper) do
        local glompFilter = function(item, other)
            if item:has("glompable") then
                print("glompable item!")
                return 'touch'
            end

            return nil
        end
        local actualX, actualY, cols = Game.bumpWorld:check(e, e.position.x, e.position.y + 1, glompFilter)
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
