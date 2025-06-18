local Timer = require 'libraries.knife.timer'

-- TODO: decouple dialog system
local HUDSystem = Concord.system({
    pool = {
        'status'
    },
})

local questText
local questTextQueue = {}

local pane

local function _displayNextQuestText()
    if #questTextQueue == 0 then return end

    Game.setFreeze(true)

    questText = questTextQueue[1]
    table.remove(questTextQueue, 1)

    -- TODO: states
    Timer.after(2, function()
        questText = nil
        Game.setFreeze(false)
        Timer.after(1, function()
            _displayNextQuestText()
        end)
    end)
end

local function _questTextDraw()
    if questText and questText ~= "" then
        love.graphics.print(questText, Game.getWidth() / 2, Game.getHeight() / 2)
    end
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
end

function HUDSystem:questAdded(quest)
    table.insert(questTextQueue, quest.name)

    if questText then return end
    _displayNextQuestText()
end

return HUDSystem
