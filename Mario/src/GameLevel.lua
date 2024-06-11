GameLevel = Class{}

function GameLevel:init(def)
    self.tileMap = def.tileMap
    self.gameObjects = def.gameObjects
    self.entities = def.entities
end

function GameLevel:update(dt)
    self:clearEntitiesGameObjectsNotInGame()
    for i, object in pairs(self.gameObjects) do
        object:update(dt)
    end
    for i, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

function GameLevel:clearEntitiesGameObjectsNotInGame()
    for i = #self.entities, 1, -1 do
        if not self.entities[i].isInGame then
            table.remove(self.entities, i)
        end
    end
    for i = #self.gameObjects, 1, -1 do
        if not self.gameObjects[i].isInGame then
            table.remove(self.gameObjects, i)
        end
    end
end

function GameLevel:render()
    self.tileMap:render()
    for i, object in pairs(self.gameObjects) do
        object:render()
    end
    for i, entity in pairs(self.entities) do
        entity:render()
    end
end