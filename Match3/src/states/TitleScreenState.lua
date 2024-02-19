TitleScreenState = Class{__includes = BaseState}

local pallete = {
    [1] = {math.random(50, 255) / 255, math.random(50, 255) / 255, math.random(50, 255) / 255, 1},
    [2] = {math.random(50, 255) / 255, math.random(50, 255) / 255, math.random(50, 255) / 255, 1},
    [3] = {math.random(50, 255) / 255, math.random(50, 255) / 255, math.random(50, 255) / 255, 1},
    [4] = {math.random(50, 255) / 255, math.random(50, 255) / 255, math.random(50, 255) / 255, 1},
    [5] = {math.random(50, 255) / 255, math.random(50, 255) / 255, math.random(50, 255) / 255, 1},
    [6] = {math.random(50, 255) / 255, math.random(50, 255) / 255, math.random(50, 255) / 255, 1}
}

local spaceForTiles = 8 * TILE_WIDTH

function TitleScreenState:init()
    -- creating demonstrative board at the center of 
    -- the screen

    self.board = Board((VIRTUAL_WIDTH - spaceForTiles) / 2, (VIRTUAL_HEIGHT - spaceForTiles) / 2, 10)
    self.titleLetters = getCharsPositions('Match 3', VIRTUAL_HEIGHT / 2 - 60, gFonts.medium)
    self.transitionAlpha = 0

    self.colorTimer = Timer.every(0.1,
        function()
            local firstColor = pallete[1]

            for i = 1, 5 do
                pallete[i] = pallete[i + 1]
            end

            pallete[6] = firstColor
        end
    )

    self.buttons = {
        startButton = Button(VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT / 2 + 25, 60, 20, 'Start'),
        quitButton = Button(VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 + 50, 100, 20, 'Quit Game')
    }
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if self.buttons.startButton:wasPressed() then
        gSounds.select:play()

        Timer.tween(1, {
            [self] = {transitionAlpha = 1}
        })
        :finish(function()
            gStateMachine:change('begin-game', {
                level = 1
            })

            self.colorTimer:remove()
        end)

    elseif self.buttons.quitButton:wasPressed() then
        love.event.quit()
    end

    for _, button in pairs(self.buttons) do
        button:update(dt)
    end

    Timer.update(dt)
end

function TitleScreenState:render()
    self.board:render()
    
    -- making tiles in the background darker
    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    
    self:printTitle()
    self:printOptions()

    -- drawing rect for transition
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function TitleScreenState:printTitle()
    -- draw rect behind Match 3
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 - 75, 150, 58, 6)
    
    love.graphics.setFont(gFonts.medium)
    printWithShadow('Match 3', 0, VIRTUAL_HEIGHT / 2 - 60, VIRTUAL_WIDTH, 'center')

    for i = 1, 6 do
        love.graphics.setColor(pallete[i])
        love.graphics.printf(self.titleLetters[i][1], self.titleLetters[i][2], VIRTUAL_HEIGHT / 2 - 60, VIRTUAL_WIDTH, 'left')
    end
end

function TitleScreenState:printOptions()
    love.graphics.setColor(1, 1, 1, 128/255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + 20, 150, 58, 6)
    
    love.graphics.setFont(gFonts.small)
    
    for _, button in pairs(self.buttons) do
        button:render()
    end
end

function getCharsPositions(text, y, font)
    local startX = VIRTUAL_WIDTH / 2 - font:getWidth(text) / 2
    local positions = {}

    for i = 1, #text do
        local char = text:sub(i, i)
        local charWidth = font:getWidth(char)
        
        if char ~= ' ' then 
            table.insert(positions, {char, startX})
        end

        startX = startX + charWidth
    end

    return positions
end