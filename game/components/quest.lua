local questdata = Concord.component("questdata", function(c, questData)
    questData = questData or {
        name = "No data",
        desc = "Quest data nil",
    }

    c.name = questData.name or "A default event?!"
    c.desc = questData.desc or "The details of this event have been neglected :("
    -- c.rewards = questData.rewards or {}
end)
