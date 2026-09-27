local Object = require "src.classic"

local Scene = Object:extend()

function Scene:new(objects, lights, bgcolor)
    self.objects = objects
    self.lights = lights
    self.bgcolor = bgcolor
end

function Scene:add(object)
    table.insert(self.objects, object)
end

-- function Scene:remove(object)
--     table.remove(self.objects, self.lights.)
-- end

function Scene:collide(ray, currentObj)
    local closest = {
        collide = false,
        dist = math.huge,
        point = nil,
        normal = nil,
        obj = nil,
    }

    for _, obj in ipairs(self.objects) do
        if obj ~= currentObj then
            local result = obj:collision(ray)
            if result.collide and result.dist < closest.dist then
                closest = result
            end
        end
    end

    return closest
end

return Scene