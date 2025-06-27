local Bump = require 'libraries.bump'

local QuestData = require 'game.questdata'

local _player = nil

local Game = {
    bumpWorld = Bump.newWorld(), --64),
    Input = require 'game.input',
    Physics = require 'game.physics',

    Fonts = {
        header = love.graphics.newFont(
            'assets/font/Whacky_Joe_Monospaced_BM.fnt',
            'assets/font/Whacky_Joe_Monospaced_BM_0.png'
        )
    },

    Quests = {
        -- Quest:make(
        glomp = {
            name = "glomp up a guy!?",
            desc = "that guy needs a glompin",
            signals = {
                {
                    name = "entityKilled",
                    action = function(quest, e, by)
                        print(quest.questdata.name .. " complete!", e)
                        Game.finishQuest(quest)
                    end
                }
            },
            rewards = {
                MakeQuestRewardAp(666),
            }
        },

        test =
        {
            name = "A very serious Test of Quests!?!",
            desc = "This is a test",
            rewards = {
                MakeQuestRewardAp(666),
            }
        },
    },

    _frozen = false,
}

function Game.setFreeze(shouldFreeze, entity)
    entity = entity or nil

    if not entity then
        Game._frozen = shouldFreeze -- ONLY set frozen if it's for all entities
    end
    if shouldFreeze == nil then
        if entity then
            shouldFreeze = not entity:has('freeze')
        else
            shouldFreeze = not Game._frozen
        end
    end

    ECS.world:emit("freeze", shouldFreeze, entity)
end

-- Quests
function Game.startQuest(questData, timeForTextToRemain)
    timeForTextToRemain = timeForTextToRemain or nil
    ECS.world:emit("questStarted", questData, timeForTextToRemain)
end

function Game.finishQuest(questEntity, timeForTextToRemain)
    timeForTextToRemain = timeForTextToRemain or nil
    ECS.world:emit("questFinished", questEntity, timeForTextToRemain)
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
