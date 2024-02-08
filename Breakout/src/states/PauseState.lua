PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    love.audio.pause(gSounds['music'])
    gSounds['pause']:play()

    self.paddle = params.paddle
    self.hearts = params.hearts
    self.score = params.score
    self.bricks = params.bricks
    self.level = params.level
    self.highScores = params.highScores
    self.balls = params.balls
    self.powerUps = params.powerUps
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('p') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
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
end

function PauseState:render()
    love.graphics.setFont(gFonts.medium)
    love.graphics.printf('Game Paused', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    
    renderHearts(self.hearts)
    renderScore(self.score)

    for _, brick in pairs(self.bricks) do
        brick:render()
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

function PauseState:exit()
    gSounds['music']:play()
end