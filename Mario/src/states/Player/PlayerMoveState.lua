PlayerMoveState = Class{__includes = BaseState}

function PlayerMoveState:init(player)
    self.player = player

    self.player.currentAnimation = Animation {
        frames = {10, 11},
        interval = 0.2
    }
end

function PlayerMoveState:update(dt)
    if love.keyboard.isDown('right') then
        self.player.dx = PLAYER_MOVE_SPEED
        self.player.direction = 'right'
    elseif love.keyboard.isDown('left') then
        self.player.dx = -PLAYER_MOVE_SPEED
        self.player.direction = 'left'
    else
        self.player.dx = 0
        self.player:changeState('idle')
    end
    
    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

    self.player.x = self.player.x + self.player.dx * dt
end