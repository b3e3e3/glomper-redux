local QuestSystem = Concord.system({
    pool = {
        'questdata',
    }
})

function QuestSystem:questStarted(questData)
    for _, q in self.pool do
        if questData.name ~= q.questData.name then goto continue end -- TODO: better comparison
        print("Quest has been started!", q.questData.name)
        ::continue::
    end
end

function QuestSystem:questFinished(questData)
    for _, q in self.pool do
        if questData.name ~= q.questData.name then goto continue end -- TODO: better comparison
        self:doRewards(q)
        print("Quest has been finished :')", q.questData.name)
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
