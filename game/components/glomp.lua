local TestDraw = require 'game.testdraw'
local glompable = Concord.component("glompable", function(c) end)
TestDraw.giveInfoText(glompable, function(_)
    return "glompable"
end)

-- TODO: decouple this from the player controller? MAYBE? that might not be the best solution
-- local glomper = Concord.component("glomper", function(c) end)
-- TestDraw.giveInfoText(glomper, function(e)
--     return "glomper"
-- end)