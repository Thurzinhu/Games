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
        love.graphics.rectangle('fill', self.x + x, self.y + y, TILE_WIDTH, TILE_HEIGHT, 4)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Tile:swap(other)
    return Timer.tween(0.1, {
        [self] = {x = other.x, y = other.y},
        [other] = {x = self.x, y = self.y}
    })
end