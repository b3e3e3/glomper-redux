local InteractSystem = Concord.system({
    inWorld = { "interactable", "position" }
})

local DIST = 8

function InteractSystem:finish(with, other)
    ECS.world:emit("interactFinish", with, other)
end

function InteractSystem:interactFinish(with, other)
    ECS.world:removeEntity(with)
end

local function canInteract(with, other)
    -- TODO: decouple from specific player maybe
    other = other or Game.getPlayer()
    local inRange = math.abs(with.position.x) - math.abs(other.position.x) < DIST
    local grounded = Game.Physics.isGrounded(other)

    return inRange and grounded
end

function InteractSystem:update(dt)
    -- TODO: decouple from specific player maybe
    local other = Game.getPlayer()
    for _, e in ipairs(self.inWorld) do
        if canInteract(e, other) then
            if Game.Input:pressed("interact") then
                ECS.world:emit("interactStart", e, other)
                e.interactable.onInteract(function()
                    self:finish(e, other)
                end)
            end
        end
    end
end

return InteractSystem
