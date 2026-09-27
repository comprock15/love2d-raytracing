local Object = require "src.classic"

local Color = Object:extend()

-- Публичный конструктор: принимает 0..255
function Color:new(r, g, b)
    self.r = math.max(0, math.min(r, 255)) / 255
    self.g = math.max(0, math.min(g, 255)) / 255
    self.b = math.max(0, math.min(b, 255)) / 255
end

-- Внутренний: создаёт Color из уже нормализованных 0..1, без деления
local function fromNormalized(r, g, b)
    local c = setmetatable({}, Color)
    c.r = math.max(0, math.min(r, 1))
    c.g = math.max(0, math.min(g, 1))
    c.b = math.max(0, math.min(b, 1))
    return c
end

function Color.scale(c, s)
    return fromNormalized(c.r * s, c.g * s, c.b * s)
end

function Color.add(c1, c2)
    return fromNormalized(c1.r + c2.r, c1.g + c2.g, c1.b + c2.b)
end

return Color