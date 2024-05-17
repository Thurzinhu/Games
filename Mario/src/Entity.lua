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
    self.map = def.map
end

function Entity:changeState(stateName, params)
    self.stateMachine:change(stateName, params)
end

function Entity:update(dt)
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

function Entity:checkBottomCollision()
    return self.y > 6 * TILE_SIZE - PLAYER_HEIGHT
end

function Entity:checkTopCollision()

end

function Entity:checkLeftCollision()

end

function Entity:checkRightCollision()

end