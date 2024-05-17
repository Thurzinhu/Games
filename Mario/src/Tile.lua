Tile = Class{}

function Tile:init(def)
    self.GridX = def.GridX
    self.GridY = def.GridY
    self.width = def.width
    self.height = def.height
    self.id = def.id
    self.tileSet = def.tileSet or 1
    self.topSet = def.topSet or 1
    self.hasToping = def.hasToping or false
end

function Tile:update(dt)

end

function Tile:render()
    love.graphics.draw(
        gTextures['tileSheet'], 
        gFrames['tiles'][self.tileSet][self.id],
        (self.GridX - 1)*self.width,
        (self.GridY - 1)*self.height
    )

    if self.hasToping then
        love.graphics.draw(
            gTextures['tileTopSheet'],
            gFrames['tileTops'][self.topSet][1],
            (self.GridX - 1)*self.width,
            (self.GridY - 1)*self.height
        )
    end
end