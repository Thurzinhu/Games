function generateQuads(spriteSheet, tileWidth, tileHeight)
    local quads = {}

    -- dividing atlas evenly
    local verticalTiles = spriteSheet:getHeight() / tileHeight
    local horizontalTiles = spriteSheet:getWidth() / tileWidth

    for y = 0, verticalTiles - 1 do
        for x = 0, horizontalTiles - 1 do
            table.insert(quads, love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, spriteSheet))
        end
    end

    return quads
end

function table.slice(table, first, last, step)
    local slicedTable = {}

    for i = first or 1, last or #table, step or 1 do
        slicedTable[#slicedTable + 1] = table[i]
    end

    return slicedTable
end

function generateBricks()
    return table.slice(generateQuads(gTextures.main, 32, 16), 1, 21, 1)
end

function generatePaddles()
    local x = 0
    local y = 16 * 4

    local paddleSkins = 4
    local paddleHeight = 16
    local paddleInitialWidth = 32

    paddles = {}
    for i = 0, paddleSkins - 1 do
        -- 32 width paddle
        table.insert(paddles, love.graphics.newQuad(
            x, 
            y, 
            paddleInitialWidth, 
            paddleHeight, 
            gTextures.main)
        )
        
        -- 64 width paddle
        table.insert(paddles, love.graphics.newQuad(
            x + paddleInitialWidth, 
            y,
            paddleInitialWidth * 2, 
            paddleHeight, 
            gTextures.main)
        )
        
        -- 96 width paddle
        table.insert(paddles, love.graphics.newQuad(
            x + paddleInitialWidth * 3, 
            y, 
            paddleInitialWidth * 3, 
            paddleHeight, 
            gTextures.main)
        )
        
        -- 128 width paddle
        table.insert(paddles, love.graphics.newQuad(
            x, 
            y + paddleHeight, 
            paddleInitialWidth * 4, 
            paddleHeight, 
            gTextures.main)
        )
        
        y = y + (2 * paddleHeight)
    end

    return paddles
end

function generateBalls()
    -- first ball coordinates
    local x = 32 * 3
    local y = 16 * 3

    local ballWidth = 32 / 4
    local ballHeight = 16 / 2
    
    local balls = {}

    -- getting first four balls
    local ballsFirstRow = 4
    for i = 0, ballsFirstRow - 1 do
        table.insert(balls, love.graphics.newQuad(x + ballWidth * i, y, ballWidth, ballHeight, gTextures.main))
    end
    
    y = y + ballHeight

    -- gettig last three balls 
    local ballsSecondRow = 3
    for i = 0, ballsSecondRow - 1 do
        table.insert(balls, love.graphics.newQuad(x + ballWidth * i, y, ballWidth, ballHeight, gTextures.main))
    end

    return balls
end

function generatePowerUps()
    local x = 32
    local y = 16 * 12
    local powerUpWidth = 16
    local powerUpHeight = 16
    local powerUps = {}

    local powers = 5
    for i = 0, powers - 1 do
        table.insert(powerUps, love.graphics.newQuad(x + powerUpWidth * i, y, powerUpWidth, powerUpHeight, gTextures.main))

        if i == 3 then
            x = x + 3 * 16
        end
    end

    return powerUps
end

function generateLockedBrick()
    local x = 32 * 5
    local y = 16 * 3
    local brickWidth = 32
    local brickHeight = 16

    return love.graphics.newQuad(x, y, brickWidth, brickHeight, gTextures.main)
end