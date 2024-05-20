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
    local tileMap = {}
    
    for y = 1, self.height do
        table.insert(tileMap, {})
        for x = 1, self.width do
            table.insert(tileMap[y], nil)
        end
    end

    for x = 1, self.width do
        if self:shouldSpawnPillar() then
            self:spawnPillar(tileMap, x)
        elseif self:shouldSpawnHole() then 
            self:spawnHole(tileMap, x)
        else 
            self:spawFlatSurface(tileMap, x)
        end
    end

    local map = TileMap {
        width = self.width,
        height = self.height,
        tiles = tileMap
    }

    return map
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