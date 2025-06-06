local TestDraw = require 'game.testdraw'

local coord2 = function(c, x, y)
    c.x = x or 0
    c.y = y or 0

    function c:set(x, y)
        self.x = x or self.x
        self.y = y or self.y
    end

    function c:apply(x, y)
        self.x = self.x + (x or 0)
        self.y = self.y + (y or 0)
    end
end

Concord.component("size", function(c, w, h)
    c.w = w or 32
    c.h = h or 32
end)

local physics = Concord.component("physics", function(c, isSolid, gravity)
    c.gravity = gravity or -9.8
    c.isSolid = isSolid == nil or isSolid -- defaults to true if isSolid is nil
    c.isFrozen = false
end)
TestDraw.giveInfoText(physics, function(e)
    local goalX, goalY = Game.Physics.calculateGoalPos(e.position, e.velocity)
    local _, _, cols = Game.Physics.checkCollision(e, goalX, goalY)
    if #cols > 1 then
        love.graphics.setColor(0, 1, 0)
    else
        love.graphics.setColor(1, 0, 0)
    end

    local x, y, _, _ = Game.bumpWorld:getRect(e)

    return {
        string.format("rect: %s, %s", x, y),
        string.format("cols: %s", #cols),
        string.format("isSolid: %s", e.physics.isSolid),
        string.format("isFrozen: %s", e.physics.isFrozen),
    }
end)

local position = Concord.component("position", coord2)
TestDraw.giveInfoText(position, function(e)
    return string.format("pos: %s, %s", e.position.x, e.position.y)
end)

local velocity = Concord.component("velocity", coord2)
TestDraw.giveInfoText(velocity, function(e)
    return string.format("vel: %s, %s", e.velocity.x, e.velocity.y)
end)
