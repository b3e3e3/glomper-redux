local Physics = {}

Physics.filters = {
    solid = function(item, other)
        if not item:has("physics") or not other:has("physics") then return nil end
        if not item.physics.isSolid or not other.physics.isSolid then
            return 'cross'
        end
        return 'slide'
    end,
}
Physics.filters.default = Physics.filters.solid

function Physics.isOnScreen(pos, size, margin)
    margin = margin or 5
    if pos.x + size.w < 0 + margin then return false
    elseif pos.x > love.graphics.getWidth() - margin then return false
    elseif pos.y + size.h < 0 + margin  then return false
    elseif pos.y > love.graphics.getHeight() - margin then return false end
    return true
end

function Physics.newHitbox(w, h, xoffset, yoffset)
    local hitbox = {
        width = w,
        height = h,
        xoffset = xoffset,
        yoffset = yoffset,

        
    }
    function hitbox:getOffsetPos(baseX, baseY)
        return baseX + self.xoffset, baseY + self.yoffset
    end

    return hitbox
end

function Physics.calculateGoalPos(pos, vel, dt)
    dt = dt or love.timer.getDelta()
    return pos.x + (vel.x * dt), pos.y + (vel.y * dt)
end

function Physics.checkCollision(e, goalX, goalY, filter)
    return Game.bumpWorld:check(e, goalX, goalY, filter or Physics.filters.default)
end

function Physics.getCols(e, xOffset, yOffset, filter)
    local _, _, cols = Physics.checkCollision(e, e.position.x + (xOffset or 0), e.position.y + (yOffset or 0), filter or Physics.filters.default)
    return cols
end

function Physics.isGrounded(e) -- TODO: better refactor for this
    return #Game.Physics.getCols(e, 0, 1) > 0
end

function Physics.isOnWall(e) -- TODO: better refactor for this
    local filter = function(item, other)
        if other:has("wall") then return 'touch' else return nil end
    end
    local rcols = #Game.Physics.getCols(e, 1, 0, filter)
    local lcols = #Game.Physics.getCols(e, -1, 0, filter)

    local side = -1
    if rcols > lcols then side = 1 end

    return rcols + lcols > 0, side
end

function Physics.canJump(e)
    return Physics.isGrounded(e) or Physics.isOnWall(e)
end

return Physics