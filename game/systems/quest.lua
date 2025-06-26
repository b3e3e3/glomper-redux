local QuestSystem = Concord.system({
    pool = {
        'questtoast',
    }
})

function QuestSystem:questStarted(quest)
    for _, q in self.pool do
        if quest ~= q then goto continue end
        print("Quest has been started!", q.quest.text)
        ::continue::
    end
end

function QuestSystem:questFinished(quest)
    for _, q in self.pool do
        if quest ~= q then goto continue end
        self:doRewards(q)
        print("Quest has been finished :')", q.quest.text)
        ::continue::
    end
end

function QuestSystem:doRewards(e)
    print("TODO: do rewards")
    -- TODO: get player
    -- if type(e.quest.rewards) == 'function' then
    --     self.rewards(player)
    -- -- else
    -- --     for i = 1, #e.quest.rewards do
    -- --         -- self.rewards[i](player)
    -- --     end
    -- end
end
