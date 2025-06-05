return function(e, x, y)
    e
    :ensure(
        "position",
        x or love.graphics.getWidth() / 2,
        y or love.graphics.getHeight() / 2
    )
    :ensure("velocity", 0, 0)
    :ensure("physics")
end