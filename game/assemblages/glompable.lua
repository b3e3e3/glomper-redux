return function(e, x, y)
    e
    :ensure("position", x, y)
    :ensure("velocity")
    :ensure("physics")
    :give("glompable")
end