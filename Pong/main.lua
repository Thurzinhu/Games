push = require 'lib/push'
Class = require 'lib/class'

require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/TitleScreenState'
require 'src/states/SelectState'
require 'src/states/ServeState'
require 'src/states/PlayState'
require 'src/states/PauseState'
require 'src/states/DoneState'

require 'src/Ball'

require 'src/Paddle'

local WINDOW_HEIGHT = 720
local WINDOW_WIDTH = 1280

VIRTUAL_HEIGHT = 243 
VIRTUAL_WIDTH = 432

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')

    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/font.ttf', 16)
    largeFont = love.graphics.newFont('fonts/font.ttf', 32)

    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    math.randomseed(os.time())

    sounds = {
        ['point'] = love.audio.newSource('sounds/point.wav', 'static'),
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['select'] = function() return SelectState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end,
        ['done'] = function() return DoneState() end
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
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

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- updating game based on current state
    gStateMachine:update(dt)

    -- reseting keysPressed and buttonsPressed tables
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    gStateMachine:render()

    push:finish()
end

function displayScore(paddles)
    love.graphics.setFont(largeFont)
    love.graphics.print(tostring(paddles.leftPaddle.points), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(paddles.rightPaddle.points), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end

function updatePaddles(dt, paddles, ball)
    local PADDLE_SPEED = 200

    if paddles.leftPaddle.isHuman then
        if love.keyboard.isDown('w') then
            paddles.leftPaddle.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            paddles.leftPaddle.dy = PADDLE_SPEED
        else
            paddles.leftPaddle.dy = 0
        end
    else
        if ball.y + ball.height < paddles.leftPaddle.y then
            paddles.leftPaddle.dy = -PADDLE_SPEED
        elseif ball.y > paddles.leftPaddle.y + paddles.leftPaddle.height then
            paddles.leftPaddle.dy = PADDLE_SPEED
        else
            paddles.leftPaddle.dy = 0
        end
    end

    if paddles.rightPaddle.isHuman then
        if love.keyboard.isDown('up') then
            paddles.rightPaddle.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            paddles.rightPaddle.dy = PADDLE_SPEED
        else
            paddles.rightPaddle.dy = 0
        end
    else
        if ball.y + ball.height < paddles.rightPaddle.y then
            paddles.rightPaddle.dy = -PADDLE_SPEED
        elseif ball.y > paddles.rightPaddle.y + paddles.rightPaddle.height then
            paddles.rightPaddle.dy = PADDLE_SPEED
        else
            paddles.rightPaddle.dy = 0
        end
    end
    
    paddles.leftPaddle:update(dt)
    paddles.rightPaddle:update(dt)
end