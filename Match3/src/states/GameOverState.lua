GameOverState = Class{__includes = BaseState}

function GameOverState:enter()
    Timer.after(0.5, function()
        gSounds['game-over']:play()
    end)
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        Timer.clear()

        gStateMachine:change('title')
    end

    Timer.update(dt)
end

function GameOverState:render()
    local rect = {
        width = 256,
        height = 128
    }

    -- printing rect to display game over message
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - rect.width / 2, VIRTUAL_HEIGHT / 2 - rect.height / 2, rect.width, rect.height, 4)

    love.graphics.setFont(gFonts.medium)
    printWithShadow('Game', 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')
    printWithShadow('Over', 0, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts.small)
    printWithShadow('Press Enter to Continue', 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'center')
end