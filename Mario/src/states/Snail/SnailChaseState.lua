SnailChaseState = Class{__includes = BaseState}

function SnailChaseState:init(snail)
    self.snail = snail

    self.snail.currentAnimation = Animation {
        frames = {1, 2},
        interval = 0.2
    }
    self.timer = 0
    self.interval = math.random(3, 8)
end

function SnailChaseState:enter(params)
    self.player = params.player
end

function SnailChaseState:update(dt)
    self.snail.x = self.snail.x + self.snail.dx * dt
    local snailPlayerBlocksDistance = math.abs(self.player.x - self.snail.x) / TILE_SIZE
    if snailPlayerBlocksDistance > 5 then
        if self:shouldChangeToMoveState() then
            self.snail:changeState('move', {
                player = self.player 
            })
        else
            self.snail:changeState('idle', {
                player = self.player 
            })
        end
    elseif self.player.x < self.snail.x then
        self.snail.dx = -SNAIL_CHASE_SPEED
        self.snail.direction = 'left'
        self.snail:resolveLeftCollision()
    else
        self.snail.dx = SNAIL_CHASE_SPEED
        self.snail.direction = 'right'
        self.snail:resolveRightCollision()
    end

    if not self.snail:checkBlockAhead() then
        self.snail.dx = 0
    end
end

function SnailChaseState:shouldChangeToMoveState()
    if self.timer >= self.interval then
        self.timer = self.timer % self.interval
        return math.random(5) == 1
    end
    return false
end