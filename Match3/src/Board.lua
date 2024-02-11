Board = Class{}

local rows = 8
local columns = 8
local tile_width, tile_height = 32, 32

function Board:init(offsetX, offsetY)
    self.tiles = {}

    for y = 0, rows - 1 do
        -- appending new list to hold new row tiles
        table.insert(self.tiles, {})

        for x = 0, columns - 1 do
            -- inserting random tiles in each row
            table.insert(self.tiles[y + 1], Tile(
                (x * tile_width) + offsetX, 
                (y * tile_height) + offsetY,
                math.random(108))
            )
        end
    end
end

function Board:update(dt)

end

function Board:render()
    for y = 1, rows do
        for x = 1, columns do
            self.tiles[y][x]:render()
        end
    end
end 