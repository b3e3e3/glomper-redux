local Physics = {}

Physics.filters = {
    solid = function(item, other)
        if not other:has("physics") then return nil end
        if other.physics.isSolid ~= true then
            return 'cross'
        end
        return 'slide'
    end,
}
Physics.filters.default = Physics.filters.solid

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
    return pos.x + vel.x * dt, pos.y + vel.y * dt
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

return Physics