SnailIdleState = Class{__includes = BaseState}

function SnailIdleState:init(snail)
    self.snail = snail
    self.snail.currentAnimation = Animation {
        frames = {1},
        interval = 1
    }
    self.snail.dx = 0
    self.timer = 0
    self.interval = math.random(3, 8)
end

function SnailIdleState:enter(params)
    self.player = params.player
end

function SnailIdleState:update(dt)
    local snailPlayerBlocksDistance = math.abs(self.player.x - self.snail.x) / TILE_SIZE
    self.timer = self.timer + dt

    if snailPlayerBlocksDistance < 5 then
        self.snail:changeState('chase', {
            player = self.player
        })
    elseif self:shouldChangeToMoveState() then
        self.snail:changeState('move', {
            player = self.player
        })
    end
end

function SnailIdleState:shouldChangeToMoveState()
    if self.timer >= self.interval then
        self.timer = self.timer % self.interval
        return math.random(5) == 1
    end
    return false
end