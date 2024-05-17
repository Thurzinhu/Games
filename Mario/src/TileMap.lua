TileMap = Class{}

function TileMap:init(def)
    self.width = def.width
    self.height = def.height
    self.tiles = def.tiles or {}
end

function TileMap:update(dt)

end

function TileMap:render()
    for i, rows in pairs(self.tiles) do
        for j, tile in pairs(rows) do
            tile:render()
        end
    end
end