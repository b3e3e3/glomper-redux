local Timer = require 'libraries.knife.timer'

-- TODO: decouple dialog system
local HUDSystem = Concord.system({
    pool = {
        'status'
    },
    dialog = {
        'dialog', 'position', 'interactable'
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
        if not e.dialog.current() then goto continue end

        love.graphics.push()

        local pointMargin = 24
        local pointWidth = 8
        local boxMargin = 32
        local boxHeight = 128
        local textMargin = 8

        -- local r, g, b = 97.3 / 100, 91 / 100, 84.7 / 100
        local r, g, b = 248 / 255, 232 / 255, 216 / 255

        local baseX, baseY = 0, e.position.y

        love.graphics.setColor(r, g, b)
        love.graphics.polygon("fill", {
            baseX + 32 + pointMargin, baseY - boxMargin,
            baseX + 32 + pointMargin, baseY,
            baseX + 32 + pointMargin + (pointWidth * 2), baseY - boxMargin,
        })

        love.graphics.rectangle(
            "fill",
            baseX + boxMargin,
            baseY - boxMargin - boxHeight,

            256 + 64 - boxMargin - boxMargin,
            boxHeight
        )

        love.graphics.setColor(0, 0, 0)
        love.graphics.setNewFont(18)
        love.graphics.print(e.dialog.current().text,
            baseX + boxMargin + textMargin,
            baseY - boxMargin - boxHeight + textMargin)
        love.graphics.setNewFont()

        love.graphics.pop()

        ::continue::
    end
end

-- function HUDSystem:say(messages, e, onFinished)
--     if e ~= nil then
--         e:ensure('dialog', messages, onFinished)
--     end
--     -- local x, y = e.position.x, e.position.y
--     -- if not message or message == "" then
--     --     -- TODO: unsay
--     --     return
--     -- end
-- end

function HUDSystem:statusDraw()
    local e = self.pool[1] -- TODO: decide on loop or singleton??
    -- for _, e in ipairs(self.pool) do
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('HP: ' .. e.status.hp, 16, 16)
    love.graphics.print('AP: ' .. e.status.ap, 16, 32)
    -- end
end

function HUDSystem:dialogFinish(e)
    if e.dialog.finished then return end
    e.dialog.finished = true

    e.dialog.onFinished()
    e.dialog._index = 0
end

function HUDSystem:update(dt)
    Timer.update(dt)

    for _, e in ipairs(self.dialog) do
        local nextDialog = nil
        if Game.Input:pressed("interact") then
            nextDialog = e.dialog.next()
            print("Next dialog? " .. tostring(nextDialog==nil))
            if nextDialog ~= nil then
                e.dialog.finished = false
            else
                self:dialogFinish(e)
                goto continue
            end
        end

        ::continue::
    end
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
