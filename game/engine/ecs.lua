local ECS = {
    c = Concord.components,
    a = {},
    s = {},
    world = Concord.world(),
}

function ECS.world:onEntityAdded(e)
    ECS.world:emit("onEntityAdded", e)
end

function ECS.world:onEntityRemoved(e)
    ECS.world:emit("onEntityRemoved", e)
end

return ECS
