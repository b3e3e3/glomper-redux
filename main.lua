Util = require 'util'

Bump = require 'libraries.bump'
Concord = require 'libraries.concord'
local Gamestate = require 'libraries.hump.gamestate'
local Timer = require 'libraries.knife.timer'

Quest = require 'game.quest'

local _player = nil

ECS = {
    c = Concord.components,
    a = {},
    s = {},
    world = Concord.world(),
}

Game = {
    bumpWorld = Bump.newWorld(), --64),
    Input = require 'game.input',
    Physics = require 'game.physics',
    Quests = {},

    _frozen = false,
}

function Game.setFreeze(shouldFreeze, entity)
    entity = entity or nil
    if shouldFreeze == nil then
        shouldFreeze = not Game._frozen
    end

    Game._frozen = shouldFreeze
    ECS.world:emit("freeze", shouldFreeze, entity)
end

function Game.getWidth()
    return love.graphics.getWidth()
end

function Game.getHeight()
    return love.graphics.getHeight()
end

function Game.getPlayer()
    return _player
end

function Game.createQuest(name, desc, rewards)
    local q = Quest:make(name, desc, rewards)

    table.insert(Game.Quests, q)
    ECS.world:emit("questAdded", q)

    return q
end

function Game.createPlayer(x, y)
    _player = Concord.entity(ECS.world)
        :assemble(ECS.a.player, x, y)
    return _player
end

function Game.createProjectile(e)
    return Concord.entity(ECS.world)
        :assemble(ECS.a.projectile,
            e.position.x + (e.size.w * e.direction.last),
            e.position.y,
            e.size.x, e.size.y,
            e.direction.last
        )
        :give("testdraw")
end

Concord.utils.loadNamespace("game/components")

Concord.utils.loadNamespace("game/assemblages", ECS.a)
Concord.utils.loadNamespace("game/systems", ECS.s)

ECS.world:addSystems(
    ECS.s.physics,
    ECS.s.testdraw,
    ECS.s.player,
    ECS.s.glomp,
    ECS.s.projectile,
    ECS.s.interact,
    ECS.s.hud
)

function ECS.world:onEntityAdded(e)
    ECS.world:emit("onEntityAdded", e)
end

function ECS.world:onEntityRemoved(e)
    ECS.world:emit("onEntityRemoved", e)
end

--- GAME STATE
local gameState = {}
function gameState:update(dt)
    ECS.world:emit("update", dt)
end

function gameState:draw()
    ECS.world:emit("draw")
end

--- TEXT STATE
local textState = {}
function textState:enter()
    Game.setFreeze(true) -- ECS.world:emit("freeze", true)
end

function textState:update(dt)
    ECS.world:emit("update", dt)
end

function textState:draw()
    ECS.world:emit("draw")
end

function textState:exit()
    Game.setFreeze(false) -- ECS.world:emit("freeze", false)
end

--- MENU STATE
local menuState = {}
function menuState:draw()
    if Game.Input:pressed('confirm') then Gamestate.switch(gameState) end

    love.graphics.print('press ENTER to start', 200, 200)
end

local function loadObjects()
    for i = 1, 5, 1 do
        if i ~= 3 then
            Concord.entity(ECS.world)
                :assemble(ECS.a.physicsbody, (Game.getWidth() / 4) + (i * 64))
                :give("glompable")
                :give("testdraw")

            if i == 5 then
                local e = Concord.entity(ECS.world)
                    :assemble(ECS.a.physicsbody, (Game.getWidth() / 4) + (i * 64))
                    :give("glompable")
                    :give("testdraw")
                e.position.y = e.position.y - 32
            end
        end
    end

    Concord.entity(ECS.world)
        :assemble(ECS.a.physicsbody, 32)
        :give("testdraw")
        :give("interactable", function(e, finish)
            -- ECS.world:emit("say", {
            --     CreateDialogMessage("oh heyyy"),
            --     CreateDialogMessage("wtf is up"),
            -- }, e, finish)
            
            e:ensure('dialog', {
                CreateDialogMessage("oh heyyy"),
                CreateDialogMessage("wtf is up"),
            }, finish)
        end)

    local floor = Concord.entity(ECS.world)
        :assemble(ECS.a.staticbody, 0, Game.getHeight() - 100, Game.getWidth(), 100)
        :give("testdraw")

    local thickness = 32
    local walls = {
        Concord.entity(ECS.world)
            :assemble(ECS.a.staticbody,
                -thickness, 0,
                thickness, Game.getHeight()
            ):give("wall"), -- TODO: assemblage
        Concord.entity(ECS.world)
            :assemble(ECS.a.staticbody,
                Game.getWidth(), 0,
                thickness, Game.getHeight()
            ):give("wall"), -- TODO: assemblage
    }
end

local function loadQuests()
    Game.createQuest("AHHH", "ooo", nil)
    Game.createQuest("EEEE", "ooo", nil)
end

function love.load()
    Gamestate.registerEvents({
        'init',
        'enter',
        'leave',
        'resume',
        'update',
        'focus',
        'keypressed',
        'keyreleased',
        'mousepressed',
        'mousereleased',
        'joystickpressed',
        'joystickreleased',
        'quit',
    })

    ECS.world:emit("init")

    local playerEntity = Game.createPlayer(nil, Game.getHeight() - 132)

    loadObjects()
    loadQuests()

    -- Gamestate.switch(menuState)
    Gamestate.switch(gameState)
end

function love.update(dt)
    Game.Input:update()
end

function love.draw()
    love.graphics.clear()
    Gamestate:current():draw()
end
