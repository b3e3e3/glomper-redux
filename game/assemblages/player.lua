return function(e, x, y)
    print("Assembling player")
    e
    :give(
        "position",
        x or love.graphics.getWidth() / 2,
        y or love.graphics.getHeight() / 2
    )
    :give("velocity", 0, 0)
    :give("controller")--, 400)
    :give("testdraw")
end