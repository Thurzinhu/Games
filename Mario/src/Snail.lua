Snail = Class{__includes = Entity}

function Snail:init(def)
    Entity.init(self, def)
end

function Snail:render()
    love.graphics.draw(
        self.texture,
        self.frame[self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + self.width / 2, math.floor(self.y) + self.height / 2, 0,
        self.direction == 'left' and 1 or -1, 1,
        self.width / 2, self.height / 2
    )
end

function Snail:checkBlockAhead()
    local aheadBlock
    if self.dx > 0 then
        aheadBlock = self.tileMap:coordinateToTile(self.x + self.width - 1, self.y + self.width)
    else 
        aheadBlock = self.tileMap:coordinateToTile(self.x + 1, self.y + self.width)
    end

    return (aheadBlock) and aheadBlock:collidable() 
end