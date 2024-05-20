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
    map = levelMaker:createMap()

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
        tileMap = map
    }
    
    mario:changeState('fall')

    camera = Camera {
        tracked = mario,
        map = map
    }

    -- slimeMoving = Animation {
    --     frames = {1, 2},
    --     interval = 0.5
    -- }

    -- slime = Entity {
    --     x = 32, 
    --     y = (6 * TILE_SIZE) - 16,
    --     width = 16,
    --     height = 16,
    --     texture = gTextures['slimes'],
    --     frame = gFrames['slimes'],
    --     tileMap = map,
    --     currentAnimation = slimeMoving
    -- }
    -- slime.direction = 'left'
    -- slime.dx = PLAYER_MOVE_SPEED

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

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    
    love.graphics.clear(1, 1, 1, 1)
    camera:track()
    map:render()

    love.graphics.draw(gTextures['jumpBlocksSheet'], gFrames['jumpBlocks'][5][6], 0, 0)
    mario:render()

    push:finish()
end