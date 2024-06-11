PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    self.levelMaker = params.levelMaker
    self.level = params.level
    self.player = params.player
    self.camera = params.camera
    self.score = params.score
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', {
            levelMaker = self.levelMaker,
            level = self.level,
            player = self.player,
            camera = self.camera,
            score = self.score
        })
    end
end

function PauseState:render()
    love.graphics.clear(1, 1, 1, 1)
    self.camera:track()
    self.level:render()
    self.player:render()
    self.camera:stopTracking()
    self:renderDarkBackground()
end

function PauseState:renderDarkBackground()
    love.graphics.setColor(0, 0, 0, 0.95)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
end