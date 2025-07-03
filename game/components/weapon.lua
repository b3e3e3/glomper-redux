local Vector = require 'libraries.hump.vector-light'

local weapon = Concord.component("weapon", function(c, dmg, range, headSprite, chainSprite)
    c.pos = Vector.new()
    
    c.stats = Stats.new()
    c.stats.dmg = dmg or 0
    c.stats.range = range or 0

    c.headSprite = headSprite or nil
    c.chainSprite = chainSprite or nil
end)