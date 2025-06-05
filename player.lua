local Object = require "gameobject"

PlayerObject = Object:extend()

function PlayerObject:constructor(x, y)
    Object.constructor(self, x, y)
    self.velocity = { x = x, y = y, }
end

function PlayerObject:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.position.x, self.position.y, 32, 32)
end

function PlayerObject.getInput()
    local x, y = 0, 0
    if love.keyboard.isDown("left") then
        x = x - 1
    end
    if love.keyboard.isDown("right") then
        x = x + 1
    end
    if love.keyboard.isDown("up") then
        y = y - 1
    end
    if love.keyboard.isDown("down") then
        y = y + 1
    end

    return x, y
end

function PlayerObject:update(dt)
    local xinput, yinput = self.getInput()

    self.position.x = self.position.x + xinput * 200 * dt
    -- self.position.y = self.position.y + yinput * 200 * dt
end
