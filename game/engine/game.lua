local Bump = require 'libraries.bump'
local Quest = require 'game.quest'

local _player = nil

local Game = {
    bumpWorld = Bump.newWorld(), --64),
    Input = require 'game.input',
    Physics = require 'game.physics',
    Quests = {},

    Fonts = {
        header = love.graphics.newFont(
            'assets/font/Whacky_Joe_Monospaced_BM.fnt',
            'assets/font/Whacky_Joe_Monospaced_BM_0.png'
        )
    },

    _frozen = false,
}

function Game.setFreeze(shouldFreeze, entity)
    entity = entity or nil
    if shouldFreeze == nil then
        if entity then
            shouldFreeze = not entity:has('freeze')
        else
            shouldFreeze = not Game._frozen
        end
    end

    Game._frozen = shouldFreeze
    ECS.world:emit("freeze", shouldFreeze, entity)
end

-- Quests
function Game.startQuest(quest, timeForTextToRemain)
    timeForTextToRemain = timeForTextToRemain or nil
    ECS.world:emit("questAdded", quest, timeForTextToRemain)
end

function Game.finishQuest(quest, timeForTextToRemain)
    timeForTextToRemain = timeForTextToRemain or nil
    ECS.world:emit("questFinished", quest, timeForTextToRemain)
end

-- Player
function Game.getPlayer() return _player end

function Game.createPlayer(x, y)
    _player = Concord.entity(ECS.world)
        :assemble(ECS.a.player, x, y)
    return _player
end

-- Projectile
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

-- Utils
function Game.getWidth() return love.graphics.getWidth() end

function Game.getHeight() return love.graphics.getHeight() end

return Game
