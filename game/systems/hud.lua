local Timer = require 'libraries.knife.timer'
local slicy = require 'libraries.slicy'

-- TODO: decouple dialog system
local HUDSystem = Concord.system({
    pool = {
        'status'
    },
    dialog = {
        'dialog', 'position', 'interactable'
    }
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

function HUDSystem:init()
    pane = slicy.load('assets/box.9.png')
end

function HUDSystem:dialogDraw()
    for _, e in ipairs(self.dialog) do
        local currentDialog = e.dialog.current()
        if not currentDialog then goto continue end

        love.graphics.push()

        local boxMargin = 32
        local boxHeight = 128
        local textMargin = 8

        local baseX, baseY = 0, e.position.y
        if pane and currentDialog.text then
            local width, height = (256 + 64 - boxMargin - boxMargin), boxHeight

            pane:resize(math.floor(width), math.floor(height))
            pane:draw(baseX + boxMargin, baseY - boxMargin - boxHeight)

            love.graphics.reset()
            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(Game.Fonts.header)

            local cx, cy, cw, ch = pane:getContentWindow()
            love.graphics.setScissor(cx, cy, cw, ch)
            love.graphics.printf(e.dialog.current().text, cx + textMargin, cy + textMargin, cw - textMargin, "left")
            love.graphics.setScissor()

            love.graphics.setNewFont()
        end

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
    e.dialog._idx = 0
end

function HUDSystem:update(dt)
    Timer.update(dt)

    for _, e in ipairs(self.dialog) do
        -- print(e.dialog.finished, nextDialog, #e.dialog.queue, e.dialog._index)
        local lastDialog = e.dialog.current()
        if Game.Input:pressed("interact")
            or (lastDialog and not lastDialog.text) -- for if there is no message but an action
        then
            local dialog = e.dialog.advance()
            if dialog ~= nil then
                e.dialog.finished = false
                -- action before would go here
            else
                if e.dialog.finished then goto continue end
                self:dialogFinish(e)
            end

            if lastDialog ~= nil then
                -- TODO: action before or after?
                -- this is the way for action after
                lastDialog.action()
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

    if questText then return end
    _displayNextQuestText()
end

return HUDSystem
