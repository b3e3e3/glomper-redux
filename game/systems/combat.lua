local CombatSystem = Concord.system({
    pool = { 'weapon', 'position' }
})

local _canAttack = function(e)
    return not e:has('frozen') and Game.Physics.isGrounded(e)
end

function CombatSystem:update(dt)
    -- TODO: decouple from input so other entities can attack too
    for _, e in ipairs(self.pool) do
        if Game.Input:pressed('attack') then
            if _canAttack(e) then
                print("attack")
            end
        end
    end
end

return CombatSystem