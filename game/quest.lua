function MakeQuestRewardAp(apBonus)
    return function(e)
        print(string.format("%s AP reward!", apBonus))
        e.status.ap = e.status.ap + apBonus
    end
end

local Quest = {
    name = "A default event",
    desc = "The data of this event has been neglected.",
    rewards = {
        MakeQuestRewardAp(-666),
    },
}
function Quest:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Quest:make(name, desc, rewards)
    local q = Quest:new({
        name = name or Quest.name,
        desc = desc or Quest.desc,
        rewards = rewards or Quest.rewards,
    })

    -- table.insert(Game.Quests, q)
    return q
end

function Quest:doRewards(e)
    if type(self.rewards) == 'function' then
        self.rewards(e)
        return
    end

    for i = 1, #self.rewards do
        self.rewards[i](e)
    end
end

return Quest
