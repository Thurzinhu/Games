SelectState = Class{__includes = BaseState}

function SelectState:init()
    self.highlightedOption = 1
end

function SelectState:update(dt)
    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('left') then
        self.highlightedOption = self.highlightedOption == 1 and 2 or 1
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.highlightedOption == 1 then
            gStateMachine:change('serve', {
                leftPaddle = Paddle(10, 30, 5, 20, true),
                rightPaddle = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20, false)
            })
        else
            gStateMachine:change('serve', {
                leftPaddle = Paddle(10, 30, 5, 20, true),
                rightPaddle = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20, true)
            })
        end
    end
end

function SelectState:render()
    love.graphics.setFont(smallFont)
    love.graphics.printf('Select Game Mode', 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    if self.highlightedOption == 1 then
        love.graphics.setColor(1, 1, 0, 1)
    end
    love.graphics.printf('One Player', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH / 2, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    if self.highlightedOption == 2 then
        love.graphics.setColor(1, 1, 0, 1)
    end
    love.graphics.printf('Two Players', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH / 2, 'center')
    love.graphics.setColor(1, 1, 1, 1)
end