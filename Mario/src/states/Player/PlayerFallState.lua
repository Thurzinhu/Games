PlayerFallState = Class{__includes = BaseState}

local GRAVITY = 7

function PlayerFallState:init(player)
    self.player = player

    self.player.currentAnimation = Animation {
        frames = {3},
        interval = 1
    }
end

function PlayerFallState:update(dt)
    if love.keyboard.isDown('right') then
        self.player.dx = PLAYER_MOVE_SPEED
        self.player.direction = 'right'
    elseif love.keyboard.isDown('left') then
        self.player.dx = -PLAYER_MOVE_SPEED
        self.player.direction = 'left'
    else
        self.player.dx = 0
    end

    self.player.y = self.player.y + self.player.dy * dt
    self.player.dy = self.player.dy + GRAVITY
    self.player.x = self.player.x + self.player.dx * dt
    
    if self.player:checkBottomCollision() then
        self.player.y = 6 * TILE_SIZE - PLAYER_HEIGHT
        self.player:changeState('idle')
    end
end