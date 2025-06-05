local Base = require "libraries.knife.base"

Objects = {}

GameObject = Base:extend()
function GameObject:constructor(x, y)
    self.position = { x = x, y = y, }
    table.insert(Objects, self)
    print("Created game object at " .. x .. ", " .. y)
end

function GameObject:load() end
function GameObject:update(dt) end
function GameObject:draw() end

function GameObject:destroy()
    for i, go in pairs(Objects) do
        if go == self then
            table.remove(Objects, i)
            return
        end
    end
end

return GameObject