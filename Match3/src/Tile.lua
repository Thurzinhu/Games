Tile = Class{}

function Tile:init(x, y, skin)
    self.x = x
    self.y = y

    self.skin = skin
end

function Tile:update()

end

function Tile:render()
    love.graphics.draw(gTextures.main, gFrames['tiles'][self.skin], self.x, self.y)
end