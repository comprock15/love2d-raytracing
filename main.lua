local Camera = require "src.camera"
local Vector = require "src.vector"
local Sphere = require "src.sphere"
local Color = require "src.color"
local Light = require "src.light"
local Scene = require "src.scene"
local Renderer = require "src.renderer"

local speed = 5

local width = 640
local height = 640

local renderWidth = 100
local renderHeight = 100

local image
local camera
local scene

function love.load()
    love.window.setMode(width, height)

    scene = setScene()
    image = Renderer.render(scene, camera, renderWidth, renderHeight)
end

function love.update(dt)
    local dx, dy, dz = 0, 0, 0

    if love.keyboard.isDown("w") then dz = dz + 1 end
    if love.keyboard.isDown("s") then dz = dz - 1 end
    if love.keyboard.isDown("a") then dx = dx - 1 end
    if love.keyboard.isDown("d") then dx = dx + 1 end
    if love.keyboard.isDown("q") then dy = dy + 1 end
    if love.keyboard.isDown("e") then dy = dy - 1 end

    if dx ~= 0 or dy ~= 0 or dz ~= 0 then
        local len = math.sqrt(dx*dx + dy*dy + dz*dz)
        dx, dy, dz = dx/len, dy/len, dz/len

        camera.position.x = camera.position.x + dx * speed * dt
        camera.position.y = camera.position.y + dy * speed * dt
        camera.position.z = camera.position.z + dz * speed * dt

        image = Renderer.render(scene, camera, renderWidth, renderHeight)
    end
end

function love.draw()
    love.graphics.clear(0, 0, 0)
    love.graphics.draw(image, 0, 0, 0, width / renderWidth, height / renderHeight)
end

function setScene()
    camera = Camera(Vector(0, 0, -6), math.pi/1.2)

    sphere1 = Sphere(Vector(-5, 0, 9), 2, {
        color = Color(255, 100, 100),
        reflectivity = false,
        transparency = false
    })

    sphere2 = Sphere(Vector(5, 0, 6), 2, {
        color = Color(0, 255, 100),
        reflectivity = false,
        transparency = false
    })

    sphere3 = Sphere(Vector(0, 1, 7), 3, {
        color = Color(0, 40, 255),
        reflectivity = false,
        transparency = false
    })

    light1 = Light(Vector(-9, 0, 2), 1)

    return Scene({sphere1, sphere2, sphere3}, {light1}, Color(0, 0, 0))
end