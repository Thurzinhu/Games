require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('Mario Bros')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        vsync = true,
        fullscreen = false
    })

    math.randomseed(os.time())
    levelMaker = LevelMaker(200, 20)
    level = levelMaker:createMap()

    mario = Player {
        x = 0, 
        y = 0,
        width = PLAYER_WIDTH,
        height = PLAYER_HEIGHT,
        texture = gTextures['playerSheet'],
        frame = gFrames['player'],
        stateMachine = StateMachine {
            ['move'] = function() return PlayerMoveState(mario) end,
            ['idle'] = function() return PlayerIdleState(mario) end,
            ['jump'] = function() return PlayerJumpState(mario) end,
            ['fall'] = function() return PlayerFallState(mario) end
        },
        tileMap = level.tileMap
    }
    
    mario:changeState('fall')

    camera = Camera {
        tracked = mario,
        tileMap = level.tileMap
    }

    for i, entity in pairs(level.entities) do
        entity:changeState('move', {
            player = mario
        })
    end

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
    mario:update(dt)
    camera:update(dt)
    level:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    
    love.graphics.clear(1, 1, 1, 1)
    camera:track()

    level:render()
    mario:render()
    
    push:finish()
end