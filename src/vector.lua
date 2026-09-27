local Object = require "src.classic"

local Vector = Object:extend()

function Vector:new(x, y, z)
    self.x = x
    self.y = y
    self.z = z
end

function Vector:length()
    return math.sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
end

function Vector:copy()
    return Vector(self.x, self.y, self.z)
end

function Vector.normalize(v)
    local scaleFactor = 1 / v:length()
    return Vector.scale(v, scaleFactor)
end

function Vector.scale(v, s)
    return Vector(v.x * s, v.y * s, v.z * s)
end

function Vector.add(v1, v2)
    return Vector(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
end

function Vector.subtract(v1, v2)
    return Vector(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
end

function Vector.dot(v1, v2)
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

function Vector.cross(v1, v2)
    return Vector(v1.y * v2.z - v1.z * v2.y, v1.z * v2.x - v1.x * v2.z, v1.x * v2.y - v1.y * v2.x)
end

return Vector