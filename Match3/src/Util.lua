function generateQuads(tileSheet, tile_width, tile_height)
    -- slicing tileSheet evenly and storing frames in quads
    local rows = tileSheet:getHeight() / tile_height
    local columns = tileSheet:getWidth() / tile_width

    local quads = {}
    for y = 0, rows - 1 do
        for x = 0, columns - 1 do
            table.insert(quads, love.graphics.newQuad(x * tile_width, y * tile_height, tile_width, tile_height, tileSheet))
        end
    end

    return quads
end