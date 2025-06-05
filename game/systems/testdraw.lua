local TestDrawSystem = Concord.system({
    pool = {"testdraw", "position"}
})

function TestDrawSystem:draw()
    for _, e in ipairs(self.pool) do
        love.graphics.push()
        love.graphics.setColor(1,1,1)
        love.graphics.circle("fill", e.position.x, e.position.y, 16)
        love.graphics.pop()
    end
end

return TestDrawSystem