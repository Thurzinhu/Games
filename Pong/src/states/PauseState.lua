PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    self.leftPaddle = params.leftPaddle
    self.rightPaddle = params.rightPaddle
    self.ball = params.ball
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            leftPaddle = self.leftPaddle,
            rightPaddle = self.rightPaddle,
            ball = self.ball
        })
    end
end

function PauseState:render()
    love.graphics.setFont(smallFont)
    love.graphics.printf("Game is Paused", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to Continue", 0, 20, VIRTUAL_WIDTH, 'center')
end