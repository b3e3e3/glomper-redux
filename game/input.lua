local baton = require 'libraries.baton'

local input = baton.new {
    controls = {
        left = {'key:left', 'key:a'},
        right = {'key:right', 'key:d'},
        up = {'key:up', 'key:w'},
        down = {'key:down', 'key:s'},

        jump = {'key:space', 'key:w', 'key:up'},
        sprint = {'key:lshift'},
    },
    pairs = {
        move = {'left', 'right', 'up', 'down'}
    }
}

return input