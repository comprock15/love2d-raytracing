local Object = require "src.classic"

local Shape = Object:extend()

function Shape:new(properties)
    self.properties = properties
end

return Shape