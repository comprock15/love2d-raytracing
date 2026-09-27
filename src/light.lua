local Object = require "src.classic"

local Light = Object:extend()

function Light:new(position, intensity)
    self.position = position
    self.intensity = intensity
end

return Light