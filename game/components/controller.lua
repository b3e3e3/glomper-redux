local component = Concord.component("controller", function(c, speed, jumpForce)
    c.speed = speed or 200
    c.jumpForce = jumpForce or -400
end)

return component