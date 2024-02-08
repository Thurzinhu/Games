DoneState = Class{__includes = BaseState}

function DoneState:enter(params)
    self.winner = params.winner
end

function DoneState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('select')
    end
end

function DoneState:render()
    winningPlayer = self.winner == 'left' and 1 or 2

    love.graphics.setFont(largeFont)
    love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to restart!', 0, 80, VIRTUAL_WIDTH, 'center')
end