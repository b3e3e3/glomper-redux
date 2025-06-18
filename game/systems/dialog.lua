local slicy = require 'libraries.slicy'

local DialogSystem = Concord.system({
    space = {
        'dialog', 'position', 'interactable'
    }
})

local pane

function DialogSystem:init()
    pane = slicy.load('assets/box.9.png')
end

local function _dialogFinish(e)
    if e.dialog.finished then return end
    e.dialog.finished = true

    e.dialog.onFinished()
    e.dialog._idx = 0

    e:remove('dialog')
end

function DialogSystem:update(dt)
    local __shouldContinue = function(dialog)
        local isAction = dialog and not dialog.text

        return Game.Input:pressed("interact")
            or isAction
    end

    for _, e in ipairs(self.space) do
        local lastDialog = e.dialog.current()

        if __shouldContinue(lastDialog) then -- for if there is no message but an action
            local dialog = e.dialog.advance()
            if dialog ~= nil then
                e.dialog.finished = false
                -- action before would go here
            else
                if e.dialog.finished then goto continue end
                _dialogFinish(e)
            end

            if lastDialog ~= nil then
                lastDialog.action() -- TODO: action before or after?
            end
        end

        ::continue::
    end
end

function DialogSystem:draw()
    for _, e in ipairs(self.space) do
        local currentDialog = e.dialog.current()
        if not currentDialog then goto continue end

        love.graphics.push()

        local boxMargin = 32
        local boxHeight = 128
        local textMargin = 8

        local baseX, baseY = 0, e.position.y

        local __drawPane = function()
            local width, height = (256 + 64 - boxMargin - boxMargin), boxHeight

            pane:resize(math.floor(width), math.floor(height))
            pane:draw(baseX + boxMargin, baseY - boxMargin - boxHeight)
        end

        local __drawText = function()
            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(Game.Fonts.header)

            local cx, cy, cw, ch = pane:getContentWindow()
            love.graphics.setScissor(cx, cy, cw, ch)
            love.graphics.printf(e.dialog.current().text, cx + textMargin, cy + textMargin, cw - textMargin, "left")
            love.graphics.setScissor()
        end

        if pane and currentDialog.text then
            __drawPane()
            __drawText()

            love.graphics.reset()
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

return DialogSystem
