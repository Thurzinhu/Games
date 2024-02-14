PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.board = params.board

    -- upper left tile selected
    self.currentTile = {
        row = 1,
        column = 1,
    }

    self.tiles_selected = {}
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('title')
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        local tile_selected = self.board.tiles[self.currentTile.row][self.currentTile.column]

        tile_selected.isSelected = true

        table.insert(self.tiles_selected, tile_selected)

        if #self.tiles_selected == 2 then
            
            self.board:checkValidSwap(self.tiles_selected)

            -- reseting tiles selected
            for _, tile in pairs(self.tiles_selected) do
                tile.isSelected = false
            end
            
            self.currentTile.row, self.currentTile.column = self.tiles_selected[1].row, self.tiles_selected[1].column
            self.tiles_selected = {}
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
end

function PlayState:render()
    -- drawing border in selected tile
    local current_tile = self.board.tiles[self.currentTile.row][self.currentTile.column]

    self.board:render()
    
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('line', current_tile.x + self.board.x, current_tile.y + self.board.y, TILE_WIDTH, TILE_HEIGHT, 8, 8)
    love.graphics.setColor(1, 1, 1, 1)
end