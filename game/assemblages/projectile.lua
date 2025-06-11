return function(e, x, y, w, h, dir, onFinished)
    e
        :give("position", x, y)
        :give("velocity")
        :give("size", w, h)
        :give("physics", true, 0)
        :give("projectile", onFinished)
        :give("direction", dir)
end