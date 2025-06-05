require "player"
require "controller"

function love.load()
    player = PlayerObject(20, 20)
    controller = Controller(player)

    for i,v in pairs(Objects) do
        v:load()
    end
end

function love.update(dt)
    for i,v in pairs(Objects) do
        v:update(dt)
    end
end

function love.draw()
    for i,v in pairs(Objects) do
        v:draw()
    end

    love.graphics.setColor(1,1,1)
    love.graphics.setNewFont(24)
    love.graphics.print("Objects: " .. #Objects, 16, 16)
end
