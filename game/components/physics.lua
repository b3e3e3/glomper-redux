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

Concord.component("physics", function(c, isSolid, gravity)
    c.gravity = gravity or -9.8
    c.isSolid = isSolid == nil or isSolid -- defaults to true if isSolid is nil
    c.isFrozen = false
end)

Concord.component("position", coord2)

Concord.component("velocity", coord2)