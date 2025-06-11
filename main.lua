local _ = require 'util'

Bump = require 'libraries.bump'
Concord = require 'libraries.concord'

Gamestate = require 'libraries.hump.gamestate'

Game = {
    bumpWorld = Bump.newWorld(), --64),
    Input = require 'game.input',
    Physics = require 'game.physics',
}

function Game.createPlayer(x, y)
    return Concord.entity(ECS.world)
        :assemble(ECS.a.player, x, y)
end

function Game.createProjectile(e)
    return Concord.entity(ECS.world)
    :assemble(ECS.a.projectile,
        e.position.x + 32,
        e.position.y,
        e.size.x, e.size.y,
        e.direction.last
    )
    :give("testdraw")
end

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
    ECS.s.testdraw,
    ECS.s.projectile
)

function ECS.world:onEntityAdded(e)
    ECS.world:emit("onEntityAdded", e)
end

function ECS.world:onEntityRemoved(e)
    ECS.world:emit("onEntityRemoved", e)
end

local gameState = {}
function gameState:enter()
    ECS.world:emit("init")

    local playerEntity = Game.createPlayer(nil, love.graphics.getHeight() - 132)

    -- local testObject = Concord.entity(ECS.world)
    --     :assemble(ECS.a.physicsbody, love.graphics.getWidth() / 4)
    --     :give("glompable")
    --     :give("testdraw")
    for i = 1, 5, 1 do
        if i ~= 3 then
            Concord.entity(ECS.world)
            :assemble(ECS.a.physicsbody, (love.graphics.getWidth() / 4) + (i*64))
            :give("glompable")
            :give("testdraw")

            if i == 5 then
                local e = Concord.entity(ECS.world)
                :assemble(ECS.a.physicsbody, (love.graphics.getWidth() / 4) + (i*64))
                :give("glompable")
                :give("testdraw")
                e.position.y = e.position.y - 32
            end
        end
    end

    local floor = Concord.entity(ECS.world)
        :assemble(ECS.a.staticbody, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), 100)
        :give("testdraw")

    local thickness = 32
    local walls = {
        Concord.entity(ECS.world)
            :assemble(ECS.a.staticbody,
            -thickness, 0,
            thickness, love.graphics.getHeight()
        ),
        Concord.entity(ECS.world)
            :assemble(ECS.a.staticbody,
            love.graphics.getWidth(), 0,
            thickness, love.graphics.getHeight()
        )
    }
end

function gameState:update(dt)
    ECS.world:emit("update", dt)
end

function gameState:draw()
    ECS.world:emit("draw")
end

local menuState = {}
function menuState:draw()
    if Game.Input:pressed('confirm') then Gamestate.switch(gameState) end

    love.graphics.print('press ENTER to start', 200, 200)
end

function love.load()
    Gamestate.registerEvents()
    -- Gamestate.switch(menuState)
    Gamestate.switch(gameState)
end

function love.update(dt)
    Game.Input:update()
end