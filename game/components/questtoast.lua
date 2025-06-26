local Behavior = require 'libraries.knife.behavior'

local makeAnimStates = function()
    return {
        default = {
            {
                spaceMod = 0,
                duration = 999,
            },
        },
        idle = {
            {
                spaceMod = 1,
                duration = 999,
            },
        },
        growing = {
            {
                spaceMod = 0,
                duration = 0.5,
                action = function(behavior, _)
                    ECS.world:emit('questToastOpened')
                    Timer.tween(0.5, behavior.frame, {
                        spaceMod = 1,
                    }, 'linear')
                end,
                after = 'idle',
            },
        },
        shrinking = {
            {
                spaceMod = 1,
                duration = 0.5,
                action = function(behavior, _)
                    Timer.tween(0.5, behavior.frame, {
                        spaceMod = 0,
                    }, 'linear')
                end,
            },
            {
                spaceMod = 0,
                duration = 0.1,
                action = function()
                    ECS.world:emit('questToastClosed')
                end,
                after = 'default',
            }
        }
    }
end

local questtoast = Concord.component("questtoast",
    function(c, questData, duration)                                                --name, desc, rewards)
        c.behavior = Behavior(makeAnimStates())

        questData = questData or {
            name = "No data",
            desc = "Quest data nil",
        }

        c.name = questData.name or "A default event?!"
        c.desc = questData.desc or "The details of this event have been neglected :("
        c.duration = duration or 3
        -- c.rewards = questData.rewards or {}
    end)
