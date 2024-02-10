push = require 'lib/push'

Class = require 'lib/class'

require 'src/Bird'

require 'src/Pipe'

require 'src/PipePair'

require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/TitleScreenState'
require 'src/states/CountdownState'
require 'src/states/PlayState'
require 'src/states/PauseState'
require 'src/states/ScoreState'

local background = love.graphics.newImage('graphics/background.png')
local ground = love.graphics.newImage('graphics/ground.png')

local backgroundScroll = 0
local groundScroll = 0

local BACKGROUND_SCROLLING_SPEED = 30
local GROUND_SCROLLING_SPEED = 60

local BACKGROUND_LOOPING_POINT = 318
local GROUND_LOOPING_POINT = 438

local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

scrolling = false

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end,
        ['score'] = function() return ScoreState() end
    }

    sounds = {
        ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/shock.wav', 'static'),
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['point'] = love.audio.newSource('sounds/point.wav', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    gStateMachine:change('title')

end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
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

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLLING_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLLING_SPEED * dt) % GROUND_LOOPING_POINT
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - ground:getHeight())

    push:finish()
end
