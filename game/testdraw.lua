-- TODO: refactor, this feels like it's too tucked away
local TestDraw = {}
function TestDraw.giveInfoText(c, func)
    c.getInfoText = func or function(_)end
end

return TestDraw