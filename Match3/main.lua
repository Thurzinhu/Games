require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('Match-3')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        vsync = true,
        fullscreen = false
    })

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 32),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 64)
    }

    gTextures = {
        ['main'] = love.graphics.newImage('graphics/match3.png')
    }

    gFrames = {
        ['tiles'] = generateTiles(generateQuads(gTextures.main, 32, 32))
    }

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('title')

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
    gStateMachine:update()

    -- reseting keysPressed table each frame
    love.keyboard.keysPressed = {}

    Timer.update(dt)
end

function love.draw()
    push:start()

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    gStateMachine:render()

    push:finish()
end
