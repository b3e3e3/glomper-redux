local Quest = require 'game.quest'

function CreateDialogMessage(text, portrait, type, action)
    portrait = portrait or ''
    type = type or 'normal'
    action = action or function() end

    return {
        text = text,
        portrait = portrait,
        type = type,
        action = action,
    }
end

function StartQuestAndCreateToastMessage(quest)
    -- TODO: create a specific toast for quests
    local message = CreateDialogMessage(quest.name)
    message.action = function()
        Game.startQuest(quest)
    end

    return message
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

    c.current = function()
        return c.get(c._idx)
    end

    c.next = function() -- TODO: system
        return c.get(c._idx + 1)
    end

    c.advance = function()
        print("Advancing!", c._idx, '->', c._idx + 1)
        c._idx = c._idx + 1
        return c.current()
    end
end)
