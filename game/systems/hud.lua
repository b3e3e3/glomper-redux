local Timer = require 'libraries.knife.timer'

local HUDSystem = Concord.system({
    pool = {
        'status'
    }
})

local questText = nil
local questTextQueue = {}

function HUDSystem:update(dt)
    Timer.update(dt)
end

function HUDSystem:draw()
    local e = self.pool[1] -- TODO: loop or singleton??
    -- for _, e in ipairs(self.pool) do
    love.graphics.setColor(1,1,1)
    love.graphics.print('HP: ' .. e.status.hp, 16, 16)
    love.graphics.print('AP: ' .. e.status.ap, 16, 32)
    -- end

    if questText and questText ~= "" then
        love.graphics.print(questText, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    end
end

local function displayNextQuestText()
    if #questTextQueue == 0 then return end

    ECS.world:emit("freeze")

    questText = questTextQueue[1]
    table.remove(questTextQueue, 1)

    Timer.after(2, function()
        questText = "Clear!"

        Timer.after(0.6, function()
            questText = nil
            ECS.world:emit("freeze")
            Timer.after(1, function()
                displayNextQuestText()
            end)
        end)
    end)
end

function HUDSystem:questAdded(quest)
    table.insert(questTextQueue, quest.name)
    
    if questText then return end
    displayNextQuestText()
end

return HUDSystem