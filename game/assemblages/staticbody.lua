return function(e, x, y, w, h)
    e
    :ensure(
        "position",
        x or love.graphics.getWidth() / 2,
        y or love.graphics.getHeight() / 2
    )
    :ensure("size", w or 64, h or 64)
    :ensure("physics")
end