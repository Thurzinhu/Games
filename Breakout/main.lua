require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Breakout')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        resizable = true,
        fullscreen = false
    })

    gSounds = {
        ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['brick-hit'] = love.audio.newSource('sounds/brick_hit.wav', 'static'),
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['choose'] = love.audio.newSource('sounds/choose.wav', 'static'),
        ['warn'] = love.audio.newSource('sounds/warn.wav', 'static'),
        ['point'] = love.audio.newSource('sounds/point.wav', 'static'),
        ['power-up'] = love.audio.newSource('sounds/power_up.wav', 'static'),
        ['ball-out'] = love.audio.newSource('sounds/ball_out.wav', 'static'),
        ['game-over'] = love.audio.newSource('sounds/game_over.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static')
    }

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    gTextures = {
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    gFrames = {
        ['bricks'] = generateBricks(),
        ['paddles'] = generatePaddles(),
        ['balls'] = generateBalls(),
        ['arrows'] = generateQuads(gTextures.arrows, gTextures.arrows:getWidth() / 2, gTextures.arrows:getHeight()),
        ['hearts'] = generateQuads(gTextures.hearts, gTextures.hearts:getWidth() / 2, gTextures.hearts:getHeight()),
        ['power-ups'] = generatePowerUps(),
        ['locked-brick'] = generateLockedBrick()
    }

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['high-score'] = function() return HighScoreState() end,
        ['paddle-select'] = function() return PaddleSelectState() end, 
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['victory'] = function() return VictoryState() end,
        ['game-over'] = function() return GameOverState() end,
        ['new-high-score'] = function() return NewHighScoreState() end,
        ['pause'] = function() return PauseState() end
    }
    gStateMachine:change('title', {
        highScores = loadHighScores()
    })

    math.randomseed(os.time())

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

-- saving keys pressed by user in each frame
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

-- returns if a key was pressed or not
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)

    -- reseting keys pressed by user 
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    gStateMachine:render()
    
    push:finish()
end

function renderHearts(hearts)
    local max_hearts = 3

    for i = 0, hearts - 1 do
        love.graphics.draw(gTextures.hearts, gFrames.hearts[1], VIRTUAL_WIDTH - 100 + (i * 12), 4)
    end

    for i = 0, max_hearts + (-hearts - 1) do
        love.graphics.draw(gTextures.hearts, gFrames.hearts[2], VIRTUAL_WIDTH - 100 + ((i + hearts) * 12), 4)
    end
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

function loadHighScores()
    love.filesystem.setIdentity('breakout')

    local maxHighScores = 10
    if not love.filesystem.getInfo('breakout.txt') then
        local scores = ''
        for i = maxHighScores, 1, -1 do
            if i == 1 then
                scores = scores .. 'CTO\n' .. tostring(i * 1000) 
            else
                scores = scores .. 'CTO\n' .. tostring(i * 1000) .. '\n' 
            end
        end

        love.filesystem.write('breakout.txt', scores)
    end

    local scores = {}

    for i = 1, maxHighScores do
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    local isName = true
    local count = 1
    for line in love.filesystem.lines('breakout.txt') do
        if isName then
            scores[count].name = string.sub(line, 1, 3) 
        else
            scores[count].score = tonumber(line)
            count = count + 1
        end

        isName = not isName
    end

    return scores
end