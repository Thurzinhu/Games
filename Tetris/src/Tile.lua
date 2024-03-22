Tile = Class{}

TILE_SPEED = 30

function Tile:init(x, y)
    self.x = x
    self.y = y

    self.timer = 0
end

function Tile:update(dt)
    if love.keyboard.wasPressed('right') then
        self.x = self.x + TILE_SIZE
    elseif love.keyboard.wasPressed('left') then
        self.x = self.x - TILE_SIZE
    end

    if self.timer >= 0.5 or love.keyboard.wasPressed('down') then
        self.timer = self.timer % 0.5

        self.y = self.y + TILE_SIZE
    end

    self.timer = self.timer + dt
end

function Tile:render(offsetX, offsetY)
    love.graphics.draw(gTextures.tile, self.x + offsetX, self.y + offsetY)
end