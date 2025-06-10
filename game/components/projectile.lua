local component = Concord.component("projectile", function (c, onFinished)
    -- TODO: state machine?
    c.state = 'moving'

    c.speed = 700
    c.onFinished = onFinished or function(_)end
end)

return component