local Object = require "src.classic"

local Ray = Object:extend()

function Ray:new(origin, direction)
    self.origin = origin
    self.direction = direction
end

return Ray