GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.returnTitleButton = Button({
        x = VIRTUAL_WIDTH / 2 - 60,
        y = VIRTUAL_HEIGHT / 2,
        text = "Title Screen",
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
end

function GameOverState:enter(params)
    self.level = params.level
    self.player = params.player
    self.camera = params.camera
    PlayerDeathState.playDeathAnimation(self.player)
end

function GameOverState:update(dt)
    self.returnTitleButton:update(dt)
    self.quitButton:update(dt)
    if self.returnTitleButton:wasPressed() or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('title')
    elseif self.quitButton:wasPressed() then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.clear(1, 1, 1, 1)
    self.camera:track()
    self.level:render()
    self.player:render()
    self.camera:stopTracking()
    self:renderTitle()
    self:renderOptions()
end

function GameOverState:renderTitle()
    local titleWidth = VIRTUAL_WIDTH * 0.7
    local titleHeight = VIRTUAL_HEIGHT * 0.3
    local titleX = VIRTUAL_WIDTH / 2 - titleWidth / 2
    local titleY = VIRTUAL_HEIGHT / 2 - titleHeight - 20

    love.graphics.setColor(0.5, 0.5, 0.5, 0.9)
    love.graphics.rectangle('fill', titleX, titleY, titleWidth, titleHeight, 6)
    
    love.graphics.setFont(gFonts.medium)
    printWithShadow('Game Over', 0, titleY + 5, VIRTUAL_WIDTH, 'center')
end

function GameOverState:renderOptions()
    local optionsWidth = VIRTUAL_WIDTH * 0.5
    local optionsHeight = VIRTUAL_HEIGHT * 0.45
    local optionsX = VIRTUAL_WIDTH / 2 - optionsWidth / 2
    local optionsY = VIRTUAL_HEIGHT / 2

    love.graphics.setColor(0.5, 0.5, 0.5, 0.9)
    love.graphics.rectangle('fill', optionsX, optionsY, optionsWidth, optionsHeight, 6)
    
    love.graphics.setFont(gFonts.small)
    self.returnTitleButton:render()
    self.quitButton:render()
end