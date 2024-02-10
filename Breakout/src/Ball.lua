Ball = Class{}

function Ball:init(skin)
    self.width = 8
    self.height = 8
    
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT - (self.height * 5) - 2

    self.dy = 0
    self.dx = 0

    self.inPlay = true
    self.skin = skin
end

function Ball:setRandomVelocity()
    self.dx = math.random(-200, 200)
    self.dy = math.random(-50, -60)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if math.abs(self.dy) < 150 then
        self.dy = self.dy + dt * 1.02
    end

    Collision.ballWallsCollision(self)
end

function Ball:render()
    love.graphics.draw(gTextures.main, gFrames['balls'][self.skin], self.x, self.y)
end