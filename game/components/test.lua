local component = Concord.component("testdraw", function(c, infoOnHover)
    c.infoOnHover = true and infoOnHover == nil or infoOnHover -- default to true if nil
end)

return component