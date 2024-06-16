Player = Class{__includes = Entity}

local PLAYER_MOVE_SPEED = 40

function Player:init(def)
    Entity.init(self, def)
    self.score = def.score
    self.hasKey = false
    self.hasReachedGoal = false
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:render()
   Entity.render(self) 
end

function Player:checkFallOutOfMap()
    return self.y > VIRTUAL_WIDTH
end

function Player:checkEntityCollision()
    for _, entity in pairs(self.level.entities) do
        if entity:collides(self) then
            return true
        end
    end
    return false
end