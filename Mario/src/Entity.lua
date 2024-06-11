Entity = Class{}

function Entity:init(def)
    self.x = def.x 
    self.y = def.y
    self.dx = 0
    self.dy = 0
    self.width = def.width
    self.height = def.height
    self.texture = def.texture
    self.frame = def.frame
    self.direction = 'right'
    self.currentAnimation = def.currentAnimation
    self.stateMachine = def.stateMachine
    self.tileMap = def.tileMap
    self.level = def.level
    self.isInGame = true
end

function Entity:changeState(stateName, params)
    self.stateMachine:change(stateName, params)
end

function Entity:update(dt)
    self.currentAnimation:update(dt)
    self.stateMachine:update(dt)
end

function Entity:render()
    love.graphics.draw(
        self.texture,
        self.frame[self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + self.width / 2, math.floor(self.y) + self.height / 2, 0,
        self.direction == 'left' and -1 or 1, 1,
        self.width / 2, self.height / 2
    )
end

function Entity:collides(other)
    return not (
        self.x + self.width < other.x or self.x > other.x + other.width or
        self.y + self.height < other.y or self.y > other.y + other.height
    )
end

function Entity:checkBottomCollision()
    local bottomLeftTile = self.tileMap:coordinateToTile(self.x + 3, self.y + self.height)
    local bottomRightTile = self.tileMap:coordinateToTile(self.x + self.width - 3, self.y + self.height)
    return (
        bottomLeftTile and bottomLeftTile:collidable() or 
        bottomRightTile and bottomRightTile:collidable()
    )
end

function Entity:checkTopCollision()
    local topLeftTile = self.tileMap:coordinateToTile(self.x + 2, self.y)
    local topRightTile = self.tileMap:coordinateToTile(self.x + self.width - 2, self.y)
    return (
        topLeftTile and topLeftTile:collidable() or 
        topRightTile and topRightTile:collidable()
    )
end

function Entity:resolveBottomCollision()
    local bottomLeftTile = self.tileMap:coordinateToTile(self.x + 3, self.y + self.height)
    local bottomRightTile = self.tileMap:coordinateToTile(self.x + self.width - 3, self.y + self.height)
    local tile = (
        bottomLeftTile and bottomLeftTile:collidable() and bottomLeftTile or 
        bottomRightTile and bottomRightTile:collidable() and bottomRightTile
    )
    if tile then
        self.y = (tile.gridY - 1)*tile.height - self.height
    end
end

function Entity:resolveTopCollision()
    local topLeftTile = self.tileMap:coordinateToTile(self.x + 2, self.y)
    local topRightTile = self.tileMap:coordinateToTile(self.x + self.width - 2, self.y)
    local tile = (
        topLeftTile and topLeftTile:collidable() and topLeftTile or 
        topRightTile and topRightTile:collidable() and topRightTile
    )
    if tile then
        self.y = (tile.gridY - 1)*tile.height + tile.height
    end
end

function Entity:resolveLeftCollision()
    local topLeftTile = self.tileMap:coordinateToTile(self.x + 1, self.y + 1)
    local bottomLeftTile = self.tileMap:coordinateToTile(self.x + 1, self.y + self.height - 1)
    local tile = (
        topLeftTile and topLeftTile:collidable() and topLeftTile or 
        bottomLeftTile and bottomLeftTile:collidable() and bottomLeftTile
    )
    if tile then
        self.x = (tile.gridX - 1)*tile.width + tile.width
    end
end

function Entity:resolveRightCollision()
    local topRightTile = self.tileMap:coordinateToTile(self.x + self.width - 1, self.y + 1)
    local bottomRightTile = self.tileMap:coordinateToTile(self.x + self.width - 1, self.y + self.height - 1)
    local tile = (
        topRightTile and topRightTile:collidable() and topRightTile or 
        bottomRightTile and bottomRightTile:collidable() and bottomRightTile
    )
    if tile then
        self.x = (tile.gridX - 1)*tile.width - self.width
    end
end

function Entity:getCollidedGameObject()
    for _, object in pairs(self.level.gameObjects) do
        if self:collides(object) and object.isCollidable then
            return object
        end
    end
    return nil
end

function Entity:getConsumableGameObjects()
    local consumables = {}
    for _, object in pairs(self.level.gameObjects) do
        if self:collides(object) and object.isConsumable then
            table.insert(consumables, object)
        end
    end
    return consumables
end