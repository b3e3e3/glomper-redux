return function(e, x, y)
    print("Assembling player")
    e
    :assemble(ECS.a.character, x, y)
    :give("controller")--, 400)
    :give("glomper")
    :give("testdraw")
    
    e.controller.stats.jumpForce = 350
end