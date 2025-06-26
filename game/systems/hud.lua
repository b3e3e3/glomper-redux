local currentQuest = nil
local rot = 0

-- TODO: decouple dialog system
local HUDSystem = Concord.system({
    pool = {
        'status',
    },
    quests = {
        'questtoast',
    }
})

function HUDSystem:questToastClosed()
    if currentQuest and currentQuest:inWorld(ECS.world) then
        ECS.world:removeEntity(currentQuest)
        currentQuest = nil
    end
end

function HUDSystem:DisplayNextQuestText()
    if currentQuest == nil then return end
    if currentQuest.questtoast.behavior.state ~= 'default' then return end
    local time = currentQuest.questtoast.duration

    currentQuest.questtoast.behavior:setState('growing')

    -- TODO: states
    Timer.after(time, function()
        currentQuest.questtoast.behavior:setState('shrinking')
    end)
end

function HUDSystem:questTextDraw()
    if #self.quests == 0 then return end
    if currentQuest == nil then return end
    local quest = currentQuest.questtoast
    if quest.name and quest.name ~= "" then
        local spacing = 8
        local spaceMod = quest.behavior.frame.spaceMod or 0
        local blockW, blockH = 32, 48
        local width = (spacing + blockW) * #quest.name -- TODO: line width
        for i = 1, #quest.name do
            local c = quest.name:sub(i, i)
            if c == ' ' then goto continue end

            local font = Game.Fonts.header
            local fh = font:getBaseline() / 4

            local x = Game.getWidth() / 2
            local dx = 0
            dx = dx - (width / 2) + (blockW / 2) + ((spacing + blockW) * (i - 1))
            x = x + dx * spaceMod
            local y = 100

            love.graphics.push()
            love.graphics.translate(x, y)

            love.graphics.rotate(math.cos(rot * 6) * 0.15)

            love.graphics.setColor(1, 0.6, 0)
            love.graphics.rectangle("fill",
                -blockW / 2, -blockH / 2, blockW, blockH
            )


            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(font)
            love.graphics.printf(c,
                -blockW / 2,      --x + ((spacing + blockW) * (i - 1)),
                -blockH / 2 + fh, --y + fh,
                blockW, "center"
            )

            love.graphics.rotate(0)
            love.graphics.pop()

            ::continue::
        end

        love.graphics.reset()
    end
end

function HUDSystem:statusDraw()
    if #self.pool == 0 then return end
    local e = self.pool[1]

    love.graphics.setColor(1, 1, 1)
    love.graphics.print('HP: ' .. e.status.hp, 16, 16)
    love.graphics.print('AP: ' .. e.status.ap, 16, 32)
end

function HUDSystem:draw()
    self:statusDraw()
    self:questTextDraw()
end

function HUDSystem:update(dt)
    rot = rot + dt
    if #self.quests > 0 then
        if currentQuest then
            currentQuest.questtoast.behavior:update(dt)
        else
            currentQuest = self.quests[1]
            self:DisplayNextQuestText()
        end
    end
end

function HUDSystem:questStarted(quest, time)
    -- TODO: move this out of HUD system? idk
    local e = Concord.entity(ECS.world)
        :give(
            "questtoast",
            quest,
            time)
end

return HUDSystem
