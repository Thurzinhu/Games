Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('graphics/pipe.png')

PIPE_SPEED = 70

PIPE_WIDTH = PIPE_IMAGE:getWidth()
PIPE_HEIGHT = PIPE_IMAGE:getHeight()

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH + PIPE_WIDTH
    self.y = y
    self.orientation = orientation
    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT
    self.dx = -PIPE_SPEED
end

function Pipe:update(dt)
    self.x = self.x + self.dx * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
    (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
    0, 1, (self.orientation == 'top' and -1 or 1))
end