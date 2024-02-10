PowerUp = Class{}

local POWER_UP_SPEED = 60

local powerUps = {
    'heal',
    'double-balls',
    'paddle-increase',
    'paddle-decrease',
    'key'
}

function PowerUp:init(x, y, brick)
    self.x = x
    self.y = y

    if brick.hasKey then
        self.type = 'key'
    else
        self.type = powerUps[math.random(1, 4)]
    end

    self.height = 16
    self.width = 16

    self.inPlay = true
    self.dy = POWER_UP_SPEED
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    love.graphics.draw(gTextures.main, gFrames['power-ups'][table.getIndex(powerUps, self.type)], self.x, self.y)
end

function PowerUp:performAction(state)
    if self.type == 'double-balls' then
        PowerUp.doubleBalls(state) 
    elseif self.type == 'paddle-increase' then
        PowerUp.increasePaddle(state)
    elseif self.type == 'paddle-decrease' then
        PowerUp.decreasePaddle(state)
    elseif self.type == 'heal' then
        PowerUp.heal(state)
    else 
        PowerUp.unlockBrick(state)
    end
end

function PowerUp.doubleBalls(state)
    local skin = state.balls[1].skin

    local newBalls = {}
    for _, ball in pairs(state.balls) do
        local newBall = Ball(math.random(7))
        newBall.x = ball.x
        newBall.y = ball.y
        newBall:setRandomVelocity()

        table.insert(newBalls, newBall)
    end

    for _, ball in pairs(newBalls) do
        table.insert(state.balls, ball)
    end
end

function PowerUp.increasePaddle(state)
    state.paddle:increaseWidth()
end

function PowerUp.decreasePaddle(state)
    state.paddle:decreaseWidth()
end

function PowerUp.heal(state)
    if state.hearts < 3 then
        state.hearts = state.hearts + 1
    end
end

function PowerUp.unlockBrick(state)
    for _, brick in pairs(state.bricks) do
        if brick.isLocked then
            brick:unlock()
            break
        end
    end
end

function table.getIndex(tbl, name)
    for i, item in ipairs(tbl) do
        if item == name then
            return i
        end
    end

    return nil
end