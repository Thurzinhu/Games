Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = 0
    self.dy = 0
end

function Ball:collides(paddle)
    if (self.y + self.height < paddle.y) or (self.y > paddle.y + paddle.height) then
        return false
    elseif (self.x + self.width < paddle.x) or (self.x > paddle.x + paddle.width) then
        return false
    end

    return true
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
end

function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end