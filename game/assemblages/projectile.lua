return function(e, x, y, w, h, dir, onFinished)
    e
        :give("physics", 0)
        :give("direction", dir)
        :give("projectile", onFinished)
        :assemble(ECS.a.physicsbody, x, y, w, h)
end