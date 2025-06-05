require "gameobject"

Controller = GameObject:extend()
function Controller:constructor(object)
    self.object = object
    GameObject.constructor(self, 0, 0)
end

function Controller.getInput()
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

function Controller:update(dt)
    local xinput, yinput = self.getInput()

    self.position.x = self.position.x + xinput * 200 * dt
    -- self.position.y = self.position.y + yinput * 200 * dt
end

return Controller