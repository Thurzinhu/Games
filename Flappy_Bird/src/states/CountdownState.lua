CountdownState = Class{__includes = BaseState}

local COUNTDOWN_TIME = 0.75

function CountdownState:enter(params)
    if params then
        self.bird = params.bird
        self.pipePairs = params.pipePairs
        self.score = params.score
    else
        self.bird = Bird()
        self.pipePairs = {}
        self.score = 0
    end
end

function CountdownState:init()
    self.timer = 0
    self.count = 3
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer >= COUNTDOWN_TIME then
        self.timer = 0
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play', {
                score = self.score,
                pipePairs = self.pipePairs,
                bird = self.bird
            })
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Get Ready', VIRTUAL_WIDTH / 2 - 50, 80, 100, 'center')
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 - 40, 100, 'center')
end