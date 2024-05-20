Tile = Class{}

function Tile:init(def)
    self.gridX = def.gridX
    self.gridY = def.gridY
    self.width = def.width
    self.height = def.height
    self.id = def.id
    self.tileSet = def.tileSet or 1
    self.topSet = def.topSet or 1
    self.hasToping = def.hasToping or false
end

function Tile:update(dt)

end

function Tile:collidable()
    return self.id == GROUND
end

function Tile:render()
    love.graphics.draw(
        gTextures['tileSheet'], 
        gFrames['tiles'][self.tileSet][self.id],
        (self.gridX - 1)*self.width,
        (self.gridY - 1)*self.height
    )

    if self.hasToping then
        love.graphics.draw(
            gTextures['tileTopSheet'],
            gFrames['tileTops'][self.topSet][1],
            (self.gridX - 1)*self.width,
            (self.gridY - 1)*self.height
        )
    end
end