local Vector = require "src.vector"
local Ray = require "src.ray"
local Color = require "src.color"
local Scene = require "src.scene"

local Renderer = {}

local MAX_DEPTH = 1

function Renderer.reflect(point, ray, normal)
    local newDirection = Vector.subtract(
        ray.direction,
        Vector.scale(normal, 2 * Vector.dot(ray.direction, normal))
    )
    return Ray(point, newDirection)
end

function Renderer.refract(point, ray, normal)
    local cosi = -math.max(-1, math.min(1, Vector.dot(ray.direction, normal)))
    local etai = 1
    local etaobj = 0.9
    local norm = normal.copy()
    if cosi < 0 then
        cosi = -cosi
        etai, etaobj = etaobj, etai
        norm = Vector.scale(norm, -1)
    end
    local eta = etai / etaobj
    local k = 1 - eta*eta*(1-cosi*cosi)
    local newDirection = Vector.add(Vector.scale(ray.direction, eta), Vector.scale(norm, eta * cosi - math.sqrt(k)))

    return Ray(point, newDirection)
end

function Renderer.trace(ray, depth, scene, currentObj)
    if depth <= 0 then
        return scene.bgcolor
    end

    local result = scene:collide(ray, currentObj)
    local point = result.point
    local normal = result.normal

    -- Луч не пересек никакой из объектов
    if not result.collide then
        return scene.bgcolor
    end

    -- Считаем освещенность в точке
    local lightIntensity = 0
    local shadowCoeff = 0.3 / #scene.lights
    for _, light in ipairs(scene.lights) do
        local lightDirection = Vector.normalize(Vector.subtract(light.position, point))
        local lightDistance = Vector.subtract(light.position, point):length()

        -- Выпускаем теневой луч
        local shadowRay = Ray(point, lightDirection)
        if scene:collide(shadowRay, result.obj).dist < lightDistance then
            lightIntensity = lightIntensity + shadowCoeff * light.intensity * math.max(0, Vector.dot(lightDirection, normal))
        else
            lightIntensity = lightIntensity + light.intensity * math.max(0, Vector.dot(lightDirection, normal))
        end
    end
    lightIntensity = lightIntensity / #scene.lights

    local reflectivity = result.obj.properties.reflectivity
    local reflection
    if reflectivity then
       reflection = Renderer.trace(Renderer.reflect(result.point, ray, result.normal), depth - 1, scene, result.obj)
    end

    local transparency = result.obj.properties.transparency
    local refraction
    if transparency then
        refraction = Renderer.trace(Renderer.refract(result.point, ray, result.normal), depth - 1, result.obj)
    end

    local color = result.obj.properties.color
    color = Color.scale(color, lightIntensity)
    if reflectivity then
        color = Color.add(color, Color.scale(reflection, depth / MAX_DEPTH / 2))
    end
    if transparency then
        color = Color.add(color, Color.scale(refraction, depth / MAX_DEPTH / 2))
    end
    return color
end

function Renderer.render(scene, camera, width, height)
    local imageData = love.image.newImageData(width, height)

    imageData:mapPixel(function(i, j)
        local x = (2 * (i + 0.5) / width - 1) * math.tan(camera.fieldOfView / 2) * (width / height)
        local y = -(2 * (j + 0.5) / height - 1) * math.tan(camera.fieldOfView / 2)
        local ray = Ray(camera.position, Vector(x, y, camera.fieldOfView):normalize())

        local color = Renderer.trace(ray, MAX_DEPTH, scene, nil)
        return color.r, color.g, color.b, 1
    end)

    local image = love.graphics.newImage(imageData)
    image:setFilter("nearest", "nearest")
    return image
end

return Renderer