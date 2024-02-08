PlayState = Class{__includes = BaseState}

local GROUND_HEIGHT = 38
local MIN_GAP_HEIGHT = 90
local MAX_GAP_HEIGHT = 110

function PlayState:init()
    self.timer = 0
    self.pipeSpawnTimer = math.random(2, 3)
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('pause', {
            score = self.score,
            pipePairs = self.pipePairs,
            bird = self.bird
        })
    end

    self.timer = self.timer + dt
    
    -- generating new pipe 
    if self.timer >= self.pipeSpawnTimer then
        table.insert(self.pipePairs, PipePair(math.random(MIN_GAP_HEIGHT, MAX_GAP_HEIGHT)))
        self.timer = 0
        self.pipeSpawnTimer = math.random(2, 3)
    end

    -- ensure bird doesn't go upper than top bounder
    if self.bird.y < 0 then
        self.bird.y = 0
    end
    
    -- case bird collides with ground
    if self.bird.y >= VIRTUAL_HEIGHT - GROUND_HEIGHT then
        sounds['hurt']:play()
        sounds['explosion']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end

    for i, pair in pairs(self.pipePairs) do
        for i, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['hurt']:play()
                sounds['explosion']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end

        -- if bird passes a pair of pipes that hasn't been passed yet player scores one point
        if not pair.pairScored then
            if self.bird.x > pair.x + PIPE_WIDTH then
                sounds['point']:play()

                pair.pairScored = true
                self.score = self.score + 1
            end
        end

        pair:update(dt)
    end

    -- removing pipes that went past left bounder
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end
    
    self.bird:update(dt)
end

function PlayState:render()
    for i, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

function PlayState:enter(params)
    scrolling = true

    self.score = params.score
    self.pipePairs = params.pipePairs
    self.bird = params.bird
end

function PlayState:exit()
    scrolling = false
end