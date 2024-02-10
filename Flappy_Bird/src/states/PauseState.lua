PauseState = Class{__includes = BaseState}

local pause_image = love.graphics.newImage('graphics/pause.png')

function PauseState:enter(params)
    -- pausing music sound
    love.audio.pause(sounds['music'])
    sounds['pause']:play()

    self.score = params.score
    self.pipePairs = params.pipePairs
    self.bird = params.bird
end

function PauseState:exit()
    sounds['music']:play()
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('p') then
        gStateMachine:change('countdown', {
            score = self.score,
            pipePairs = self.pipePairs,
            bird = self.bird
        })
    end
end

function PauseState:render()
    love.graphics.draw(pause_image, VIRTUAL_WIDTH / 2 - 20, VIRTUAL_HEIGHT / 2 - 20)
end