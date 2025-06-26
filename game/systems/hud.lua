local currentQuest = nil
local rot = 0

-- TODO: decouple dialog system
local HUDSystem = Concord.system({
    pool = {
        'status',
    },
    quests = {
        'questdata', 'toast',
    },
    activeQuests = {
        'questdata', 'active',
    }
})

function HUDSystem:onEntityRemoved(e)
    for _, q in ipairs(self.quests) do
        if e == q then
            currentQuest = nil
        end
    end
end

function HUDSystem:questToastClosed()
    if currentQuest and currentQuest:inWorld(ECS.world) then
        ECS.world:removeEntity(currentQuest)
        currentQuest = nil
    end
end

function HUDSystem:DisplayNextQuestText()
    if currentQuest == nil then return end
    if currentQuest.toast.behavior.state ~= 'default' then return end
    local time = currentQuest.toast.duration

    currentQuest.toast.behavior:setState('growing')

    local thisQuest = currentQuest

    -- TODO: states
    Timer.after(time, function()
        if not currentQuest then return end
        if thisQuest ~= currentQuest then return end -- just in case we open another quest toast and then the timer kicks in
        currentQuest.toast.behavior:setState('shrinking')
    end)
end

--== DRAW FUNCTIONS

function HUDSystem:questTextDraw()
    if #self.quests == 0 then return end
    if currentQuest == nil then return end

    -- get current quest data and toast
    local toast = currentQuest.toast
    local questData = currentQuest.questdata
    if questData.name and questData.name ~= "" then
        -- sizing variables
        local spacing = 8
        local margin = 64
        local spaceMod = toast.behavior.frame.spaceMod or 0
        local blockW, blockH = 32, 48

        local _getLineWidth = function(str)
            return (spacing + blockW) * #str
        end

        local lineHeight = blockH + spacing

        local lines = { '' }

        for word in questData.name:gmatch("%S+") do -- TRIM WHITESPACE
            local _getNewLine = function()
                return lines[#lines] .. ' ' .. word
            end

            -- get the width of the line - the margin
            local maxWidth = Game.getWidth() - margin
            if _getLineWidth(_getNewLine()) >= maxWidth then
                table.insert(lines, '')
            end

            lines[#lines] = _getNewLine()
        end

        for j = 1, #lines do
            local line = lines[j]
            local yoffset = lineHeight * (j - 1)
            for i = 1, #line do
                local lineWidth = _getLineWidth(line)
                local c = line:sub(i, i) -- get char at position i
                if c == ' ' then goto continue end

                local font = Game.Fonts.header
                local fh = font:getBaseline() / 4

                local x = Game.getWidth() / 2
                local dx = -blockW / 2
                dx = dx - (lineWidth / 2) + (blockW / 2) + ((spacing + blockW) * (i - 1))
                x = x + dx * spaceMod
                local y = 100 + yoffset

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

    for i, q in ipairs(self.activeQuests) do
        love.graphics.print("Active quests", 8, 100)
        love.graphics.print(q.questdata.name, 8, 100+(16*i))
    end
end

function HUDSystem:update(dt)
    rot = rot + dt
    if #self.quests > 0 then
        if currentQuest then
            currentQuest.toast.behavior:update(dt)
        else
            currentQuest = self.quests[1]
            self:DisplayNextQuestText()
        end
    end
end

function HUDSystem:questStarted(questData, time)
    local e = Concord.entity(ECS.world)
        :assemble(
            ECS.a.questtoast,
            questData,
            time)
end

return HUDSystem
