ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.leftPaddle = params.leftPaddle
    self.rightPaddle = params.rightPaddle
    self.ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
end

function ServeState:update(dt)
    updatePaddles(dt, {
        leftPaddle = self.leftPaddle,
        rightPaddle = self.rightPaddle
    },
    self.ball)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.ball.dy = math.random(-50, 50)

        if self.leftPaddle.isServing then
            self.ball.dx = math.random(140, 200)
        else
            self.ball.dx = math.random(-200, -140)
        end

        gStateMachine:change('play', {
            leftPaddle = self.leftPaddle,
            rightPaddle = self.rightPaddle,
            ball = self.ball
        })
    end
end

function ServeState:render()
    servingPlayer = self.leftPaddle.isServing and 1 or 2

    love.graphics.setFont(smallFont)
    love.graphics.printf("Player's " .. tostring(servingPlayer) .. " serve", 0, 20, VIRTUAL_WIDTH, 'center')
    
    displayScore({
        leftPaddle = self.leftPaddle,
        rightPaddle = self.rightPaddle
    })

    self.leftPaddle:render()
    self.rightPaddle:render()
    self.ball:render()
end