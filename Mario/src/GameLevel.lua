GameLevel = Class{}

function GameLevel:init(def)
    self.tileMap = def.tileMap
    self.entities = def.entities
    self.objects = def.objects
end

function GameLevel:update(dt)
    for i, entity in pairs(self.entities) do
        entity:update(dt)
    end

    -- for i, object in pairs(self.objects) do
    --     object:update(dt)
    -- end
end

function GameLevel:render()
    self.tileMap:render()

    for i, entity in pairs(self.entities) do
        entity:render()
    end

    -- for i, object in pairs(self.objects) do
    --     object:render()
    -- end
end