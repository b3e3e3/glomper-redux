local InteractSystem = Concord.system({
    inWorld = { "interactable", "position" }
})

local DIST = 8

function InteractSystem:finish(e)
    ECS.world:removeEntity(e)
end

function InteractSystem:update(dt)
    for _,e in ipairs(self.inWorld) do
        if math.abs(e.position.x) - math.abs(Game.getPlayer().position.x) < DIST then
            if Game.Input:pressed("interact") then
                e.interactable.onInteract(function()
                    self:finish(e)
                end)
            end
        end
    end
end

return InteractSystem