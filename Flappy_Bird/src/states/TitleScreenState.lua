TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Flappy Bird', VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 - 80, 100, 'center')

    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to Start', VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 , 100, 'center')
end 