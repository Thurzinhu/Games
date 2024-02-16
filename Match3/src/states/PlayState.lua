PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.board = params.board
    self.score = params.score or 0

    -- upper left tile selected
    self.currentTile = {
        row = 1,
        column = 1,
    }

    self.selectedTiles = {}
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('title')
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        local tile_selected = self.board.tiles[self.currentTile.row][self.currentTile.column]

        tile_selected.isSelected = true

        table.insert(self.selectedTiles, tile_selected)

        if #self.selectedTiles == 2 then
            self.board:checkValidSwap(self.selectedTiles)

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

    Timer.update(dt)
end

function PlayState:render()
    -- drawing border in selected tile
    local current_tile = self.board.tiles[self.currentTile.row][self.currentTile.column]

    self.board:render()
    love.graphics.setLineWidth(4)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('line', current_tile.x + self.board.x, current_tile.y + self.board.y, TILE_WIDTH, TILE_HEIGHT, 4)
    love.graphics.setColor(1, 1, 1, 1)
end