ScoreState = Class{__includes = BaseState}

local copper_medal = love.graphics.newImage('graphics/copper_medal.png')
local silver_medal = love.graphics.newImage('graphics/silver_medal.png')
local gold_medal = love.graphics.newImage('graphics/gold_medal.png')
local special_medal = love.graphics.newImage('graphics/special_medal.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Game Over', VIRTUAL_WIDTH / 2 - 50, 80, 100, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), VIRTUAL_WIDTH / 2 - 50, 100, 100, 'center')
    
    if self.score >= 16 then
        love.graphics.draw(special_medal, VIRTUAL_WIDTH / 2 - 25, VIRTUAL_HEIGHT / 2 - 25, 0, 2, 2)
    elseif self.score >= 8 then
        love.graphics.draw(gold_medal, VIRTUAL_WIDTH / 2 - 25, VIRTUAL_HEIGHT / 2 - 25, 0, 2, 2)
    elseif self.score >= 4 then
        love.graphics.draw(silver_medal, VIRTUAL_WIDTH / 2 - 25, VIRTUAL_HEIGHT / 2 - 25, 0, 2, 2)
    elseif self.score >= 2 then
        love.graphics.draw(copper_medal, VIRTUAL_WIDTH / 2 - 25, VIRTUAL_HEIGHT / 2 - 25, 0, 2, 2)
    end

    -- love.graphics.setFont(smallFont)
    -- love.graphics.printf('Press Enter to Play Again', VIRTUAL_WIDTH / 2 - 50, 180, 100, 'center')
end