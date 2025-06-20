local Timer = require 'libraries.hump.timer'

local DialogSystem = Concord.system({
    panes = {
        'pane', 'position', 'size'
    }
})

local function _dialogFinish(e)
    if e.dialog.finished then return end

    e.dialog.finished = true
    e.dialog.onFinished()
end

local function _isPaneDoneGrowing(e)
    return e.pane.behavior.state ~= 'growing'
end

function DialogSystem:update(dt)
    Timer.update(dt)
    for _, p in ipairs(self.panes) do
        p.pane.behavior:update(dt)

        local __shouldContinue = function(dialog)
            local isAction = dialog and not dialog.text
            return _isPaneDoneGrowing(p)
                and (Game.Input:pressed("interact")
                    or isAction)
        end

        local lastDialog = p.dialog.current()
        if __shouldContinue(lastDialog) then -- for if there is no message but an action
            local dialog = p.dialog.advance()
            if dialog ~= nil then
                p.dialog.finished = false
                -- action before would go here
            else
                if p.dialog.finished then goto continue end
                _dialogFinish(p)
            end

            if lastDialog ~= nil then
                lastDialog.action() -- TODO: action before or after?
            end
        end

        ::continue::
    end
end

function DialogSystem:draw()
    for _, p in ipairs(self.panes) do
        local currentDialog = p.dialog.current()
        if not currentDialog then goto continue end
        love.graphics.push()

        local textMargin = 8
        local baseX, baseY = p.position.x, p.position.y

        local __drawPane = function()
            p.pane.ui:resize(p.size.w, p.size.h)
            p.pane.ui:draw(baseX + p.pane.margin, baseY - p.pane.margin - p.pane.targetSize.h)
            -- p.pane.ui:draw(baseX + p.pane.margin, baseY - p.pane.margin - p.pane.targetSize.h) -- THIS WAY makes it grow from the bottom up
        end

        local __drawText = function()
            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(Game.Fonts.header)

            local cx, cy, cw, ch = p.pane.ui:getContentWindow()
            love.graphics.setScissor(cx, cy, cw, ch)
            love.graphics.printf(p.dialog.current().text, cx + textMargin, cy + textMargin, cw - textMargin, "left")
            love.graphics.setScissor()
        end

        if currentDialog.text then
            __drawPane()
            if _isPaneDoneGrowing(p) then __drawText() end

            love.graphics.reset()
        end

        love.graphics.pop()

        ::continue::
    end
end

local function _initPane(e)
    e.pane.targetSize.w, e.pane.targetSize.h = e.size.w, e.size.h
    e.size.w, e.size.h = 0, 0

    e.pane.behavior:setState('growing')
    e.dialog.advance()
end

function DialogSystem:say(e, messages, onFinished)
    if e == nil then return end

    local width, height = 320, 128
    local margin = 16

    local pane = Concord.entity(ECS.world)
        :assemble(ECS.a.dialogpane,
            e.position.x, e.position.y,
            width,
            height,
            margin
        )
        :give('dialog', messages, onFinished)



    _initPane(pane)
end

return DialogSystem
