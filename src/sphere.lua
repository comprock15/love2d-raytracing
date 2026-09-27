local Shape = require "src.shape"
local Vector = require "src.vector"

local Sphere = Shape:extend()

function Sphere:new(position, radius, properties)
    Sphere.super.new(self, properties)
    self.position = position
    self.radius = radius
end

function Sphere:collision(ray)
    local distRay = Vector.subtract(self.position, ray.origin)
    local distToCenter = distRay:length()
    local rayDistToCenter = Vector.dot(distRay, ray.direction)
    local rayDistFromCenterSquared = distToCenter ^ 2 - rayDistToCenter ^ 2

    local radiusSquared = self.radius ^ 2

    local distToSurface = rayDistToCenter - math.sqrt(math.abs(radiusSquared - rayDistFromCenterSquared))

    local collide = true

    if rayDistToCenter < 0 or rayDistFromCenterSquared > radiusSquared then
        collide = false
    end

    if not collide then
        distToSurface = math.huge
    end

    local point = Vector.add(Vector.scale(ray.direction, distToSurface), ray.origin)

    return {
        collide = collide,
        dist = distToSurface,
        point = point,
        normal = Vector.subtract(point, self.position):normalize(),
        obj = self,
    }

end

return Sphere