Concord = require 'libraries.concord'
bump = require 'libraries.bump'
Input = require 'input'

Game = {
    bumpWorld = bump.newWorld()--64)
}

ECS = {
    c = Concord.components,
    a = {},
    s = {},
    world = Concord.world(),
}

function ECS.world:onEntityAdded(e)
    ECS.world:emit("onEntityAdded", e)
end

function ECS.world:onEntityRemoved(e)
    ECS.world:emit("onEntityRemoved", e)
end

Concord.utils.loadNamespace("game/components")
Concord.utils.loadNamespace("game/assemblages", ECS.a)
Concord.utils.loadNamespace("game/systems", ECS.s)

ECS.world:addSystems( -- TODO: auomate this? or not?
    ECS.s.physics,
    ECS.s.player,
    ECS.s.testdraw,
    ECS.s.glomp
)

local playerEntity =
    Concord.entity(ECS.world)
    :assemble(ECS.a.player)

function love.load()
    ECS.world:emit("init")

    -- HACK: create floor
    Game.bumpWorld:add(
        { isSolid = true },
        0, love.graphics.getHeight() - 100,
        love.graphics.getWidth(), 100
    )
end

function love.update(dt)
    ECS.world:emit("update", dt)
end

function love.draw()
    ECS.world:emit("draw")
end
