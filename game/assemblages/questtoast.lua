
local makeQuestToastAnimStates = function()
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

return function(e, questData, duration)
    e
    :give("questdata", questData)
    :give("toast", duration, makeQuestToastAnimStates())
end