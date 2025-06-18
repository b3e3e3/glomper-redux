Util = require 'util'
Concord = require 'libraries.concord'

local Gamestate = require 'libraries.hump.gamestate'
local Quest = require 'game.quest'

Game = require 'game.engine.game'
ECS = require 'game.engine.ecs'

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
    ECS.s.hud,
    ECS.s.dialog
)

--- GAME STATE
local gameState = {}
function gameState:update(dt)
    ECS.world:emit("update", dt)
end

function gameState:draw()
    ECS.world:emit("draw")
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

    local q =
        Quest:make("fuck up a guy", "that guy needs a fuckin",
            {
                MakeQuestRewardAp(666),
            })

    Concord.entity(ECS.world)
        :assemble(ECS.a.physicsbody, 32)
        :give("testdraw")
        :give("interactable", function(e, finish)
            -- ECS.world:emit("say", {
            e:give('dialog', {
                CreateDialogMessage("oh heyyy"),
                CreateDialogMessage("wtf is up"),
                StartQuestAndCreateActionMessage(q),
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
    Quest:make("AHHH", "ooo", nil)
    Quest:make("EEEE", "ooo", nil)
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
