Block = Class{}

function Block:init(type)
    self.tiles = {}
    
    local x = 0
    for i = 1, 3 do
        self.tiles[i] = Tile(x, 0)

        x = x + TILE_SIZE
    end
end

function Block:update(dt)

end

function Block:render()

end