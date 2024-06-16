PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player
    self.player.currentAnimation = Animation {
        frames = {1},
        interval = 1
    }
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('right') or love.keyboard.isDown('left') then
        self.player:changeState('move') 
    elseif love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

    if self.player:checkEntityCollision() then
        self.player:changeState('death')
    end
end