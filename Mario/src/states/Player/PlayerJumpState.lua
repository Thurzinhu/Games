PlayerJumpState = Class{__includes = BaseState}

local GRAVITY = 7
local JUMPING_SPEED = -250

function PlayerJumpState:init(player)
    self.player = player

    self.player.currentAnimation = Animation {
        frames = {3},
        interval = 1
    }

    self.player.dy = JUMPING_SPEED
end

function PlayerJumpState:update(dt)
    self.player.x = self.player.x + self.player.dx * dt
    self.player.y = self.player.y + self.player.dy * dt
    self.player.dy = self.player.dy + GRAVITY
        
    if love.keyboard.isDown('right') then
        self.player.dx = PLAYER_MOVE_SPEED
        self.player.direction = 'right'
        self.player:resolveRightCollision()
    elseif love.keyboard.isDown('left') then
        self.player.dx = -PLAYER_MOVE_SPEED
        self.player.direction = 'left'
        self.player:resolveLeftCollision()
    else
        self.player.dx = 0
    end
    
    if self.player.dy >= 0 then
        self.player:changeState('fall')
    end
end