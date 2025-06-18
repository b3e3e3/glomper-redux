local InteractSystem = Concord.system({
    inWorld = { "interactable", "position" }
})

local DIST = 48

function InteractSystem:start(with, other)
    if with.interactable.interacting then return end
    ECS.world:emit("interactStart", with, other)
end

function InteractSystem:finish(with, other)
    if not with.interactable.interacting then return end
    ECS.world:emit("interactFinish", with) --, other)
end

function InteractSystem:interactStart(with, other)
    with.interactable.interacting = true
end

function InteractSystem:interactFinish(with, other)
    -- ECS.world:removeEntity(with)
    with.interactable.interacting = false
end

local function canInteract(with, other)
    -- TODO: decouple from specific player maybe
    other = other or Game.getPlayer()

    local inRange = math.abs(with.position.x - other.position.x) < DIST
    local grounded = Game.Physics.isGrounded(other)

    return not with.interactable.interacting and inRange and grounded
end

function InteractSystem:update(dt)
    -- TODO: decouple from specific player maybe
    local other = Game.getPlayer()
    for _, e in ipairs(self.inWorld) do
        if canInteract(e, other) then
            if Game.Input:pressed("interact") then
                self:start(e, other)
                e.interactable.onInteract(e, function()
                    self:finish(e, other)
                end)
            end
        end
    end
end

return InteractSystem
