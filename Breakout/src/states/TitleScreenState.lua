TitleScreenState = Class{__includes = BaseState} -- derived from BaseState

function TitleScreenState:enter(params)
    self.highlightedOption = params.highlightedOption or 1
    self.highScores = params.highScores
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    elseif love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        -- changing selected option
        gSounds['select']:play()
        
        self.highlightedOption = self.highlightedOption == 1 and 2 or 1 
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['choose']:play()

        if self.highlightedOption == 1 then
            gStateMachine:change('paddle-select', {
                highScores = self.highScores
            })
        else
            gStateMachine:change('high-score', {
                highScores = self.highScores
            })
        end
    end
end

function TitleScreenState:render()
    love.graphics.setFont(gFonts.large)
    love.graphics.printf('Breakout', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts.small)
    if self.highlightedOption == 1 then
        love.graphics.setColor(1, 1, 0, 1)
    end
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1) -- reseting highlighted color
    
    if self.highlightedOption == 2 then
        love.graphics.setColor(1, 1, 0, 1)
    end
    love.graphics.printf('HighScore', 0, VIRTUAL_HEIGHT / 2 + 60, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1) -- reseting highlighted color
end