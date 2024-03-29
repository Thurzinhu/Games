HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gSounds['warn']:play()

        gStateMachine:change('title', {
            highlightedOption = 2,
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()
    love.graphics.setFont(gFonts.large)
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts.medium)
    local highScores = 10
    for i = 1, highScores do
        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4, 60 + i * 13, 50, 'left')

        love.graphics.printf(self.highScores[i].name, VIRTUAL_WIDTH / 4 + 38, 60 + i * 13, 50, 'right')

        love.graphics.printf(tostring(self.highScores[i].score), VIRTUAL_WIDTH / 2, 60 + i * 13, 100, 'right')
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press Escape to return to the main menu!", 0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end