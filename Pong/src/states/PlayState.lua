PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.leftPaddle = params.leftPaddle
    self.rightPaddle = params.rightPaddle
    self.ball = params.ball

    -- leftPaddle starts serving
    self.leftPaddle:switchServing()
end

function PlayState:update(dt)
    updatePaddles(dt, {
        leftPaddle = self.leftPaddle,
        rightPaddle = self.rightPaddle
    },
    self.ball)

    if love.keyboard.wasPressed('p') then
        gStateMachine:change('pause', {
            leftPaddle = self.leftPaddle,
            rightPaddle = self.rightPaddle,
            ball = self.ball
        })
    end

    if self.ball:collides(self.leftPaddle) then
        self.ball.dx = -self.ball.dx * 1.03
        self.ball.x = self.ball.x + self.leftPaddle.width

        if self.ball.dy < 0 then
            self.ball.dy = math.random(-80, -100)
        else
            self.ball.dy = math.random(80, 100)
        end

        sounds['paddle_hit']:play()
    elseif self.ball:collides(self.rightPaddle) then
        self.ball.dx = -self.ball.dx * 1.03
        self.ball.x = self.ball.x - self.rightPaddle.width
        
        if self.ball.dy < 0 then
            self.ball.dy = math.random(-80, -100)
        else
            self.ball.dy = math.random(80, 100)
        end

        sounds['paddle_hit']:play()
    end

    if self.ball.y <= 0 then
        self.ball.dy = -self.ball.dy
        self.ball.y = 0

        sounds['wall_hit']:play()
    elseif self.ball.y + self.ball.height >= VIRTUAL_HEIGHT then
        self.ball.dy = -self.ball.dy
        self.ball.y = VIRTUAL_HEIGHT - self.ball.height
        
        sounds['wall_hit']:play()
    end

    if self.ball.x + self.ball.width < 0 then
        self.rightPaddle.points = self.rightPaddle.points + 1
        if self.rightPaddle.isServing then
            self.rightPaddle:switchServing()
            self.leftPaddle:switchServing()
        end
        sounds['point']:play()
        
        if self.rightPaddle.points == 10 then
            gStateMachine:change('done', {
                winner = 'right'
            })
        else 
            gStateMachine:change('serve', {
                leftPaddle = self.leftPaddle,
                rightPaddle = self.rightPaddle
            })
        end
    elseif self.ball.x > VIRTUAL_WIDTH then
        self.leftPaddle.points = self.leftPaddle.points + 1
        if self.leftPaddle.isServing then
            self.leftPaddle:switchServing()
            self.rightPaddle:switchServing()
        end
        sounds['point']:play()
        
        if self.leftPaddle.points == 10 then
            gStateMachine:change('done', {
                winner = 'left'
            })
        else 
            gStateMachine:change('serve', {
                leftPaddle = self.leftPaddle,
                rightPaddle = self.rightPaddle
            })
        end
    end

    self.ball:update(dt)
end

function PlayState:render()
    displayScore({
        leftPaddle = self.leftPaddle,
        rightPaddle = self.rightPaddle
    })

    self.leftPaddle:render()
    self.rightPaddle:render()
    self.ball:render()
end