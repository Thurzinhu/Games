BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end

function BaseState:printScore()
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.setFont(gFonts.small)
    love.graphics.printf(tostring(self.score), 0, 0, VIRTUAL_WIDTH, 'right')
    love.graphics.setColor(1, 1, 1, 1)
end