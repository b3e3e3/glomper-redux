Concord = require 'libraries.concord'
Input = require 'input'

ECS = {
    c = Concord.components,
    a = {},
    s = {},
}

Concord.utils.loadNamespace("game/components")
Concord.utils.loadNamespace("game/assemblages", ECS.a)
Concord.utils.loadNamespace("game/systems", ECS.s)

local world = Concord.world()
world:addSystems( -- TODO: auomate this? or not?
    ECS.s.move,
    ECS.s.player,
    ECS.s.testdraw
)

local playerEntity =
    Concord.entity(world)
    :assemble(ECS.a.player)

function love.load()
    world:emit("init")
end

function love.update(dt)
    world:emit("update", dt)
end

function love.draw()
    world:emit("draw")
end
