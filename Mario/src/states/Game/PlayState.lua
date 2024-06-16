PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.levelMaker = params.levelMaker or LevelMaker(100, 20)
    self.level = params.level or self.levelMaker:createMap()
    self.player = params.player or Player {
        x = 0, 
        y = 0,
        width = PLAYER_WIDTH,
        height = PLAYER_HEIGHT,
        texture = gTextures['playerSheet'],
        frame = gFrames['player'],
        stateMachine = StateMachine {
            ['move'] = function() return PlayerMoveState(self.player) end,
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player) end,
            ['fall'] = function() return PlayerFallState(self.player) end,
            ['death'] = function() return PlayerDeathState(self.player) end
        },
        tileMap = self.level.tileMap,
        level = self.level,
        score = params.score or 0
    }
    if not params.player then
        self.player:changeState('fall')
    end
    if not params.level then
        self.levelMaker:spawnEntities(self.player)
    end
    self.camera = params.camera or Camera {
        tracked = self.player,
        tileMap = self.level.tileMap
    }
end

function PlayState:update(dt)
    self.player:update(dt)
    self.camera:update(dt)
    self.level:update(dt)

    for _, consumable in pairs(self.player:getConsumableGameObjects()) do
       consumable:onConsume(self.player) 
    end

    if self.player.hasReachedGoal then
        gStateMachine:change('play', {
            score = self.player.score
        })
    elseif love.keyboard.wasPressed('p') then
        gStateMachine:change('pause', {
            levelMaker = self.levelMaker,
            level = self.level,
            player = self.player,
            camera = self.camera
        })
    elseif not self.player.isInGame then
        gStateMachine:change('gameOver', {
            level = self.level,
            player = self.player,
            camera = self.camera
        })
    end
end

function PlayState:render()
    love.graphics.clear(1, 1, 1, 1)
    self:printScore()
    self.camera:track()
    self.level:render()
    self.player:render()
    self.camera:stopTracking()
    if self.player.hasKey then
        love.graphics.draw(gTextures['keysLocks'], gFrames['keys'][1], 2, 0)
    end
end