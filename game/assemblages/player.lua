return function(e, x, y)
    print("Assembling player")
    e
    :give("status")
    :give("controller")--, 400)
    :give("glomper")
    :give("testdraw")
    :give("weapon")
    :assemble(ECS.a.character, x, y)

    -- e.controller.stats.jumpForce = 350
end