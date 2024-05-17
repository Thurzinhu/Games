PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.player.currentAnimation = Animation {
        frames = {1},
        interval = 1
    }
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('right') then
        self.player:changeState('move')
    elseif love.keyboard.isDown('left') then
        self.player:changeState('move') 
    end
    
    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end
end