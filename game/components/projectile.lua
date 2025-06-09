local component = Concord.component("projectile", function (c, speed, onFinished)
    c.speed = speed or 400
    c.onFinished = onFinished or function()end
end)

return component