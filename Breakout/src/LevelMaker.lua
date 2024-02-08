LevelMaker = Class{}

local switch_color = false
local gaps_between_bricks = false
local MAX_SKINS = 5

function LevelMaker.createMap(level)
    local bricks = {}
    local rows = math.random(5)
    local cols = math.random(7, 13)
    cols = cols % 2 == 0 and cols + 1 or cols

    local brick_width = 32
    local brick_height = 16
    local horizontal_distance = 0
    local vertical_distance = 0
    local stating_x = (VIRTUAL_WIDTH - (cols * brick_width)) / 2
    local starting_y = 16
    local highest_tier = math.min(4, (level / 3) + 1)
    local highest_color = math.min(5, (level / 3) + 2)

    for i = 0, rows - 1 do
        switch_color = math.random(2) == 1 and true or false
        local color = {}
        if switch_color then
            color = {
                math.random(highest_color),
                math.random(highest_color)
            }
        else
            color = {
                math.random(5)
            }
        end

        gaps_between_bricks = math.random(2) == 1 and true or false

        for j = 0, cols - 1 do
            if gaps_between_bricks then
                if (i % 2 == 0 and j % 2 ~= 0) or (i % 2 ~= 0 and j % 2 == 0) then
                    table.insert(bricks, Brick(
                        (brick_width + horizontal_distance) * j + stating_x,
                        (brick_height + vertical_distance) * i + starting_y,
                        switch_color and color[(j % #color) + 1] or color[1],
                        math.random(1, highest_tier)
                        )
                    )
                end
            else
                table.insert(bricks, Brick(
                        (brick_width + horizontal_distance) * j + stating_x,
                        (brick_height + vertical_distance) * i + starting_y,
                        switch_color and color[(j % #color) + 1] or color[1],
                        math.random(1, highest_tier)
                    )
                )
            end 
        end
    end
    
    -- locking random brick
    bricks[math.random(1, #bricks)]:lock()
    
    -- assigning key to random non locked brick
    local brickWithKey = bricks[math.random(1, #bricks)] 
    while brickWithKey.isLocked do
        brickWithKey = bricks[math.random(1, #bricks)]
    end
    brickWithKey.hasKey = true

    return bricks
end