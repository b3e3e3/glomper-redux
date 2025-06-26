local Behavior = require 'libraries.knife.behavior'

local toast = Concord.component("toast", function(c, duration, animStates) --name, desc, rewards)
    c.behavior = Behavior(animStates)
    c.duration = duration or 3
end)