PaddleSelectState = Class{__includes = BaseState}

local SKINS = 4

function PaddleSelectState:enter(params)
    if params then
        self.currentPaddle = params.currentPaddle or 1
        self.highScores = params.highScores
    else
        self.currentPaddle = 1
    end
end

function PaddleSelectState:init()
    self.paddleSize = 2
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gSounds['warn']:play()

        gStateMachine:change('title', {
            highScores = self.highScores 
        })
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['choose']:play()

        gStateMachine:change('serve', {
            paddle = Paddle(self.currentPaddle),
            bricks = LevelMaker.createMap(1),
            hearts = 3,
            score = 0,
            level = 1,
            highScores = self.highScores
        })
    elseif love.keyboard.wasPressed('right') then
        if self.currentPaddle == SKINS then
            gSounds['warn']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
        
    elseif love.keyboard.wasPressed('left') then
        if self.currentPaddle == 1 then
            gSounds['warn']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle - 1
        end
    end
end

function PaddleSelectState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Select Paddle With Left and Right', 0, VIRTUAL_HEIGHT / 2 - 70, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to Confirm', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')
    
    love.graphics.draw(gTextures.main, gFrames['paddles'][(self.currentPaddle - 1 ) * 4 + self.paddleSize], 
    VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT / 2 - 8)
    
    if self.currentPaddle == 1 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    love.graphics.draw(gTextures.arrows, gFrames['arrows'][1], 24, VIRTUAL_HEIGHT / 2 - 12)
    
    love.graphics.setColor(1, 1, 1, 1)
    
    if self.currentPaddle == 4 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    love.graphics.draw(gTextures.arrows, gFrames['arrows'][2], VIRTUAL_WIDTH - 48, VIRTUAL_HEIGHT / 2 - 12)
    
    love.graphics.setColor(1, 1, 1, 1)
end