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

function generateTiles(quads)
    local rows, columns = 8, 8
    local total_tiles = 108

    -- for each tile color we have six different styles
    local styles = 6

    local tiles = {}

    for i = 1, total_tiles, styles do
        table.insert(tiles, table.slice(quads, i, i + 5))
    end

    return tiles
end

function table.slice(tbl, from, to, step)
    local slice = {}
    for i = from or 1, to or #tbl, step or 1 do
        table.insert(slice, tbl[i])
    end

    return slice
end