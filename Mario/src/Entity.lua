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

function Entity:resolveBottomCollision()
    local bottomLeftTile = self.tileMap:coordinateToTile(self.x + 2, self.y + self.height)
    local bottomRightTile = self.tileMap:coordinateToTile(self.x + self.width - 2, self.y + self.height)
    local collision, shiftY = false, 0
    local tile = (
        bottomLeftTile:collidable() and bottomLeftTile or 
        bottomRightTile:collidable() and bottomRightTile
    )
    if tile then
        collision = true
        self.y = (tile.gridY - 1)*tile.height - self.height
    end

    return collision
end

function Entity:resolveTopCollision()
    local topLeftTile = self.tileMap:coordinateToTile(self.x, self.y)
    local topRightTile = self.tileMap:coordinateToTile(self.x + self.width, self.y)
end

function Entity:resolveLeftCollision()
    local topLeftTile = self.tileMap:coordinateToTile(self.x + 1, self.y + 1)
    local bottomLeftTile = self.tileMap:coordinateToTile(self.x + 1, self.y + self.height - 1)
    local collision, shiftX = false, 0
    local tile = (
        topLeftTile:collidable() and topLeftTile or 
        bottomLeftTile:collidable() and bottomLeftTile
    )
    if tile then
        collision = true
        self.x = (tile.gridX - 1)*tile.width + tile.width
    end
    
    return collision
end

function Entity:resolveRightCollision()
    local topRightTile = self.tileMap:coordinateToTile(self.x + self.width - 1, self.y + 1)
    local bottomRightTile = self.tileMap:coordinateToTile(self.x + self.width - 1, self.y + self.height - 1)
    local collision, shiftX = false, 0
    local tile = (
        topRightTile:collidable() and topRightTile or 
        bottomRightTile:collidable() and bottomRightTile
    )
    if tile then
        collision = true
        self.x = (tile.gridX - 1)*tile.width - self.width
    end

    return collision
end