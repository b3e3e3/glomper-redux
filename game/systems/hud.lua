local Timer = require 'libraries.knife.timer'

local HUDSystem = Concord.system({
    pool = {
        'status'
    },
    dialog = {
        'dialog', 'position'
    }
})

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

function HUDSystem:dialogDraw()
    for _, e in ipairs(self.dialog) do
        -- if #e.dialog.all == 0 then goto continue end

        love.graphics.push()

        -- temp
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle("fill", e.position.x, e.position.y, 15)

        local boxMargin = 4
        local boxHeight = 128

        love.graphics.setColor(255/235, 255/230, 255/176)
        love.graphics.rectangle(
            "fill",
            boxMargin,
            Game.getHeight() - boxMargin - boxHeight,

            Game.getWidth() - boxMargin - boxMargin,
            boxHeight
        )

        love.graphics.pop()

        ::continue::
    end
end

function HUDSystem:say(message, e)
    e:give('dialog')
    -- local x, y = e.position.x, e.position.y
    -- if not message or message == "" then
    --     -- TODO: unsay
    --     return
    -- end
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
    self:dialogDraw()
    _questTextDraw()
end

function HUDSystem:questAdded(quest)
    table.insert(questTextQueue, quest.name)

    -- if questText then return end
    -- _displayNextQuestText()
end

return HUDSystem
