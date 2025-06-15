local baton = require 'libraries.baton'

local input = baton.new {
    controls = {
        confirm = {'key:return'},

        left = {'key:left', 'key:a'},
        right = {'key:right', 'key:d'},
        up = {'key:up', 'key:w'},
        down = {'key:down', 'key:s'},

        jump = {'key:space', 'key:up'},
        sprint = {'key:lshift'},
    },
    pairs = {
        move = {'left', 'right', 'up', 'down'}
    }
}

return input