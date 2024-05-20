Player = Class{__includes = Entity}

local PLAYER_MOVE_SPEED = 40

function Player:init(def)
    Entity.init(self, def)
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