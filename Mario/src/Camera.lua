Camera = Class{}

function Camera:init(def)
    self.x = def.x or 0
    self.y = def.y or 0
    self.dx = 0
    self.dy = 0
    self.tracked = def.tracked
    self.tileMap = def.tileMap
end

function Camera:update(dt)
    self.x = self.tracked.x - VIRTUAL_WIDTH / 2 + self.tracked.width / 2
    --self.y = self.tracked.y - VIRTUAL_HEIGHT / 2 + self.tracked.height / 2

    self.x = math.max(self.x, 0)
    self.x = math.min(self.x, self.tileMap.width * TILE_SIZE - VIRTUAL_WIDTH)
    --self.y = math.min(self.y, 0)
end

function Camera:track()
    love.graphics.translate(math.floor(-self.x), math.floor(-self.y))
end