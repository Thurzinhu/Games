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

function Snail:collides(other)
    return not (
        self.x + self.width - 3 < other.x or self.x + 3 > other.x + other.width or
        self.y + self.height - 3 < other.y or self.y + 3 > other.y + other.height
    )
end

function Snail:checkBlockAhead()
    local aheadBlock
    if self.dx > 0 then
        aheadBlock = self.tileMap:coordinateToTile(self.x + self.width - 1, self.y + self.height)
    else 
        aheadBlock = self.tileMap:coordinateToTile(self.x + 1, self.y + self.height)
    end

    return (aheadBlock) and aheadBlock:collidable() 
end

function Snail:checkBlockBehind()
    local behindBlock
    if self.dx > 0 then
        behindBlock = self.tileMap:coordinateToTile(self.x - 1, self.y + self.height)
    else 
        behindBlock = self.tileMap:coordinateToTile(self.x + self.width + 1, self.y + self.height)
    end

    return (behindBlock) and behindBlock:collidable()
end