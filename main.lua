Concord = require 'libraries.concord'
Bump = require 'libraries.bump'

Game = {
    bumpWorld = Bump.newWorld(),--64),
    Input = require 'game.input',
    Physics = require 'game.physics',
}

ECS = {
    c = Concord.components,
    a = {},
    s = {},
    world = Concord.world(),
}

Concord.utils.loadNamespace("game/components")

Concord.utils.loadNamespace("game/assemblages", ECS.a)
Concord.utils.loadNamespace("game/systems", ECS.s)

ECS.world:addSystems( -- TODO: auomate this? or not?
    ECS.s.glomp,
    ECS.s.physics,
    ECS.s.player,
    ECS.s.testdraw
)

function ECS.world:onEntityAdded(e)
    ECS.world:emit("onEntityAdded", e)
end

function ECS.world:onEntityRemoved(e)
    ECS.world:emit("onEntityRemoved", e)
end

function love.load()
    ECS.world:emit("init")

    local playerEntity =
    Concord.entity(ECS.world)
    :assemble(ECS.a.player)

    local testObject = Concord.entity(ECS.world)
    :assemble(ECS.a.physicsbody, love.graphics.getWidth() / 4)
    :give("glompable")
    :give("testdraw")

    local floor = Concord.entity(ECS.world)
    :assemble(ECS.a.staticbody, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), 100)
    :give("testdraw")
end

function love.update(dt)
    ECS.world:emit("update", dt)
end

function love.draw()
    ECS.world:emit("draw")
end
