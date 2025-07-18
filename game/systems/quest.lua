local Bind = require 'libraries.knife.bind'
local QuestSystem = Concord.system({
    active = {
        'questdata', 'active'
    }
})

-- function QuestSystem:update(dt)
--     for _, q in ipairs(self.active) do

--     end
-- end

-- function QuestSystem:onEntityRemoved(e)
--     for _, q in ipairs(self.active) do
--         print('Quest removed?', q==e)
--         if q ~= e then goto continue end
--         if q.questdata.signals and #q.questdata.signals > 0 then
--             for _, s in ipairs(q.questdata.signals) do
--                 Signal.remove(s.name, Bind(s.action, q)) -- TODO: does this Bind count as the same func?
--             end
--         end
--         ::continue::
--     end
-- end

function QuestSystem:isActive(questData)
    for _, e in ipairs(self.active) do
        if questData._id == e.questdata._id then
            return true
        end
    end

    return false
end

function QuestSystem:questStarted(questData)
    local q = Concord.entity(ECS.world)
        :assemble(ECS.a.activequest, questData)

    q.questdata:bindSignals(q)
end

function QuestSystem:questFinished(q)
    local quest = q.questdata

    quest:setFinished()
    print(quest.name .. ' finished')

    if q:inWorld(ECS.world) then
        print("REMOVING ENTITY")
        ECS.world:removeEntity(q)
    end

    -- TODO: do rewards
end

function QuestSystem:doRewards(e)
    -- TODO: get player
    -- if type(e.quest.rewards) == 'function' then
    --     self.rewards(player)
    -- -- else
    -- --     for i = 1, #e.quest.rewards do
    -- --         -- self.rewards[i](player)
    -- --     end
    -- end
end

return QuestSystem
