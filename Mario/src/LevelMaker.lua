LevelMaker = Class{}

function LevelMaker:init(width, height)
    self.width = width
    self.height = height
    self.tileSet = math.random(#gFrames['tiles']) 
    self.topSet = math.random(#gFrames['tileTops'])
end

function LevelMaker:createMap()
    local gameObjects = {}
    local entities = {}
    local tiles = {}
    
    for y = 1, self.height do
        table.insert(tiles, {})
        for x = 1, self.width do
            table.insert(tiles[y], nil)
        end
    end

    for x = 1, self.width do
        if self:shouldSpawnPillar() then
            self:spawnPillar(tiles, x)
        elseif self:shouldSpawnHole() then 
            self:spawnHole(tiles, x)
        else 
            self:spawFlatSurface(tiles, x)
        end
    end

    local tileMap = TileMap {
        width = self.width,
        height = self.height,
        tiles = tiles
    }

    for y = 1, self.height do
        for x = 1, self.width do
            local curTile = tiles[y][x]
            if curTile.hasToping and y == 7 and self:shouldSpawnEnemy() then
                self:spawnEnemy(entities, tileMap, (x - 1)*TILE_SIZE, (y - 1)*TILE_SIZE - 16)
            end
        end
    end
    
    level = GameLevel {
        tileMap = tileMap,
        entities = entities
    }

    return level
end

function LevelMaker:shouldSpawnPillar()
    return math.random(5) == 1
end

function LevelMaker:spawnPillar(tiles, col)
    local pillarHeight = math.random(5, 7)
    
    for y = 1, self.height do
        local curTile = nil
        if y < pillarHeight then
            curTile = Tile {
                gridX = col,
                gridY = y,
                width = TILE_SIZE,
                height = TILE_SIZE,
                id = SKY,
                tileSet = self.tileSet,
                topSet = self.topSet
            }
        else
            curTile = Tile {
                gridX = col,
                gridY = y,
                width = TILE_SIZE,
                height = TILE_SIZE,
                id = GROUND,
                hasToping = (y == pillarHeight),
                tileSet = self.tileSet,
                topSet = self.topSet
            }
        end

        tiles[y][col] = curTile
    end
end

function LevelMaker:shouldSpawnPlatform()
    return math.random(20) == 1
end

function LevelMaker:spawnPlatform()

end

function LevelMaker:shouldSpawnHole()
    return math.random(5) == 1
end

function LevelMaker:spawnHole(tiles, col)
    for y = 1, self.height do
        tiles[y][col] = Tile {
            gridX = col,
            gridY = y,
            width = TILE_SIZE,
            height = TILE_SIZE,
            id = SKY,
            tileSet = self.tileSet,
            topSet = self.topSet
        }
    end
end

function LevelMaker:spawFlatSurface(tiles, col)
    for y = 1, self.height do     
        tiles[y][col] =  Tile {
            gridX = col,
            gridY = y,
            width = TILE_SIZE,
            height = TILE_SIZE,
            id =  y < 7 and SKY or GROUND,
            hasToping = (y == 7),
            tileSet = self.tileSet,
            topSet = self.topSet
        }
    end
end

function LevelMaker:shouldSpawnEnemy()
    return math.random(5) == 1
end

function LevelMaker:spawnEnemy(entities, tileMap, x, y)
    local snail = Snail {
        x = x, 
        y = y,
        width = 16,
        height = 16,
        texture = gTextures['creaturesSheet'],
        frame = gFrames['snails'][math.random(1, 2)],
        tileMap = tileMap
    }
    snail.stateMachine = StateMachine {
        ['move'] = function() return SnailMoveState(snail) end,
        ['idle'] = function() return SnailIdleState(snail) end,
        ['chase'] = function() return SnailChaseState(snail) end
    }

    table.insert(entities, snail)
end