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

local function loadTestRoom()
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

local function loadGlompTest()
    loadTestRoom()

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
end

local function loadInteractTest()
    loadTestRoom()
    
    local q =
        Quest:make("fuck up a guy", "that guy needs a fuckin",
            {
                MakeQuestRewardAp(666),
            })

    Concord.entity(ECS.world)
        :assemble(ECS.a.physicsbody, 300)
        :give("testdraw")
        :give("interactable", function(e, finish)
            -- TODO: better system because this one removes the dialog component every time
            -- maybe the dialog component could be inactive or something yknow?
            -- idk.
            -- we could just have a dialog.isActive variable, but then the onFinish
            -- callback can't be passed from the interactable.
            -- then we could make a function, but that requires giving a function
            -- to the component 👎
            e
                :give("dialog", {
                    CreateDialogMessage("oh heyyy"),
                    CreateDialogMessage("wtf is up"),
                    StartQuestAndCreateActionMessage(q),
                }, finish)
        end)
end

local function loadQuests()
    Quest:make("AHHH", "ooo", nil)
    Quest:make("EEEE", "ooo", nil)
end

--- GAME STATE
local gameState = {}

--- MENU STATE
local menuState = {
    idx = 1,
    options = {
        { "Glomp test", function()
            loadGlompTest()
            Game.createPlayer(nil, Game.getHeight() - 132)
            Gamestate.switch(gameState)
        end },
        { "Interact test", function()
            loadInteractTest()
            Game.createPlayer(nil, Game.getHeight() - 132)
            Gamestate.switch(gameState)
        end }
    },
}
function menuState:enter()
    self.idx = 1
end

function menuState:update()
    local y = 0
    if Game.Input:pressed("up") then y = -1
    elseif Game.Input:pressed("down") then y = 1
    elseif Game.Input:pressed("confirm") then
        self.options[self.idx][2]()
    end
    self.idx = math.Clamp(self.idx + y, 1, #self.options)
end

function menuState:draw()
    love.graphics.push()

    local text = "Game menu"
    local font = love.graphics.setNewFont(18)
    local titleWidth = font:getWidth(text)
    local x, titleY = Game.getWidth() / 2, 128

    love.graphics.printf(text, x - titleWidth / 2, titleY, titleWidth, "center")

    for i, o in ipairs(self.options) do
        local prefix = ''

        if i == self.idx then
            prefix = '--> '
            love.graphics.setColor(1, 1, 0)
        end

        local t = string.format("%s%s- %s", prefix, i, o[1])
        local w = font:getWidth(t)
        love.graphics.printf(t, x - w / 2, titleY + (20 * i), w, "center")

        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.reset()
    love.graphics.pop()
end

function gameState:update(dt)
    ECS.world:emit("update", dt)

    if Game.Input:pressed('escape') then
        ECS.world:clear()
        Gamestate.switch(menuState)
    end
end

function gameState:draw()
    ECS.world:emit("draw")
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

    -- loadGlompTest()
    loadQuests()

    Gamestate.switch(menuState)
    -- Gamestate.switch(gameState)
end

function love.update(dt)
    Game.Input:update()
end

function love.draw()
    love.graphics.clear()
    Gamestate:current():draw()
end
