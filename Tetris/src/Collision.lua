Collision = Class{}

function Collision.BoardBlockCollision(board, block)
    local collision = false
    local inGame = true

    if block.x < 0 then
        block.x = 0
    elseif block.x > board.width - TILE_SIZE then
        block.x = board.width - TILE_SIZE
    end

    if block.y >= board.height - TILE_SIZE then
        collision = true
    end

    for _, row in pairs(board.tiles) do
        for _, tile in pairs(row) do
            if tile.x == block.x and tile.y == block.y then
                block.y = block.y - TILE_SIZE
                collision = true
            end
        end
    end

    if block.y < 0 then
        inGame = false
    end

    return collision, inGame
end