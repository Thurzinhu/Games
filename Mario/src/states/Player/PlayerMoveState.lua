PlayerMoveState = Class{__includes = BaseState}

function PlayerMoveState:init(player)
    self.player = player
    self.player.currentAnimation = Animation {
        frames = {10, 11},
        interval = 0.2
    }
end

function PlayerMoveState:update(dt)    
    self.player.x = self.player.x + self.player.dx * dt

    if not self.player:checkBottomCollision() then
        self.player:changeState('fall')
    else
        self.player:resolveBottomCollision()
        if love.keyboard.wasPressed('space') then
            self.player:changeState('jump')
        elseif love.keyboard.isDown('right') then
            self.player.dx = PLAYER_MOVE_SPEED
            self.player.direction = 'right'
            self.player:resolveRightCollision()
        elseif love.keyboard.isDown('left') then
            self.player.dx = -PLAYER_MOVE_SPEED
            self.player.direction = 'left'
            self.player:resolveLeftCollision()
        else
            self.player.dx = 0
            self.player:changeState('idle')
        end
    end

    if self.player:checkEntityCollision() then
        self.player:changeState('death')
    end
end