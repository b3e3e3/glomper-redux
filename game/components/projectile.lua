local component = Concord.component("projectile", function (c, speed)
    c.speed = speed or 400
end)

return component