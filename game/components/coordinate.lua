local coord2 = function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end

Concord.component("position", coord2)
Concord.component("velocity", coord2)