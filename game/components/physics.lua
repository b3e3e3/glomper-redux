local coord2 = function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end

local physics = Concord.component("physics", function(c, isSolid)
    c.isSolid = isSolid or true
end)

Concord.component("position", coord2)
Concord.component("velocity", coord2)