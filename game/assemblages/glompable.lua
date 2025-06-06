return function(e, x, y)
    e
    :give("glompable")
    :ensure("position", x, y)
    :ensure("velocity")
    :ensure("physics")
end