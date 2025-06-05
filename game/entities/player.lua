local Concord = require 'libraries.concord'

function player(e, x, y)
    e
    :give("controller")
    :give(Concord.components.position)
    :give(Concord.components.velocity)
end