function generateQuads(atlas, tileWidth, tileHeight)
    local tiles = {}

    local horizontalTiles = atlas:getWidth() / tileWidth
    local verticalTiles = atlas:getHeight() / tileHeight

    for y = 0, verticalTiles - 1 do
        for x = 0, horizontalTiles - 1 do 
            table.insert(tiles, love.graphics.newQuad(x*tileWidth, y*tileHeight, tileWidth, tileHeight, atlas))
        end
    end

    return tiles
end

function generateSets(atlas, setsX, setsY, tileWidth, tileHeight)
    local sets = {}
    local count = 1

    local subSetsX = atlas:getWidth() / setsX / tileWidth
    local subSetsY = atlas:getHeight() / setsY / tileHeight

    for row = 1, setsY do
        for col = 1, setsX do
            table.insert(sets, {})
            
            local offsetX = (col - 1) * atlas:getWidth() / setsX
            local offsetY = (row - 1) * atlas:getHeight() / setsY

            for y = 1, subSetsY do
                for x = 1, subSetsX do
                    table.insert(
                        sets[count],
                        love.graphics.newQuad(
                            (x - 1)*tileWidth + offsetX,
                            (y - 1)*tileHeight + offsetY,
                            tileWidth,
                            tileHeight,
                            atlas
                        )
                    )
                end 
            end

            count = count + 1
        end
    end

    return sets
end