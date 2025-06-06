require 'game.systems.physics'

local TestDrawSystem = Concord.system({
    pool = { "testdraw", "position", "size" },
    physics = { "testdraw", "physics", "position" }
})

function TestDrawSystem:drawPhysics()
    for _, e in ipairs(self.physics) do
        if Game.bumpWorld:hasItem(e) then
            local cols = Game.Physics.getCols(e, 0, 0)
            love.graphics.push()

            if #cols > 1 then
                love.graphics.setColor(0, 1, 0)
            else
                love.graphics.setColor(1, 0, 0)
            end

            local x, y, w, h = Game.bumpWorld:getRect(e)

            -- love.graphics.print(string.format("vel: %s, %s", e.velocity.x, e.velocity.y), x, y - 32)
            love.graphics.print(string.format("pos: %s, %s", e.position.x, e.position.y), x, y - 48)
            love.graphics.print(string.format("rect: %s, %s", x, y), x, y - 64)
            love.graphics.print(string.format("isSolid: %s", e.physics.isSolid), x, y - 80)
            love.graphics.print(string.format("isFrozen: %s", e.physics.isFrozen), x, y - 96)
            love.graphics.print(string.format("cols: %s", #cols), x, y - 112)

            love.graphics.pop()
        end
    end
end

function TestDrawSystem:drawGraphic()
    for _, e in ipairs(self.pool) do
        love.graphics.push()
        love.graphics.setColor(1, 1, 1)
        -- love.graphics.circle("fill", e.position.x, e.position.y, 16)
        love.graphics.rectangle("fill",
            e.position.x, e.position.y,
            e.size.w, e.size.h
        )
        love.graphics.pop()
    end
end

function TestDrawSystem:draw()
    self:drawGraphic()
    self:drawPhysics()
end

return TestDrawSystem
