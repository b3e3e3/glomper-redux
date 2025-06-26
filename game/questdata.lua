function MakeQuestRewardAp(apBonus)
    return function(e)
        print(string.format("%s AP reward!", apBonus))
        e.status.ap = e.status.ap + apBonus
    end
end

local QuestData = {}

function QuestData:make(name, desc, rewards)
    local q = {
        name = name or QuestData.name,
        desc = desc or QuestData.desc,
        rewards = rewards or QuestData.rewards,
    }
    -- table.insert(Game.Quests, q)
    return q
end

-- function Quest:doRewards(e)
    -- if type(self.rewards) == 'function' then
    --     self.rewards(e)
    --     return
    -- end

    -- for i = 1, #self.rewards do
    --     self.rewards[i](e)
    -- end
-- end

return QuestData
