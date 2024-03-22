PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.board = params.board or Board(233, 16)
    self.currentBlock = params.block or nil
end

function PlayState:update(dt)
    self.board:update(dt)

    if self.currentBlock then
        self.currentBlock:update(dt)
        
        local collision, inGame = Collision.BoardBlockCollision(self.board, self.currentBlock)
        if not inGame then
            love.event.quit()
        elseif collision then 
            self.board:appendBlock(self.currentBlock)
            self.currentBlock = nil
        end
    end

    if not self.currentBlock then
        self.currentBlock = Tile(0, 0)
    end
end

function PlayState:render()
    love.graphics.clear(1, 1, 1, 1)
    
    self.board:render()
    self.currentBlock:render(self.board.x, self.board.y)
end