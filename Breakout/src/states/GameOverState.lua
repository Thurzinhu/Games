GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    gSounds['game-over']:play()
    
    self.highScores = params.highScores
    self.score = params.score
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        for i, player in pairs(self.highScores) do
            if self.score > player.score then
                gStateMachine:change('new-high-score', {
                    newHighScore = self.score,
                    highScores = self.highScores,
                    newHighScoreIndex = i
                })

                return
            end
        end

        gStateMachine:change('title', {
            highScores = self.highScores
        })
    end 
end

function GameOverState:render()
    love.graphics.setFont(gFonts.large)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts.medium)
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts.small)
    love.graphics.printf('Press Enter to continue', 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')
end