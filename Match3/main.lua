require 'src/Dependencies'

local backgroundScroll = 0

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
        ['main'] = love.graphics.newImage('graphics/match3.png'),
        ['background'] = love.graphics.newImage('graphics/background.jpg')
    }

    gFrames = {
        ['tiles'] = generateTiles(generateQuads(gTextures.main, 32, 32))
    }

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('title')

    math.randomseed(os.time())

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLLING_SPEED * dt) % BACKGROUND_LOOPING_POINT

    gStateMachine:update(dt)

    -- reseting keysPressed and buttonsPressed tables each frame
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 
        -backgroundScroll, 0, 
        -- no rotation
        0,
        -- scaling Y axis so it fills the screen
        1, VIRTUAL_HEIGHT / (backgroundHeight - 1)
    )

    gStateMachine:render()

    push:finish()
end

function printWithShadow(text, x, y, limit, allign, highlightColor)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(text, x, y + 2, limit, allign)
    
    if highlightColor then
        love.graphics.setColor(highlightColor)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.printf(text, x, y, limit, allign)
end