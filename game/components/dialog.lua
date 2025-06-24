local advanceCooldown = 0.5

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

function CreateActionMessage(action) return CreateDialogMessage(nil, nil, nil, action) end

function CreateStartQuestActionMessage(quest)
    -- TODO: create a specific toast for quests
    return CreateActionMessage(function(onFinished)
        print("Starting quest " .. quest.name .. "!")
        onFinished()
        Game.startQuest(quest)
    end)
end

function CreateWaitActionMessage(time, panelVisible)
    local msg = CreateActionMessage(function(onFinished)
        Timer.after(time, onFinished)
    end)

    if true then msg.text = "..." end

    return msg
end

local dialog = Concord.component("dialog", function(c, messages, onFinished)
    c.__canAdvance = false
    c.__ranAction = false
    c.__idx = 0

    c.queue = messages or {}
    c.onFinished = onFinished or function() end

    c.get = function(index)
        if index > #c.queue then return nil end
        if index <= 0 then return nil end
        return c.queue[index]
    end

    -- TODO: system ?
    c.isLast = function() return c.__idx > #c.queue end
    c.current = function() return c.get(c.__idx) end
    c.next = function() return c.get(c.__idx + 1) end
    c.advance = function(force)
        force = force or false
        if not force and not c.__canAdvance then return end

        print("Advancing!", c.__idx, '->', c.__idx + 1)
        c.__idx = c.__idx + 1
        local cur = c.current()

        Timer.after(advanceCooldown, function()
            c.__canAdvance = true
        end)

        return cur
    end
end)
