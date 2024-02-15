Tile = Class{}

function Tile:init(row, column, color, style)
    -- board positions
    self.row = row
    self.column = column
    

    self.x = ((self.column - 1) * TILE_WIDTH)
    self.y = ((self.row - 1) * TILE_HEIGHT)
    
    self.color = color
    self.style = style

    self.isSelected = false
end

function Tile:update()

end

function Tile:render(x, y)
    love.graphics.draw(gTextures.main, gFrames['tiles'][self.color][self.style], self.x + x, self.y + y)
    
    if self.isSelected then
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.rectangle('fill', self.x + x, self.y + y, TILE_WIDTH, TILE_HEIGHT, TILE_WIDTH / 2 - 6, TILE_HEIGHT / 2 - 6)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Tile:swap(other)
    Timer.tween(0.1, {
        [self] = {x = other.x, y = other.y},
        [other] = {x = self.x, y = self.y}
    })

    -- Temporarily store the values of this tile
    local temp = {
        row = self.row, 
        column = self.column
    }
    -- Set the values of this tile to the values of the other tile
    self.row, self.column = other.row, other.column

    -- Set the values of the other tile to the temporarily stored values
    other.row, other.column = temp.row, temp.column
end

--[[
    Tile fall to another tile position
]]
function Tile:fall(other)
    Timer.tween(0.25, {
        [self] = {y = other.y}
    })

    self.row = other.row
end