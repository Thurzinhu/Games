Paddle = Class{}

function Paddle:init(x, y, width, height, isHuman)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.points = 0
    self.isServing = false
    self.isHuman = isHuman

    self.dy = 0
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    elseif self.dy > 0 then
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Paddle:switchServing()
    self.isServing = not self.isServing
end

function Paddle:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end