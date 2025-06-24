-- TODO: decouple dialog system
local HUDSystem = Concord.system({
    pool = {
        'status'
    },
})

local questText
local questTextQueue = {}

local rot = 0

local function _displayNextQuestText(time)
    time = time or 3
    if #questTextQueue == 0 then return end

    Game.setFreeze(true)

    questText = questTextQueue[1]
    table.remove(questTextQueue, 1)

    -- TODO: states
    Timer.after(time, function()
        questText = nil
        Game.setFreeze(false) -- TODO: override interact freeze
        Timer.after(1, function()
            _displayNextQuestText(time)
        end)
    end)
end

local function _questTextDraw()
    if questText and questText ~= "" then
        local spacing = 8
        local blockW, blockH = 32, 48
        local width = (spacing + blockW) * #questText -- TODO: line width
        for i = 1, #questText do
            local c = questText:sub(i, i)
            if c == ' ' then goto continue end

            local font = Game.Fonts.header
            local fh = font:getBaseline() / 4

            local x = Game.getWidth() / 2 - width / 2 + blockW / 2
            x = x + ((spacing + blockW) * (i - 1))
            local y = 100 + fh

            love.graphics.push()
            love.graphics.translate(x, y)

            love.graphics.rotate(math.cos(rot * 6) * 0.15)
            
            love.graphics.setColor(1, 0.6, 0)
            love.graphics.rectangle("fill",
                -blockW/2, -blockH/2, blockW, blockH
            )


            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(font)
            love.graphics.printf(c,
                -blockW/2, --x + ((spacing + blockW) * (i - 1)),
                -blockH / 2 + fh, --y + fh,
                blockW, "center"
            )

            love.graphics.rotate(0)
            love.graphics.pop()

            ::continue::
        end

        love.graphics.reset()
        -- love.graphics.print(questText, Game.getWidth() / 2, Game.getHeight() / 2)
    end
end

function HUDSystem:statusDraw()
    if #self.pool == 0 then return end
    local e = self.pool[1] -- TODO: decide on loop or singleton??
    -- for _, e in ipairs(self.pool) do
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('HP: ' .. e.status.hp, 16, 16)
    love.graphics.print('AP: ' .. e.status.ap, 16, 32)
    -- end
end

function HUDSystem:draw()
    self:statusDraw()
    _questTextDraw()
end

function HUDSystem:update(dt)
    -- if questText and questText ~= '' and Game._frozen ~= true then Game.setFreeze(true) end -- TODO: HACK!!!!
    rot = rot + dt
end

function HUDSystem:questAdded(quest, time)
    table.insert(questTextQueue, quest.name)

    if questText then return end
    _displayNextQuestText(time)
end

return HUDSystem
