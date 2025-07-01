-- TODO: standardize draw components
local component = Concord.component("testdraw", function(c, infoOnHover)
    c.color = {
        r = math.random(),
        g = math.random(),
        b = math.random(),
    }
    c.offset = { x = 0, y = 0 }
    c.visible = true
    c.angle = 0
    c.infoOnHover = true and infoOnHover == nil or infoOnHover -- default to true if nil
end)

Concord.component("player", function(_) end)
return component
