local Timer = require 'libraries.hump.timer'
local Behavior = require 'libraries.knife.behavior'
local Chain = require 'libraries.knife.chain'
local slicy = require 'libraries.slicy'

local states = {
    default = {
        { duration = 0, after = 'idle', action = function() print("pane time") end },
    },
    idle = {
        { duration = 1024, }
    },
    growing = {
        {
            duration = 0.76, -- WHY IS IT 1 AND NOT 2
            action = function(_, e)
                -- print(string.format("Tweening to %s, %s", paneTargetW, paneTargetH))
                Chain(
                    function(go)
                        Timer.tween(0.66, e.size, {
                            w = e.pane.targetSize.w
                        }, 'linear', go)
                    end,
                    function(go)
                        Timer.tween(0.66, e.size, {
                            h = e.pane.targetSize.h
                        }, 'linear', go)
                    end,
                    function(go)
                        print('done')
                        go()
                    end
                )()
            end
        },
        {
            duration = 0,
            action = function() print("GRONE") end,
            after = 'default'
        }
    },
}

local pane = Concord.component("pane", function(c, margin)
    c.margin = margin

    c.targetSize = { w = 128, h = 128 }

    c.ui = slicy.load('assets/box.9.png')
    c.behavior = Behavior(states)
end)
