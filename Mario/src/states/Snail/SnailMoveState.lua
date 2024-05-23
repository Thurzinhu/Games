SnailMoveState = Class{__includes = BaseState}

function SnailMoveState:init(snail)
    self.snail = snail
    self.snail.currentAnimation = Animation {
        frames = {1, 2},
        interval = 0.5
    }
    self.snail.dx = self.snail.direction == 'right' and SNAIL_MOVE_SPEED or -SNAIL_MOVE_SPEED
    self.timer = 0
    self.interval = math.random(3, 8)
end

function SnailMoveState:enter(params)
    self.player = params.player
end

function SnailMoveState:update(dt)
    self.timer = self.timer + dt
    self.snail.x = self.snail.x + self.snail.dx * dt
    
    if self.snail:resolveLeftCollision() then
        self.snail.dx = SNAIL_MOVE_SPEED
        self.snail.direction = 'right'
    elseif self.snail:resolveRightCollision() then
        self.snail.dx = -SNAIL_MOVE_SPEED
        self.snail.direction = 'left'
    elseif not self.snail:checkBlockAhead() then
        self.snail.dx = -self.snail.dx
        self.snail.direction = self.snail.direction == 'right' and 'left' or 'right'
    end
    
    local snailPlayerBlocksDistance = math.abs(self.player.x - self.snail.x) / TILE_SIZE
    if snailPlayerBlocksDistance < 5 then
        self.snail:changeState('chase', {
            player = self.player
        })
    elseif self:shouldChangeToIdleState() then
        self.snail:changeState('idle', {
            player = self.player
        })
    end
end

function SnailMoveState:shouldChangeToIdleState()
    if self.timer >= self.interval then
        self.timer = self.timer % self.interval
        return math.random(5) == 1
    end
    return false
end