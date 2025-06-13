local Stats = require 'game.stats'

local component = Concord.component("controller", function(c, speed, jumpForce, airSpeed)
    c.stats = Stats.new()
    
    c.stats.speed = speed or 200
    c.stats.airSpeed = airSpeed or c.stats.speed
    c.stats.jumpForce = jumpForce or 400
end)

return component