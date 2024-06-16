LevelMaker = Class{}

function LevelMaker:init(width, height)
    self.width = width
    self.height = height
    self.tileSet = math.random(#gFrames['tiles']) 
    self.topSet = math.random(#gFrames['tileTops'])
    self.gameObjects = {}
    self.entities = {}
    self.tiles = {}
end

function LevelMaker:createMap()
    for y = 1, self.height do
        table.insert(self.tiles, {})
        for x = 1, self.width do
            table.insert(self.tiles[y], nil)
        end
    end

    local platformWidth = 0
    for x = 1, self.width do
        local spawningPlatform = (platformWidth > 0) and true or false 
        if spawningPlatform then
            self:spawnPlatform(x)
            platformWidth = platformWidth - 1
        else
            if self:shouldSpawnPillar() then
                self:spawnPillar(x)
            elseif self:shouldSpawnPlatform() then
                self:spawnPlatform(x)
                platformWidth = math.random(1, 4) 
            elseif x ~= 1 and x ~= self.width and self:shouldSpawnHole() then 
                self:spawnHole(x)
            else
                self:spawnFlatSurface(x)
            end
        end
    end

    self:spawnKey()

    self.tileMap = TileMap {
        width = self.width,
        height = self.height,
        tiles = self.tiles
    }
    
    self.level = GameLevel {
        tileMap = self.tileMap,
        entities = self.entities,
        gameObjects = self.gameObjects
    }

    return self.level
end

function LevelMaker:shouldSpawnPillar()
    return math.random(5) == 1
end

function LevelMaker:spawnPillar(col)
    local pillarHeight = math.random(5, 6)
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
        self.tiles[y][col] = curTile
    end
    if self:shouldSpawnBush() then
        self:spawnBush(col, pillarHeight)
    end
end

function LevelMaker:shouldSpawnPlatform()
    return math.random(15) == 1
end

function LevelMaker:spawnPlatform(col)
    self:spawnFlatSurface(col)
    local platformHeight = 3
    table.insert(self.gameObjects, 
        GameObject {
            texture = gTextures['jumpBlocksSheet'],
            frame = gFrames['jumpBlocks'][2][1],
            x = (col - 1)*TILE_SIZE, 
            y = (platformHeight - 1)*TILE_SIZE,
            width = TILE_SIZE,
            height = TILE_SIZE,
            isCollidable = true,
            isConsumable = false,
            wasHit = false,
            onCollide = function(obj)
                if not obj.wasHit then
                    obj.frame = gFrames['jumpBlocks'][2][2]
                    obj.wasHit = true
                    local gem = GameObject {
                        texture = gTextures['gems'],
                        frame = gFrames['gems'][math.random(#gFrames['gems'])][1],
                        x = obj.x, 
                        y = obj.y,
                        width = TILE_SIZE,
                        height = TILE_SIZE,
                        isCollidable = false,
                        isConsumable = true,
                        onConsume = function(obj, player)
                            obj.isInGame = false
                            player.score = player.score + 30
                        end
                    }
                    table.insert(self.gameObjects, gem)

                    Timer.tween(0.1, {
                        [gem] = {y = obj.y - 16}
                    })
                end
            end
        }
    )
    self.tiles[platformHeight][col] = Tile {
        gridX = col,
        gridY = platformHeight,
        width = TILE_SIZE,
        height = TILE_SIZE,
        id = PLATFORM
    }
end

function LevelMaker:shouldSpawnHole()
    return math.random(8) == 1
end

function LevelMaker:spawnHole(col)
    for y = 1, self.height do
        self.tiles[y][col] = Tile {
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

function LevelMaker:spawnFlatSurface(col)
    for y = 1, self.height do     
        self.tiles[y][col] = Tile {
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
    if self:shouldSpawnBush() then
        self:spawnBush(col, 7)
    end
end


function LevelMaker:shouldSpawnBush()
    return math.random(5) == 1
end

function LevelMaker:spawnBush(x, y)
    table.insert(self.gameObjects, 
    GameObject {
        texture = gTextures['bushes'],
        frame = gFrames['bushes'][math.random(#gFrames['bushes'])][math.random(2) == 1 and math.random(2) or math.random(5, 7)],
        x = (x - 1)*TILE_SIZE, 
        y = (y - 1)*TILE_SIZE - TILE_SIZE,
        width = TILE_SIZE,
        height = TILE_SIZE,
        isCollidable = false,
        isConsumable = false
    })
end

function LevelMaker:spawnEntities(player)
    player = player or {x = -100}
    for y = 1, self.height do
        for x = 1, self.width do
            local curTile = self.tiles[y][x]
            if curTile.hasToping and self:shouldSpawnEnemy() then
                self:spawnEnemy((x - 1)*TILE_SIZE, (y - 1)*TILE_SIZE - 16, player)
            end
        end
    end
end

function LevelMaker:shouldSpawnEnemy()
    return math.random(5) == 1
end

function LevelMaker:spawnEnemy(x, y, player)
    local snail = Snail {
        x = x, 
        y = y,
        width = 16,
        height = 16,
        texture = gTextures['creaturesSheet'],
        frame = gFrames['snails'][math.random(2)],
        tileMap = self.tileMap
    }
    snail.stateMachine = StateMachine {
        ['move'] = function() return SnailMoveState(snail) end,
        ['idle'] = function() return SnailIdleState(snail) end,
        ['chase'] = function() return SnailChaseState(snail) end
    }
    snail:changeState(math.random(2) == 1 and 'idle' or 'move', {
        player = player
    })
    table.insert(self.level.entities, snail)
end

function LevelMaker:spawnKey()
    local jumpBlocks = {}
    for _, obj in pairs(self.gameObjects) do
        if obj.isCollidable then
            table.insert(jumpBlocks, obj)
        end
    end

    local randomIndex = math.random(1, math.floor(#jumpBlocks / 2))
    local keyJumpBlock = jumpBlocks[randomIndex] 
    keyJumpBlock.onCollide = function(obj)
        if not obj.wasHit then
            obj.frame = gFrames['jumpBlocks'][2][2]
            obj.wasHit = true
            local key = GameObject {
                texture = gTextures['keysLocks'],
                frame = gFrames['keys'][1],
                x = obj.x,
                y = obj.y,
                width = TILE_SIZE,
                height = TILE_SIZE,
                isCollidable = false,
                isConsumable = true,
                onConsume = function(obj, player)
                    obj.isInGame = false
                    player.hasKey = true
                end
            }
            table.insert(self.gameObjects, key)
                    
            Timer.tween(0.1, {
                [key] = {y = obj.y - 16}
            })
        end
    end

    local lockJumpBlock = jumpBlocks[math.random(randomIndex + 1, #jumpBlocks)]
    lockJumpBlock.texture = gTextures['keysLocks']
    lockJumpBlock.frame = gFrames['locks'][1]
    lockJumpBlock.onCollide = function(obj, player)
        if player.hasKey then
            player.tileMap:coordinateToTile(obj.x, obj.y).id = SKY
            obj.isInGame = false
            player.hasKey = false
            local height
            for y = 1, self.height do
                local curTile = self.tiles[y][self.width]
                if curTile.hasToping then
                    height = y 
                    break
                end
            end
            table.insert(player.level.gameObjects, GameObject {
                texture = gTextures['flags'],
                frame = gFrames['poles'][math.random(#gFrames['poles'])],
                x = (self.width - 1)*TILE_SIZE,
                y = (height - 1)*TILE_SIZE - 3*TILE_SIZE,
                width = TILE_SIZE,
                height = TILE_SIZE*3,
                isCollidable = false,
                isConsumable = true,
                onConsume = function(obj, player)
                    player.hasReachedGoal = true
                end
            })
        end
    end
end