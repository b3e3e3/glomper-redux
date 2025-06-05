return function(e, x, y)
    print("Assembling player")
    e
    :ensure(
        "position",
        x or love.graphics.getWidth() / 2,
        y or love.graphics.getHeight() / 2
    )
    :ensure("velocity", 0, 0)
    :ensure("physics")
    :give("controller")--, 400)
    :give("testdraw")
end