Bird = Class{}

local bird_image = love.graphics.newImage('graphics/bird.png')

GRAVITY = 20

function Bird:init()
    self.image = bird_image
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dy = 0
end

function Bird:update(dt)
    -- applying gravity to self.dy
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        sounds['jump']:play()

        -- anti gravity
        self.dy = -4
    end
    
    -- updating bird's y location
    self.y = self.y + self.dy
end

function Bird:collides(pipe)
    return (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH and
        (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end