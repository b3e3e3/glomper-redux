local component = Concord.component("controller", function(c, speed, jumpForce, airSpeed)
    c.speed = speed or 200
    c.jumpForce = jumpForce or 400
    c.airSpeed = airSpeed or c.speed
end)

return component