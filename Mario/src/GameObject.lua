GameObject = Class{}

function GameObject:init(def)
    Entity.init(self, def)
    self.isCollidable = def.isCollidable
    self.isConsumable = def.isConsumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.wasHit = def.wasHit
end

function GameObject:update(dt)

end

function GameObject:render()
    love.graphics.draw(self.texture, self.frame, self.x, self.y)
end