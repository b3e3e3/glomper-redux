function CreateDialogMessage(text, portrait, type)
    portrait = portrait or ""

    return {
        text = text,
        portrait = portrait,
        type = type,
    }
end

local dialog = Concord.component("dialog", function(c, messages, onFinished)
    c._index = 0
    c.finished = false

    c.queue = messages or {}
    c.onFinished = onFinished or function() end

    c.current = function()
        if c._index > #c.queue then return nil end
        if c._index <= 0 then return nil end
        return c.queue[c._index]
    end

    c.next = function() -- TODO: system
        c._index = c._index + 1
        return c.current()
    end
end)
