local questdata = Concord.component("questdata", function(c, questData)
    c.name = questData.name or "No data"
    c.desc = questData.desc or "No data... quest is nil"
    c.signals = questData.signals or {}

    for k,v in pairs(questData) do
        if c[k] == nil then
            c[k] = v
        end
    end

    -- c.rewards = questData.rewards or {}
end)
