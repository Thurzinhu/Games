Paddle = Class{}

function Paddle:init(skin)
    self.width = 64
    self.height = 16
    
    -- initial x velocity set to 0
    self.dx = 0

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT - (self.height * 2) 

    self.size = 2
    self.skin = skin
end

function Paddle:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    self.x = self.x + self.dx * dt

    Collision.paddleWallsCollision(self)
end

function Paddle:render()
    love.graphics.draw(gTextures.main, gFrames['paddles'][(self.skin - 1) * 4 + self.size], self.x, self.y)
end

function Paddle:increaseWidth()
    if self.size < 4 then
        self.width = self.width + 32
        self.size = self.size + 1

        Collision.paddleWallsCollision(self)
    end
end

function Paddle:decreaseWidth()
    if self.size > 1 then
        self.width = self.width - 32
        self.size = self.size - 1
    end
end

function Paddle:reset()
    self.width = 64
    self.height = 16

    self.size = 2
end