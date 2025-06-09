local ProjectileSystem = Concord.system({
    pool = { "projectile", "position" },
})

function ProjectileSystem:update(dt)
    for _, e in ipairs(self.pool) do
        e.position.x = e.position.x + e.projectile.speed * dt
    end
end

return ProjectileSystem