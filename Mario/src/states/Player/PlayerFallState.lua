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
    self.player.x = self.player.x + self.player.dx * dt
    self.player.y = self.player.y + self.player.dy * dt
    self.player.dy = self.player.dy + GRAVITY
    
    if self.player:resolveBottomCollision() then
        self.player.dy = 0

        if love.keyboard.isDown('right') or love.keyboard.isDown('left') then
            self.player:changeState('move')
        else
            self.player:changeState('idle')
        end
    elseif self.player:checkFallOutOfMap() then
        love.event.quit()
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
    end
end