local component = Concord.component("controller", function(c, speed)
    c.speed = speed or 200
end)

return component