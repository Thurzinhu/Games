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
    map = TileMap {
        width = 100,
        height = 20
    }

    tileSet = math.random(1, #gFrames['tiles'])
    topSet = math.random(1, #gFrames['tileTops'])

    for y = 1, map.height do
        table.insert(map.tiles, {})
        for x = 1, map.width do
            table.insert(map.tiles[y], Tile {
                GridX = x,
                GridY = y,
                width = TILE_SIZE,
                height = TILE_SIZE,
                id =  y < 7 and SKY or GROUND,
                hasToping = (y == 7),
                tileSet = tileSet,
                topSet = topSet
            })
        end
    end

    mario = Player {
        x = VIRTUAL_WIDTH / 2 - PLAYER_WIDTH / 2, 
        y = 6 * TILE_SIZE - PLAYER_HEIGHT,
        width = PLAYER_WIDTH,
        height = PLAYER_HEIGHT,
        texture = gTextures['playerSheet'],
        frame = gFrames['player'],
        stateMachine = StateMachine {
            ['move'] = function() return PlayerMoveState(mario) end,
            ['idle'] = function() return PlayerIdleState(mario) end,
            ['jump'] = function() return PlayerJumpState(mario) end,
            ['fall'] = function() return PlayerFallState(mario) end
        }
    }
    
    mario:changeState('idle')
    
    cameraScroll = 0

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
    mario.currentAnimation:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    cameraScroll = mario.x - VIRTUAL_WIDTH / 2 + PLAYER_WIDTH / 2 

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    
    love.graphics.clear(1, 1, 1, 1)
    
    cameraScroll = math.max(cameraScroll, 0)
    cameraScroll = math.min(cameraScroll, map.width * TILE_SIZE - VIRTUAL_WIDTH)

    love.graphics.translate(math.floor(-cameraScroll), 0)

    map:render()

    love.graphics.draw(gTextures['jumpBlocksSheet'], gFrames['jumpBlocks'][5][6], 0, 0)
    mario:render()

    push:finish()
end