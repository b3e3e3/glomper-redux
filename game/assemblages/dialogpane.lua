return function(e, x, y, w, h, margin)
    margin = margin or 16
    e
        :give('pane', margin)
        :give('position', x, y)
        :give('size', w - margin - margin, h - margin)

    e.pane.behavior.subject = e
end
