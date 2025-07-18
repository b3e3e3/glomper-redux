local interactable = Concord.component("interactable", function(c, onInteract)
    c.interacting = false
    c.onInteract = onInteract or function(_, finish)
        if not finish then return end
        finish()
    end
end)
