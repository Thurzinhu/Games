PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.board = params.board
    self.score = params.score or 0
    self.level = params.level or 1
    self.timer = params.timer or 5
    self.goalScore = 2000 * self.level
    self.timeSinceLastMatch = params.timeSinceLastMatch or 0
    self.timeBonus = 0

    -- upper left tile selected
    self.currentTile = {
        row = 1,
        column = 1,
    }

    Timer.every(1, 
        function()
            self.timer = self.timer - 1
            
            if self.timer <= 5 then
                gSounds.clock:play()
            end
            
            self.timeSinceLastMatch = self.timeSinceLastMatch + 1
            
            -- every three seconds without matches give player a hint
            if self.timeSinceLastMatch % 3 == 0 then
                self.board:getHint()
            end
        end
    )

    self.selectedTiles = {}
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then 
        Timer.clear()

        gStateMachine:change('title')
    elseif love.keyboard.wasPressed('p') then
        Timer.clear()

        gStateMachine:change('pause', {
            board = self.board,
            score = self.score,
            level = self.level,
            timer = self.timer,
            goalScore = self.goalScore,
            timeSinceLastMatch = self.timeSinceLastMatch 
        })
    end
    
    -- if player gets score needed go to next level
    if self.score >= self.goalScore then   
        Timer.clear()

        gSounds.win:play()
        gStateMachine:change('begin-game', {
                level = self.level + 1
        })
    elseif self.timer == 0 then
        Timer.clear()

        gStateMachine:change('game-over')
    end
    
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') or love.mouse.wasPressed(1) then
        gSounds.select:play()

        local tileSelected = self.board.tiles[self.currentTile.row][self.currentTile.column]
        
        tileSelected.isSelected = true
        
        table.insert(self.selectedTiles, tileSelected)
        
        
        if #self.selectedTiles == 2 then
            if self.board:checkValidSwap(self.selectedTiles) then
                local firstTile, secondTile = self.selectedTiles[1], self.selectedTiles[2]
                
                -- after swaping calling checkMatch
                firstTile:swap(secondTile)
                :finish(function() 
                    if self.board:checkMatch() then
                        -- if player did a match restart timer
                        self.timeSinceLastMatch = 0

                        local newScore, newTimeBonus = self.board:resolveMatches({
                            score = self.score,
                            timeBonus = self.timeBonus
                        })

                        self.score = newScore
                        self.timeBonus = newTimeBonus

                        self.timer = self.timer + self.timeBonus

                        self.timeBonus = 0
                    else
                        -- if no match after swaping blocks undo swap
                        self.board:swapTiles({firstTile, secondTile})
            
                        firstTile:swap(secondTile)
                    end
                end)
            end

            -- reseting tiles selected
            for _, tile in pairs(self.selectedTiles) do
                tile.isSelected = false
            end
            
            self.selectedTiles = {}
        end
    end
    
    if love.keyboard.wasPressed('left') then
        self.currentTile.column = math.max(1, self.currentTile.column - 1)
    elseif love.keyboard.wasPressed('right') then
        self.currentTile.column = math.min(8, self.currentTile.column + 1)
    elseif love.keyboard.wasPressed('up') then
        self.currentTile.row = math.max(1, self.currentTile.row - 1)
    elseif love.keyboard.wasPressed('down') then
        self.currentTile.row = math.min(8, self.currentTile.row + 1)
    end

    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    
    -- translating mouse current position into its corresponding row and column in the board
    if mouseX and mouseX >= self.board.x and mouseX < self.board.x + (TILE_WIDTH * 8) and
        mouseY and mouseY >= self.board.y and mouseY < self.board.y + (TILE_HEIGHT * 8) then
            self.currentTile.column = math.floor((mouseX - self.board.x) / TILE_WIDTH) + 1
            self.currentTile.row = math.floor((mouseY - self.board.y) / TILE_HEIGHT) + 1
    end

    Timer.update(dt)
end

function PlayState:render()
    -- drawing border in selected tile
    local currentTile = self.board.tiles[self.currentTile.row][self.currentTile.column]
    
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle('fill', 40, 16, 160, 128, 4)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(gFonts.small)
    printWithShadow('Level: ' .. tostring(self.level), 45, 20, 155, 'center')
    printWithShadow('Goal Score: ' .. tostring(self.goalScore), 45, 56, 155, 'center')
    printWithShadow('Score: ' .. tostring(self.score), 45, 92, 155, 'center')
    printWithShadow('Time Left: ' .. tostring(self.timer), 45, 124, 155, 'center')
    
    self.board:render()
    love.graphics.setLineWidth(4)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('line', currentTile.x + self.board.x, currentTile.y + self.board.y, TILE_WIDTH, TILE_HEIGHT, 4)
end