BeginGameState = Class{__includes = BaseState}

local spaceForTiles = 8 * TILE_WIDTH

function BeginGameState:init()
    self.transitionAlpha = 1
    
    self.levelBannerY = -64
    self.levelBannerWidth = VIRTUAL_WIDTH
    self.levelBannerHeight = 64
end

function BeginGameState:enter(params)
    self.level = params.level
    self.board = Board(VIRTUAL_WIDTH - spaceForTiles - 16, (VIRTUAL_HEIGHT - spaceForTiles) / 2, self.level)

    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    :finish(function()
        Timer.tween(0.25, {
            [self] = {levelBannerY = VIRTUAL_HEIGHT / 2 - 32}
        })
        :finish(function ()
            Timer.after(1, function()
                Timer.tween(0.25, {
                    [self] = {levelBannerY = VIRTUAL_HEIGHT + 20}
                })
                :finish(function()
                    gStateMachine:change('play', {
                        board = self.board,
                        level = self.level
                    })
                end)
            end)
        end)
    end)
end

function BeginGameState:update(dt)
    Timer.update(dt)
end

function BeginGameState:render()
    self.board:render()

    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.levelBannerY - 15, self.levelBannerWidth, self.levelBannerHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts.medium)
    love.graphics.printf('Level ' .. tostring(self.level), 0, self.levelBannerY, VIRTUAL_WIDTH, 'center')

    -- drawing rect for transition
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end