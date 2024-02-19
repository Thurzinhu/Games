Board = Class{}

local ROWS, COLUMNS = 8, 8
local collors = 18

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.level = level
    self.highlightTrasparency = 0.2

    self:getTiles()
end

function Board:getTiles()
    self.tiles = {}

    self.highestStyle = math.min(math.floor(self.level / 2 + 1), 6)

    for y = 1, ROWS do
        -- appending new list to hold new row tiles
        table.insert(self.tiles, {})

        for x = 1, COLUMNS do
            -- inserting random tiles in each row
            table.insert(self.tiles[y], Tile(
                y, -- row
                x, -- column
                math.random(6), -- color
                math.random(self.highestStyle) -- style
                )
            )
        end
    end

    if self:checkMatch() or not self:availableMatches() then
        self:getTiles(self.level)
    end
end

function Board:update(dt)

end

function Board:render()
    for row = 1, ROWS do
        for column = 1, COLUMNS do
            local currentTile = self.tiles[row][column]

            -- printing tiles with an offset so they fit in board boundaries
            currentTile:render(self.x, self.y)

            -- highlighting tile 
            if currentTile.isHighlightedForHint then
                Timer.tween(0.5, {
                    [self] = {highlightTrasparency = 0.8}
                    })
                :finish(function () 
                    Timer.tween(0.5, {
                        [self] = {highlightTrasparency = 0}
                    })
                    :finish(function()
                        currentTile.isHighlightedForHint = false
                    end)
                end)

                love.graphics.setColor(1, 1, 1, self.highlightTrasparency)
                love.graphics.rectangle('fill', currentTile.x + self.x, currentTile.y + self.y, TILE_WIDTH, TILE_HEIGHT, 4)
                
                -- reseting color and transparency
                love.graphics.setColor(1, 1, 1, 1)
            end

        end
    end
end 

function Board:checkValidSwap(tiles)
    --[[
        In order for the swap to be valid, both tiles should be at the same row in surrounding COLUMNS
        or in the same column in surrounding ROWS.
        
        - First case (tiles in the same row and adjacent columns):
        If we subtract one tile's row from the other's, we would get 0 as they are the same.
        As the tiles should be adjacent, the absolute value of the difference between the two tiles' columns would be 1.
        
        - Second case (tiles in the same column and adjacent rows):
        This is the same case as above, but instead of the row difference being zero, it would be 1, and the column difference
        would be 0.
        
        - Conclusion:
            If we calculate math.abs(tile1.row - tile2.row) + math.abs(tile1.column - tile2.column) and it equals 1, the swap 
            operation is valid. 
            As we are adding two positive numbers and the result equals one, one of them is 0 (tiles in the same row or column)
            and the other one is 1 (tiles in adjacent rows or columns).
    ]]
    local firstTile, secondTile = tiles[1], tiles[2]
    if math.abs(firstTile.row - secondTile.row) + math.abs(firstTile.column - secondTile.column) == 1 then
        -- swaping tiles in board and tweening their y position
        self:swapTiles(tiles)

        return true
    end

    return false
end

function Board:swapTiles(tiles)
    local firstTile, secondTile = tiles[1], tiles[2]

    self.tiles[firstTile.row][firstTile.column] = secondTile
    self.tiles[secondTile.row][secondTile.column] = firstTile

    -- Temporarily store the values of first tile
    local temp = {
        row = firstTile.row, 
        column = firstTile.column
    }
    -- Set the values of first tile to the values of the second tile
    firstTile.row, firstTile.column = secondTile.row, secondTile.column
    
    -- Set the values of the second tile to the temporarily stored values
    secondTile.row, secondTile.column = temp.row, temp.column
end

function Board:checkMatch(isCheckingPossibleMove)
    local matches = {}

    -- checking for matches in the rows
    for row = 1, ROWS do
        for column = 2, COLUMNS do
            --[[
                While current tile is the same as the previous one we increment our column until we
                reach the last column or tile changes
            ]]
            local initialColumn = column - 1
            while column <= COLUMNS and self.tiles[row][column - 1].color == self.tiles[row][column].color do
                column = column + 1
            end
            
            --[[
                Checking whether theres a sequence of three or more blocks in a row
                if so add a match to matches
            ]]
            local tilesInMatch = column - initialColumn
            if tilesInMatch >= 3 then

                if tilesInMatch >= 4 and not isCheckingPossibleMove then
                    self.tiles[row][initialColumn].hasSpecialEffect = true
                    initialColumn = initialColumn + 1
                end

                local match = {}
                for i = initialColumn, column - 1 do
                    table.insert(match, self.tiles[row][i])
                end
                
                table.insert(matches, match)
            end
        end
    end

    -- checking for matches in the columns
    for column = 1, COLUMNS do
        for row = 2, ROWS do
            --[[
                Same ideia as before but now checking the columns
            ]]
            local initialRow = row - 1
            while row <= ROWS and self.tiles[row - 1][column].color == self.tiles[row][column].color do
                row = row + 1
            end

            local tilesInMatch = row - initialRow
            if tilesInMatch >= 3 then

                if tilesInMatch >= 4 and not isCheckingPossibleMove then
                    self.tiles[initialRow][column].hasSpecialEffect = true
                    initialRow = initialRow + 1
                end

                local match = {}
                for i = initialRow, row - 1 do
                    table.insert(match, self.tiles[i][column])
                end

                table.insert(matches, match)
            end
        end
    end

    self.matches = matches

    -- returns true if at least one match was found
    return #self.matches > 0
