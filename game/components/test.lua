-- TODO: standardize draw components
local component = Concord.component("testdraw", function(c, infoOnHover)
    c.visible = true
    c.angle = 0
    c.infoOnHover = true and infoOnHover == nil or infoOnHover -- default to true if nil
end)

Concord.component("player", function (_) end)
return component
