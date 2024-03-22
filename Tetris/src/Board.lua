Board = Class{}

ROWS = 20
COLUMNS = 10

function Board:init(x, y)
    self.x = x
    self.y = y
    self.width = COLUMNS * TILE_SIZE
    self.height = ROWS * TILE_SIZE 
    self.tiles = {}

    self:setTiles()
end

function Board:setTiles()
    for y = 1, ROWS do
        self.tiles[y] = {}

        for x = 1, COLUMNS do
            self.tiles[y][x] = nil
        end
    end
end

function Board:update(dt)
    for y, row in pairs(self.tiles) do
        if #row == COLUMNS then
            print(1)
        end
    end
end

function Board:render()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    
    love.graphics.setColor(0, 0, 0, 0.3)
    for y = 0, ROWS - 1 do
        if y < ROWS - 1 then
            love.graphics.line(self.x, self.y + (y + 1) * TILE_SIZE, self.x + self.width, self.y + (y + 1) * TILE_SIZE)
        end
    end
    
    for x = 0, COLUMNS - 1 do
        if x < COLUMNS - 1 then
            love.graphics.line(self.x + (x + 1) * TILE_SIZE, self.y, self.x + (x + 1) * TILE_SIZE, self.y + self.height)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
    for _, row in pairs(self.tiles) do
        for _, tile in pairs(row) do
            tile:render(self.x, self.y)
        end
    end
    
    love.graphics.setColor(1, 1, 1, 1)
end

function Board:appendBlock(block)
    self.tiles[block.y / TILE_SIZE + 1][block.x / TILE_SIZE + 1] = block
end