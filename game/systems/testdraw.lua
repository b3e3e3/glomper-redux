require 'game.systems.physics'

local TestDrawSystem = Concord.system({
    all = { "testdraw" },
    pool = { "testdraw", "position", "size" },
    physics = { "testdraw", "physics", "position" },
    glompdata = { "glompdata", "position", "size" },
})

-- TODO: standardize draw components
function TestDrawSystem:show(e)
    if e ~= nil then
        if not e:has("testdraw") then return end
        if e.testdraw ~= self then return end
    end

    self.visible = true
end

function TestDrawSystem:hide(e)
    if e ~= nil then
        if not e:has("testdraw") then return end
        if e.testdraw ~= self then return end
    end

    self.visible = false
end

function TestDrawSystem:glomp(by, other)
    -- print("Glomped")
    -- if not by:has("testdraw") then return end
    -- by.testdraw.visible = false
end

function TestDrawSystem.drawInfoText(e, lineHeight)
    lineHeight = lineHeight or 16
    local count = 1
    for _, c in pairs(e:getComponents()) do
        if not c.getInfoText then goto continue end

        love.graphics.push()

        love.graphics.setColor(1, 0, 0)

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

function TestDrawSystem:drawGraphic()
    for _, e in ipairs(self.pool) do
        if not e.testdraw.visible then goto continue end
        love.graphics.push()
        if Game.entityIsPlayer(e) then
            love.graphics.setColor(1, 0, 1)
        else
            local r,g,b = e.testdraw.color.r, e.testdraw.color.b, e.testdraw.color.b
            love.graphics.setColor(r, g, b)
        end

        love.graphics.translate(e.position.x + e.size.w / 2, e.position.y + e.size.h / 2)
        love.graphics.rotate(e.testdraw.angle)
        love.graphics.translate(-e.size.w / 2, -e.size.h / 2)

        local offset = e.offset or { x = 0, y = 0 }
        -- if offset.y ~= 0 then print(string.format("Drawing with offset %s", offset.y)) end

        love.graphics.rectangle("fill",
            0 + offset.x, 0 + offset.y,
            -- e.position.x, e.position.y,
            e.size.w, e.size.h
        )
        love.graphics.pop()
        love.graphics.reset()--setColor(1, 1, 1)
        ::continue::
    end
end

function TestDrawSystem:draw()
    self:drawGraphic()

    for _, e in ipairs(self.glompdata) do
        -- love.graphics.setColor(1,1,0)
        love.graphics.rectangle(
            "fill",
            e.position.x,
            e.position.y, -- - 32,
            32, 32
        )
    end

    for _, e in ipairs(self.all) do
        local items = Game.bumpWorld:queryPoint(love.mouse.getX(), love.mouse.getY())
        local shouldDraw = not e.testdraw.infoOnHover

        if e.testdraw.infoOnHover and #items > 0 then
            for _, i in ipairs(items) do
                if e == i then
                    shouldDraw = true
                end
            end
        end

        if shouldDraw then
            TestDrawSystem.drawInfoText(e)
        end
    end
end

return TestDrawSystem
