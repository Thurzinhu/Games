PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.paddle = params.paddle
    self.hearts = params.hearts
    self.score = params.score
    self.bricks = params.bricks
    self.level = params.level
    self.highScores = params.highScores

    self.balls = params.balls or {}
    self.powerUps = params.powerUps or {}
    self.psystems = {}

    if params.ball then
        -- give ball random starting velocity
        params.ball:setRandomVelocity()
    
        -- adding starting ball to balls table
        table.insert(self.balls, params.ball)
    end
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('pause', {
            paddle = self.paddle,
            hearts = self.hearts,
            score = self.score,
            level = self.level,
            bricks = self.bricks,
            highScores = self.highScores,
            balls = self.balls,
            powerUps = self.powerUps
        })
    end

    for _, ball in pairs(self.balls) do
        Collision.ballPaddleCollision(ball, self.paddle)

        for _, brick in pairs(self.bricks) do
            if Collision.ballBrickCollision(ball, brick) then
                
                table.insert(self.psystems, brick:hit())

                if (brick.hasPowerUp or brick.hasKey) and not brick.inPlay then
                    table.insert(self.powerUps, PowerUp(
                        brick.x + brick.width / 2 - 8, 
                        brick.y + brick.height / 2 - 8,
                        brick 
                        )
                    )
                end
                
                if not brick.isLocked then
                    gSounds['point']:play()

                    self.score = self.score + (brick.tier * 100) + ((brick.skin) * 50)
                end

                break
            end
        end

        if ball.y >= VIRTUAL_HEIGHT then
            gSounds['ball-out']:play()
            ball.inPlay = false
        end

        ball:update(dt)
    end

    for _, powerUp in pairs(self.powerUps) do
        if Collision.paddlePowerUpCollision(self.paddle, powerUp) then
            powerUp:performAction(self)
        end

        powerUp:update(dt)
    end

    -- removing psystems that are no longer active and
    -- updating the active ones
    for i = #self.psystems, 1, -1 do
        if self.psystems[i]:getCount() == 0 then
            table.remove(self.psystems, i)
        else
            self.psystems[i]:update(dt)
        end
    end

    table.update(self.balls)
    table.update(self.bricks)
    table.update(self.powerUps)

    if not next(self.bricks) then
        self.paddle:reset()

        gStateMachine:change('victory', {
            paddle = self.paddle,
            hearts = self.hearts,
            score = self.score,
            level = self.level,
            highScores = self.highScores
        })
    end
    
    if not next(self.balls) then
        if self.hearts == 1 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                hearts = self.hearts - 1,
                score = self.score,
                bricks = self.bricks,
                level = self.level,
                highScores = self.highScores
            })
        end
    end

    self.paddle:update(dt)
end

function PlayState:render()
    renderHearts(self.hearts)
    renderScore(self.score)

    for _, brick in pairs(self.bricks) do
        brick:render()
    end

    -- printing particles after bricks so their visualization is
    -- not affected by the bricks
    for _, psystem in pairs(self.psystems) do
        love.graphics.draw(psystem)
    end
    
    for _, ball in pairs(self.balls) do
        ball:render()
    end

    for _, powerUp in pairs(self.powerUps) do
        powerUp:render()
    end
        
    self.paddle:render()

    displayFPS()
end

function table.update(tbl)
    for i = #tbl, 1, -1 do
        local item = tbl[i]
        if not item.inPlay then
            table.remove(tbl, i)
        end
    end    
end