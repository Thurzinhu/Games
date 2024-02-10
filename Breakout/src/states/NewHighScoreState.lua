NewHighScoreState = Class{__includes = BaseState}

local letters = {
    [1] = 0,
    [2] = 0,
    [3] = 0
}

function NewHighScoreState:enter(params)
    self.newHighScore = params.newHighScore
    self.highScores = params.highScores
    self.newHighScoreIndex = params.newHighScoreIndex
end

function NewHighScoreState:init()
    self.highlightedLetter = 1
end

function NewHighScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local name = string.char(letters[1] + 65) .. string.char(letters[2] + 65) .. string.char(letters[3] + 65)

        for i = 10, self.newHighScoreIndex, -1 do
            self.highScores[i + 1] = {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end
        
        self.highScores[self.newHighScoreIndex].name = name
        self.highScores[self.newHighScoreIndex].score = self.newHighScore

        local scores = ''
        for i = 1, 10 do
            scores = scores .. self.highScores[i].name .. '\n' .. tostring(self.highScores[i].score) .. '\n'
        end

        love.filesystem.write('breakout.txt', scores)

        gStateMachine:change('title', {
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('up') then
        letters[self.highlightedLetter] = (letters[self.highlightedLetter] + 1) % 26
    elseif love.keyboard.wasPressed('down') then
        letters[self.highlightedLetter] = (letters[self.highlightedLetter] - 1) % 26
    elseif love.keyboard.wasPressed('left') then
        self.highlightedLetter = self.highlightedLetter == 1 and 3 or self.highlightedLetter - 1
    elseif love.keyboard.wasPressed('right') then
        self.highlightedLetter = self.highlightedLetter == 3 and 1 or self.highlightedLetter + 1
    end
end

function NewHighScoreState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your score: ' .. tostring(self.newHighScore), 0, 80, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    
    --
    -- render all three characters of the name
    --
    if self.highlightedLetter == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(letters[1] + 65), VIRTUAL_WIDTH / 2 - 28, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if self.highlightedLetter == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(letters[2] + 65), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if self.highlightedLetter == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(letters[3] + 65), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'center')
end