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
    
    -- each tile has a hint rectangle in case they could make a match
    self.hintRectangleTransparency = 0
    
    -- tiles with special effects can perform different action on board
    self.hasSpecialEffect = false
end

function Tile:update()

end

function Tile:render(x, y)
    love.graphics.draw(gTextures.main, gFrames['tiles'][self.color][self.style], self.x + x, self.y + y)
    
    if self.hasSpecialEffect then
        love.graphics.draw(gTextures.star, self.x + x + 8, self.y + y + 8)
    end

    if self.isSelected then
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.rectangle('fill', self.x + x, self.y + y, TILE_WIDTH, TILE_HEIGHT, 4)
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    love.graphics.setColor(1, 1, 1, self.hintRectangleTransparency)
    love.graphics.rectangle('fill', self.x + x, self.y + y, TILE_WIDTH, TILE_HEIGHT, 4)
    love.graphics.setColor(1, 1, 1, 1)
end

function Tile:swap(other)
    return Timer.tween(0.1, {
        [self] = {x = other.x, y = other.y},
        [other] = {x = self.x, y = self.y}
    })
end

function Tile:performAction(params)
    -- 50% chance to eliminate row and other 50% to eliminate a column
    local eliminateRow = (math.random(2) == 1)

    if eliminateRow then
        local row = self.row

        for i = 8, 1, -1 do
            local tile = params.board.tiles[row][i]
            if tile then
                params.score = params.score + (tile.color * 10) + (tile.style * 25)

                params.board.tiles[row][i] = nil
            end
        end
    else 
        local column = self.column

        for i = 8, 1, -1 do
            local tile = params.board.tiles[i][column]
            if tile then
                params.score = params.score + (tile.color * 10) + (tile.style * 25)

                params.board.tiles[i][column] = nil
            end
        end
    end
end