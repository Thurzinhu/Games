PlayerFallState = Class{__includes = BaseState}

local GRAVITY = 7

function PlayerFallState:init(player)
    self.player = player
    self.player.currentAnimation = Animation {
        frames = {3},
        interval = 1
    }
    self.player.dy = 0
    print('fall')
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
        self.player:changeState('death')
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

    for _, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            self.player:changeState('jump')
            self.player.y = self.player.y - 1
            entity.isInGame = false
            break
        end
    end
end