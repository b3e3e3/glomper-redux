local Physics = require 'game.physics'
local TestDraw = require 'game.testdraw'

local glompable = Concord.component("glompable", function(c)
    c.other = nil
end)
TestDraw.giveInfoText(glompable, function(_)
    return "glompable"
end)

local glomper = Concord.component("glomper", function(c, hitbox)
    c.other = nil

    -- TODO: standardize this somehow
    c.hitbox = hitbox or Physics.newHitbox(
        32, 8,
        0, 32
    )
end)
TestDraw.giveInfoText(glomper, function(e)
    return "glomper"
end)