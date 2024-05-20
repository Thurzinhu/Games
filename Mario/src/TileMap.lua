TileMap = Class{}

function TileMap:init(def)
    self.width = def.width
    self.height = def.height
    self.tiles = def.tiles or {}
end

function TileMap:update(dt)

end

function TileMap:coordinateToTile(x, y)
    if x < 0 or x > self.width * TILE_SIZE or y < 0 or y > self.height * TILE_SIZE then
        return nil
    end
    
    return self.tiles[math.floor(y / TILE_SIZE) + 1][math.floor(x / TILE_SIZE) + 1]
end

function TileMap:render()
    for i, rows in pairs(self.tiles) do
        for j, tile in pairs(rows) do
            tile:render()
        end
    end
end