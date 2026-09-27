local Object = require "src.classic"

local Camera = Object:extend()

function Camera:new(position, fieldOfView)
    self.position = position
    self.fieldOfView = fieldOfView
end

return Camera