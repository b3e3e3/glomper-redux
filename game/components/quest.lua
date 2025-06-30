local questdata = Concord.component("questdata", function(c, questData)
    setmetatable(c, { __index = questData })
end)

local questclear = Concord.component("questclear")
