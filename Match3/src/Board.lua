Board = Class{}

local ROWS, COLUMNS = 8, 8
local collors = 18

function Board:init(x, y, level)
    self.x = x
    self.y = y
    
    self:getTiles(level)
end

function Board:getTiles(level)
    self.tiles = {}

    self.highestStyle = math.floor(level / 2 + 1)

    for y = 1, ROWS do
        -- appending new list to hold new row tiles
        table.insert(self.tiles, {})

        for x = 1, COLUMNS do
            -- inserting random tiles in each row
            table.insert(self.tiles[y], Tile(
                y, -- row
                x, -- column
                math.random(collors), -- color
                math.random(self.highestStyle) -- style
                )
            )
        end
    end

    if self:checkMatch() then
        self:getTiles()
    end
end

function Board:update(dt)

end

function Board:render()
    for row = 1, ROWS do
        for column = 1, COLUMNS do
            -- printing tiles with an offset so they fit in board boundaries
            self.tiles[row][column]:render(self.x, self.y)
        end
    end
end 

function Board:checkValidSwap(tiles)
    local firstTile, secondTile = tiles[1], tiles[2]
    --[[
        In order for the swap to be valid both tiles should be at the same row in surrounding COLUMNS
        or in the same column in surrounding ROWS
    ]]
    if (firstTile.row == secondTile.row and math.abs(firstTile.column - secondTile.column) == 1) or
        (firstTile.column == secondTile.column and math.abs(firstTile.row - secondTile.row) == 1) then   
            firstTile:swap(secondTile)
            
            -- swaping tiles in board
            self.tiles[firstTile.row][firstTile.column] = firstTile
            self.tiles[secondTile.row][secondTile.column] = secondTile
    end
end

function Board:checkMatch()
    local matches = {}

    -- checking for matches in the rows
    for row = 1, ROWS do
        for column = 2, COLUMNS do
            local initialColumn = column - 1
            while column <= COLUMNS and self.tiles[row][column - 1].color == self.tiles[row][column].color do
                column = column + 1
            end
            
            if column - initialColumn >= 3 then
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
            local initialRow = row - 1
            while row <= ROWS and self.tiles[row - 1][column].color == self.tiles[row][column].color do
                row = row + 1
            end

            if row - initialRow >= 3 then
                local match = {}
                for i = initialRow, row - 1 do
                    table.insert(match, self.tiles[i][column])
                end

                table.insert(matches, match)
            end
        end
    end

    self.matches = matches

    return #self.matches > 0
end

-- adds new tiles to board and returns points earned
function Board:resolveMatches()
    local score = 0

    self:removeMatches()
    self:shiftTilesDown()
    self:replaceTiles()

    return score
end

function Board:removeMatches()
    for _, match in pairs(self.matches) do
        for _, tile in pairs(match) do
            -- score = score + (tile.color * 10) + (tile.style * 25)

            -- creating space in board
            self.tiles[tile.row][tile.column] = nil
        end
    end

    self.matches = {}
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
                                
                        -- creating new space
                        self.tiles[aboveRow][column] = nil
                        
                        tileAbove.row = row
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

function Board:replaceTiles()
    for column = 1, COLUMNS do
        for row = 1, ROWS do
            if self.tiles[row][column] == nil then
                local newTile = Tile(
                0,
                column,
                math.random(collors), -- color
                math.random(self.highestStyle) -- style
                )

                self.tiles[row][column] = newTile
                newTile.row = row

                self.tilesToFall[newTile] = {y = (row - 1) * TILE_HEIGHT}
            end
        end
    end

    Timer.tween(0.25, self.tilesToFall):finish(
        function()
            if self:checkMatch() then
                self:resolveMatches()
            end
        end
    )

    self.tilesToFall = {}
end