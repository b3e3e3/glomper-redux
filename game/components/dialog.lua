local Timer = require 'libraries.hump.timer'

function CreateDialogMessage(text, portrait, type, action)
    portrait = portrait or ''
    type = type or 'normal'
    action = action

    return {
        text = text,
        portrait = portrait,
        type = type,
        action = action,
    }
end

function CreateStartQuestActionMessage(quest)
    -- TODO: create a specific toast for quests
    return {
        action = function(onFinished)
            onFinished()
            Game.startQuest(quest)
        end
    }
end

function CreateWaitActionMessage(time, panelVisible)
    local msg = {
        action = function(onFinished)
            Timer.after(time, onFinished)
        end
    }

    if true then msg.text = "..." end

    return msg
end

local dialog = Concord.component("dialog", function(c, messages, onFinished)
    c._idx = 0
    c.finished = false

    c.queue = messages or {}
    c.onFinished = onFinished or function() end

    c.get = function(index)
        if index > #c.queue then return nil end
        if index <= 0 then return nil end
        return c.queue[index]
    end

    -- TODO: system ?
    c.current = function() return c.get(c._idx) end
    c.next = function() return c.get(c._idx + 1) end
    c.advance = function()
        print("Advancing!", c._idx, '->', c._idx + 1)
        c._idx = c._idx + 1
        return c.current()
    end
end)
