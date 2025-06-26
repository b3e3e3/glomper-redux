local Behavior = require 'libraries.knife.behavior'

local questtoast = Concord.component("questtoast",
    function(c, questData, duration, states)                                                --name, desc, rewards)
        c.behavior = Behavior(states)

        questData = questData or {
            name = "No data",
            desc = "Quest data nil",
        }

        c.name = questData.name or "A default event?!"
        c.desc = questData.desc or "The details of this event have been neglected :("
        c.duration = duration or 3
        -- c.rewards = questData.rewards or {}
    end)
