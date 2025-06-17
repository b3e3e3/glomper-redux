local Timer = require 'libraries.knife.timer'

local HUDSystem = Concord.system({
    pool = {
        'status'
    }
})

local sayText = {}

local questText = nil
local questTextQueue = {}

local function _displayNextQuestText()
    if #questTextQueue == 0 then return end

    Game.setFreeze(true)

    questText = questTextQueue[1]
    table.remove(questTextQueue, 1)

    -- TODO: states
    Timer.after(2, function()
        questText = "Clear!"

        Timer.after(0.6, function()
            questText = nil
            Game.setFreeze(false)
            Timer.after(1, function()
                _displayNextQuestText()
            end)
        end)
    end)
end

local function _questTextDraw()
    if questText and questText ~= "" then
        love.graphics.print(questText, Game.getWidth() / 2, Game.getHeight() / 2)
    end
end

local function _tempSayDraw()
    if sayText.message and sayText.message ~= "" then
        love.graphics.print(sayText.message, sayText.x, sayText.y)
    end
end

function HUDSystem:tempSay(message, x, y)
    if not message or message == "" then
        sayText = {
            message = "",
            x = 0,
            y = 0,
        }
        return
    end
    -- TODO: temp
    sayText.message = message
    sayText.x = x + 32
    sayText.y = y - 32
end

function HUDSystem:statusDraw()
    local e = self.pool[1] -- TODO: decide on loop or singleton??
    -- for _, e in ipairs(self.pool) do
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('HP: ' .. e.status.hp, 16, 16)
    love.graphics.print('AP: ' .. e.status.ap, 16, 32)
    -- end
end

function HUDSystem:update(dt)
    Timer.update(dt)
end

function HUDSystem:draw()
    self:statusDraw()
    _questTextDraw()
    _tempSayDraw()
end

function HUDSystem:questAdded(quest)
    table.insert(questTextQueue, quest.name)

    -- if questText then return end
    -- _displayNextQuestText()
end

return HUDSystem
