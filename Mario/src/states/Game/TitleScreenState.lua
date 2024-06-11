TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    self.startButton = Button({
        x = VIRTUAL_WIDTH / 2 - 60,
        y = VIRTUAL_HEIGHT / 2,
        text = "Start",
        width = 120,
        height = 30
    })
    self.quitButton = Button({
        x = VIRTUAL_WIDTH / 2 - 60,
        y = VIRTUAL_HEIGHT / 2 + 30,
        text = "Quit",
        width = 120,
        height = 30
    })
    self.levelMaker = LevelMaker(100, 20)
    self.level = self.levelMaker:createMap()
    self.levelMaker:spawnEntities()
end

function TitleScreenState:update(dt)
    self.startButton:update(dt)
    self.quitButton:update(dt)
    self.level:update(dt)
    if self.startButton:wasPressed() or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            score = 0
        })
    elseif self.quitButton:wasPressed() then
        love.event.quit()
    end
end

function TitleScreenState:render()
    love.graphics.clear(1, 1, 1, 1)
    self.level:render()
    self:renderTitle()
    self:renderOptions()
end

function TitleScreenState:renderTitle()
    local titleWidth = VIRTUAL_WIDTH * 0.4
    local titleHeight = VIRTUAL_HEIGHT * 0.3
    local titleX = VIRTUAL_WIDTH / 2 - titleWidth / 2
    local titleY = VIRTUAL_HEIGHT / 2 - titleHeight - 20

    love.graphics.setColor(0.5, 0.5, 0.5, 0.9)
    love.graphics.rectangle('fill', titleX, titleY, titleWidth, titleHeight, 6)
    
    love.graphics.setFont(gFonts.medium)
    printWithShadow('Mario', 0, titleY + 5, VIRTUAL_WIDTH, 'center')
end

function TitleScreenState:renderOptions()
    local optionsWidth = VIRTUAL_WIDTH * 0.3
    local optionsHeight = VIRTUAL_HEIGHT * 0.45
    local optionsX = VIRTUAL_WIDTH / 2 - optionsWidth / 2
    local optionsY = VIRTUAL_HEIGHT / 2

    love.graphics.setColor(0.5, 0.5, 0.5, 0.9)
    love.graphics.rectangle('fill', optionsX, optionsY, optionsWidth, optionsHeight, 6)
    
    love.graphics.setFont(gFonts.small)
    self.startButton:render()
    self.quitButton:render()
end