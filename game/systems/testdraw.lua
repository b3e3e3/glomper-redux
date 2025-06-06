require 'game.systems.physics'

local TestDrawSystem = Concord.system({
    all = { "testdraw" },
    pool = { "testdraw", "position", "size" },
    physics = { "testdraw", "physics", "position" }
})

function TestDrawSystem.drawInfoText(e, lineHeight)
    lineHeight = lineHeight or 16
    local count = 1
    for _, c in pairs(e:getComponents()) do
        if not c.getInfoText then goto continue end
        
        love.graphics.push()

        -- print("Drawing count " .. count .. " for component " .. c:getName())

        local res = c.getInfoText(e)

        local doDraw = function(str)
            if not str or str == "" then return end
            count = count + 1
            -- print("Drawing " .. str .. ' at ' .. e.position.x .. ', ' .. e.position.y - (lineHeight*count))
            love.graphics.print(
                str,
                e.position.x or 0, (e.position.y or 0) - (lineHeight * count)
            )
        end
        if type(res) == "string" then
            doDraw(res)
        elseif res[1] ~= nil then
            for _, s in pairs(res) do
                doDraw(s)
            end
        else
            goto continue
        end

        love.graphics.pop()

        ::continue::
    end
end

function TestDrawSystem:drawPhysics()
    for _, e in ipairs(self.physics) do
        if Game.bumpWorld:hasItem(e) then
            love.graphics.push()

            -- local x, y, w, h = Game.bumpWorld:getRect(e)
            -- -- if e['has'] and e:has("velocity") then
            -- if e:has("velocity") then
            --     local goalX, goalY = Game.Physics.calculateGoalPos(e.position, e.velocity)
            --     local _, _, cols = Game.Physics.checkCollision(e, goalX, goalY)
            --     print(#cols)
            --     if #cols > 1 then
            --         love.graphics.setColor(0, 1, 0)
            --     else
            --         love.graphics.setColor(1, 0, 0)
            --     end
            --     love.graphics.print(string.format("cols: %s", #cols), x, y - 112)
            -- end

            -- love.graphics.print(string.format("vel: %s, %s", e.velocity.x, e.velocity.y), x, y - 32)
            -- love.graphics.print(string.format("pos: %s, %s", e.position.x, e.position.y), x, y - 48)
            -- love.graphics.print(string.format("rect: %s, %s", x, y), x, y - 64)
            -- love.graphics.print(string.format("isSolid: %s", e.physics.isSolid), x, y - 80)
            -- love.graphics.print(string.format("isFrozen: %s", e.physics.isFrozen), x, y - 96)

            love.graphics.pop()
        end
    end
end

function TestDrawSystem:drawGraphic()
    for _, e in ipairs(self.pool) do
        love.graphics.push()
        love.graphics.setColor(1, 1, 1)
        -- love.graphics.circle("fill", e.position.x, e.position.y, 16)
        love.graphics.rectangle("fill",
            e.position.x, e.position.y,
            e.size.w, e.size.h
        )
        love.graphics.pop()
    end
end

function TestDrawSystem:draw()
    self:drawGraphic()
    self:drawPhysics()

    for _, e in ipairs(self.all) do
        TestDrawSystem.drawInfoText(e)
    end
end

return TestDrawSystem
