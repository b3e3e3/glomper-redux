local Bind = require 'libraries.knife.bind'
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
        glomp =
        {
            name = "glomp up 3 guys!?",
            desc = "no desc wtf",
            kills = 0,
            signals = {
                {
                    name = "entityKilled",
                    action = function(finish, quest, e, by)
                        local isPlayer = Game.entityIsPlayer(by)
                        print('By has controller?', isPlayer)
                        if not isPlayer then
                            return
                        end
                        quest.kills = quest.kills + 1
                        if quest.kills < 1 then
                            print(string.format('%s to go', 3 - quest.kills))
                        else
                            print(quest.name .. " complete!", e)
                            finish()
                        end
                    end
                }
            },
            rewards = {
                QuestData.MakeQuestRewardAp(666),
            }
        },

        test =
        {
            name = "A very serious Test of Quests!?!",
            desc = "This is a test",
            rewards = {
                QuestData.MakeQuestRewardAp(666),
            },
            signals = {
                name = "update",
                action = function(finish, quest)
                    print("Finishing quest " .. quest.name)
                    finish()
                end
            }
        },
    },

    _frozen = false,
}

local questmt = {
    _id = nil,
    _finished = false,
}

function questmt:bindSignals(e)
    if self.signals and #self.signals > 0 then
        for _, s in ipairs(self.signals) do
            print(s.name, s.action)
            local finish = function()
                Game.finishQuest(e)
            end
            s._boundAction = Bind(s.action, finish, self)
            Signal.register(s.name, s._boundAction)
        end
    end
end

function questmt:unbindSignals()
    if self.signals and #self.signals > 0 then
        for _, s in ipairs(self.signals) do
            Signal.remove(s.name, s._boundAction) -- TODO: does this Bind count as the same func?
            s._boundAction = nil
        end
    end
end

function questmt:getId() return self._id end

function questmt:isFinished() return Game.Quests[self:getId()]._finished end

function questmt:setFinished()
    self:unbindSignals()
    Game.Quests[self:getId()]._finished = true
end

for i, v in pairs(Game.Quests) do
    v = setmetatable(v, { __index = questmt })
    v._id = i
end

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
    if Game.questIsActive(questData) then
        print('QUEST ACTIVE!')
        return false
    end

    timeForTextToRemain = timeForTextToRemain or nil
    ECS.world:emit("questStarted", questData, timeForTextToRemain)

    return true
end

function Game.finishQuest(questEntity, timeForTextToRemain)
    timeForTextToRemain = timeForTextToRemain or nil
    ECS.world:emit("questFinished", questEntity, timeForTextToRemain)
end

function Game.questIsActive(questData)
    local questSystem = ECS.world:getSystem(ECS.s.quest)
    return questSystem:isActive(questData)
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

function Game.entityIsPlayer(e) return e:has('controller') end

return Game
