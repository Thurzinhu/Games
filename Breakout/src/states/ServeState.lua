ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.paddle = params.paddle
    self.hearts = params.hearts
    self.score = params.score
    self.bricks = params.bricks
    self.level = params.level
    self.highScores = params.highScores

    self.ball = Ball(math.random(7))
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = (self.paddle.x + self.paddle.width / 2) - self.ball.width / 2
 
    if love.keyboard.wasPressed('escape') then
        gSounds['warn']:play()

        gStateMachine:change('paddle-select', {
            currentPaddle = self.paddle.skin
        })
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            ball = self.ball,
            hearts = self.hearts,
            score = self.score,
            level = self.level,
            highScores = self.highScores
        })
    end
end

function ServeState:render()
    renderHearts(self.hearts)
    renderScore(self.score)
    
    for _, brick in pairs(self.bricks) do
        brick:render()
    end

    love.graphics.setFont(gFonts.large)
    love.graphics.printf('Level ' .. tostring(self.level), 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts.medium)
    love.graphics.printf('Press Enter to Serve', 0, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'center')

    self.paddle:render()
    self.ball:render()
end