end

-- adds new tiles to board and gets points earned
-- as well as a time bonus for each match
function Board:resolveMatches(params)
    gSounds.pop:stop()
    gSounds.pop:play()
    
    self:removeMatches(params)
    self:shiftTilesDown()
    self:replaceTiles(params)

    return params.score, params.timeBonus
end

function Board:removeMatches(params)
    for _, match in pairs(self.matches) do
        params.timeBonus = params.timeBonus + #match

        for _, tile in pairs(match) do
            params.score = params.score + (tile.color * 10) + (tile.style * 25)

            -- if tile is a special tile execute his special effect
            if tile.hasSpecialEffect then
                tile:performAction({
                    score = params.score,
                    board = self
                })
            end

            -- creating space in board
            self.tiles[tile.row][tile.column] = nil
        end
    end
    
    self.matches = {}
    
    return score, timeBonus
end

function Board:shiftTilesDown()
    self.tilesToFall = {}

    for column = 1, COLUMNS do
        for row = ROWS, 1, -1 do    
            -- space found
            if self.tiles[row][column] == nil then

                -- shift next tile down to fill space
                local tileAbove = nil
                for aboveRow = row - 1, 1, -1 do
                    if self.tiles[aboveRow][column] then
                        tileAbove = self.tiles[aboveRow][column]
                        
                        -- space gets tileAbove
                        self.tiles[row][column] = tileAbove
                        tileAbove.row = row
                                
                        -- creating new space at tileAbove position
                        self.tiles[aboveRow][column] = nil
                        
                        -- shifting block down
                        self.tilesToFall[tileAbove] = {y = (row - 1) * TILE_HEIGHT}

                        break
                    end
                end

                -- if no tiles above go to next column
                if tileAbove == nil then
                    break
                end
            end 
        end
    end
end

function Board:replaceTiles(params)
    for column = 1, COLUMNS do
        for row = 1, ROWS do
            if self.tiles[row][column] == nil then
                local newTile = Tile(
                0, -- creating tile out of the screen
                column,
                math.random(6), -- color
                math.random(self.highestStyle) -- style
                )

                self.tiles[row][column] = newTile
                newTile.row = row

                self.tilesToFall[newTile] = {y = (row - 1) * TILE_HEIGHT}
            end
        end
    end

    Timer.tween(0.25, self.tilesToFall)
    :finish(function()
        -- if new matches are made as a result of the tiles that have fallen down resolveMatches again
        if self:checkMatch() then
            self:resolveMatches(params)
        elseif not self:availableMatches() then
            Timer.after(2, function()
                self:reset()
            end)
        end
    end)

    -- reseting tiles to fall table after all tiles have fallen
    self.tilesToFall = {}
end

-- checks wheter current board has possible matches and if so return them
-- else resets the board
function Board:availableMatches()
    self.possibleMatches = {}
    for row = 1, ROWS do
        for column = 1, COLUMNS do
            local currentTile = self.tiles[row][column]

            if column - 1 > 0 then
                self:checkSwap({currentTile, self.tiles[row][column - 1]})
            end
            
            if column + 1 <= COLUMNS then
                self:checkSwap({currentTile, self.tiles[row][column + 1]})
            end
            
            if row - 1 > 0 then
                self:checkSwap({currentTile, self.tiles[row - 1][column]})
            end
            
            if row + 1 <= ROWS then
                self:checkSwap({currentTile, self.tiles[row + 1][column]})
            end
        end
    end

    return next(self.possibleMatches)
end

function Board:checkSwap(tiles)
    -- swaping tiles in board without tweening them
    self:swapTiles(tiles)

    if self:checkMatch(true) then
        for _, match in pairs(self.matches) do
            table.insert(self.possibleMatches, match)
        end

        self.matches = {}
    end

    -- undoing swap in board
    self:swapTiles(tiles)
end

function Board:reset()
    for row = 1, ROWS do
        for column = 1, COLUMNS do
            self.tiles[row][column] = nil
        end
    end

    self:getTiles(self.level)
end

function Board:getHint()
    local randomMatch = math.random(#self.possibleMatches)
    local currentMatch = 1

    for _, match in pairs(self.possibleMatches) do
        if currentMatch == randomMatch then
            for _, tile in pairs(match) do
                tile.isHighlightedForHint = true
            end

            break
        end

        currentMatch = currentMatch + 1
    end
end