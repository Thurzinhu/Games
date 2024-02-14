Board = Class{}

local rows = 8
local columns = 8
local collors = 18

function Board:init(x, y, level)
    self.x = x
    self.y = y
    
    self.tiles = {}

    self.highestStyle = math.floor(level / 2 + 1)

    for y = 1, rows do
        -- appending new list to hold new row tiles
        table.insert(self.tiles, {})

        for x = 1, columns do
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
end

function Board:update(dt)

end

function Board:render()
    for y = 1, rows do
        for x = 1, columns do
            -- printing tiles with an offset so they fit in board boundaries
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end 

function Board:checkValidSwap(tiles)
    local firstTile, secondTile = tiles[1], tiles[2]
    --[[
        In order for the swap to be valid both tiles should be at the same row in surrounding columns
        or in the same column in surrounding rows
    ]]
    if (firstTile.row == secondTile.row and math.abs(firstTile.column - secondTile.column) == 1) or
        (firstTile.column == secondTile.column and math.abs(firstTile.row - secondTile.row) == 1) then

            firstTile:swap(secondTile)
            
            -- swaping tiles in board
            self.tiles[firstTile.row][firstTile.column] = firstTile
            self.tiles[secondTile.row][secondTile.column] = secondTile
    end
end