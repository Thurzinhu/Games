VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.paddle = params.paddle
    self.hearts = params.hearts
    self.score = params.score
    self.level = params.level
    self.highScores = params.highScores
end

function VictoryState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            paddle = self.paddle,
            hearts = self.hearts,
            score = self.score,
            level = self.level + 1,
            bricks = LevelMaker.createMap(self.level + 1),
            highScores = self.highScores
        })
    end 
end

function VictoryState:render()
    love.graphics.setFont(gFonts.large)
    love.graphics.printf('Level ' .. tostring(self.level) .. ' Cleared', 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts.medium)
    love.graphics.printf('Press Enter to Serve', 0, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'center')
end