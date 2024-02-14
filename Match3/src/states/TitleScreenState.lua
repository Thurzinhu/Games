TitleScreenState = Class{__includes = BaseState}

local pallete = {
    [1] = {r = math.random(0, 255), g = math.random(0, 255), b = math.random(0, 255)},
    [2] = {r = math.random(0, 255), g = math.random(0, 255), b = math.random(0, 255)},
    [3] = {r = math.random(0, 255), g = math.random(0, 255), b = math.random(0, 255)},
    [4] = {r = math.random(0, 255), g = math.random(0, 255), b = math.random(0, 255)},
    [5] = {r = math.random(0, 255), g = math.random(0, 255), b = math.random(0, 255)}
}

function TitleScreenState:init()
    -- creating demonstrative board at the center of 
    -- the screen
    self.board = Board(128, 16, 10)
 
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            board = Board(240, 16, 1)
        })
    end
end

function TitleScreenState:render()
    self.board:render()

    -- draw rect behind Match 3
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 - 75, 150, 58, 6)

    love.graphics.setFont(gFonts.medium)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Match 3', 0, VIRTUAL_HEIGHT / 2 - 60, VIRTUAL_WIDTH, 'center')
end
