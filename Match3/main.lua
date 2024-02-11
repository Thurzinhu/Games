require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('Match-3')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        vsync = true,
        fullscreen = false
    })

    gTextures = {
        ['main'] = love.graphics.newImage('graphics/match3.png')
    }

    gFrames = {
        ['tiles'] = generateQuads(gTextures.main, 32, 32)
    }

    Board = Board(240, 16)

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
end

function love.draw()
    push:start()

    Board:render()

    push:finish()
end
