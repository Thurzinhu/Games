PipePair = Class{}

MIN_HEIGHT = 80

function PipePair:init(gap_height)
    self.y = math.random(-PIPE_HEIGHT + MIN_HEIGHT, VIRTUAL_HEIGHT - (MIN_HEIGHT + gap_height + PIPE_HEIGHT))
    self.x = VIRTUAL_WIDTH + PIPE_WIDTH
    
    self.pipes = {
        ['top'] = Pipe('top', self.y),
        ['bottom'] = Pipe('bottom', self.y + PIPE_HEIGHT + gap_height)
    }

    self.pairScored = false
    self.remove = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        for i, pipe in pairs(self.pipes) do
            pipe:update(dt)
        end
    else
        self.remove = true
    end
end

function PipePair:render()
    for i, pipe in pairs(self.pipes) do
        pipe:render()
    end
end