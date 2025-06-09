return function(e, x, y, w, h, onFinished)
    e
        :give("position", x, y)
        :give("size", w, h)
        :give("projectile", nil, onFinished)
end