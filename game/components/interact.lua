local interactable = Concord.component("interactable", function(c, onInteract)
    c.onInteract = onInteract or function(finish)
        if not finish then return end
        finish()
    end
end)