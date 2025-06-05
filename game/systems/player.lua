local PlayerSystem = Concord.system({
    movement = { "position", "velocity" },
    input = { "controller" },
})
function PlayerSystem:update(dt)
    local x, y = 0, 0

    -- handle input
    for _, e in ipairs(self.input) do
        Input:update()
        x, y = Input:get('move')
        print(x, y)
    end

    -- handle movement
    for _, e in ipairs(self.movement) do
        e.velocity.x, e.velocity.y = x * e.controller.speed, y * e.controller.speed
    end
end

return PlayerSystem
