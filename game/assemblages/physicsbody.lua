return function(e, x, y, w, h)
    e
    :ensure(
        "position",
        x or Game.getWidth() / 2,
        y or Game.getHeight() / 2
    )
    :ensure("size", w or 32, h or 32)
    :ensure("velocity", 0, 0)
    :ensure("direction")
    :ensure("physics")
end