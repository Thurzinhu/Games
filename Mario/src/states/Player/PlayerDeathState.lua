PlayerDeathState = Class{__includes = BaseState}

function PlayerDeathState:init(player)
    self.player = player
    self.player.currentAnimation = Animation {
        frames = {5},
        interval = 1
    }
    self.player.isInGame = false
    print('dead')
    if self.player:checkFallOutOfMap() then
        self.player.y = VIRTUAL_HEIGHT - self.player.height
    end
end

function PlayerDeathState.playDeathAnimation(player)
    return Timer.tween(0.75, {
        [player] = {y = player.y - player.height - TILE_SIZE}
    }
    ):finish(function()
            Timer.tween(0.5, {
                [player] = {y = VIRTUAL_HEIGHT + player.height}
            }
        )
    end)
end