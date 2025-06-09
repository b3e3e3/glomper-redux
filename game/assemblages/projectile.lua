return function(e, x, y, w, h)
    e
        :give("position", x, y)
        :give("size", w, h)
        :give("projectile")
end