local Behavior = require 'libraries.knife.behavior'
local Chain = require 'libraries.knife.chain'
local slicy = require 'libraries.slicy'

local transitionTime = 0.85

local states = {
    default = {
        { duration = 0, after = 'idle' },
    },
    idle = {
        { duration = 1024, }
    },
    growing = {
        {
            duration = transitionTime * 1.1,
            action = function(_, e)
                ECS.world:emit('paneOpened', e)
                Chain(
                    function(go)
                        Timer.tween(transitionTime / 2, e.size, {
                            w = e.pane.targetSize.w
                        }, 'linear', go)
                    end,
                    function(go)
                        Timer.tween(transitionTime / 2, e.size, {
                            h = e.pane.targetSize.h
                        }, 'linear', go)
                    end
                )()
            end,
            after = 'default'
        },
    },
    shrinking = {
        {
            duration = transitionTime * 1.1,
            action = function(_, e)
                Chain(
                    function(go)
                        Timer.tween(transitionTime / 2, e.size, {
                            h = 0
                        }, 'linear', go)
                    end,
                    function(go)
                        Timer.tween(transitionTime / 2, e.size, {
                            w = 0
                        }, 'linear', go)
                    end,
                    function(go)
                        ECS.world:emit('paneClosed', e)
                        go()
                    end
                )()
            end,
            after = 'default'
        },
    },
}

local pane = Concord.component("pane", function(c, margin)
    c.margin = margin

    c.targetSize = { w = 128, h = 128 }

    c.ui = slicy.load('assets/box.9.png')
    c.behavior = Behavior(states)
end)
