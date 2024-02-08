Collision = Class{}

function Collision.checkRectanglesOverlap(a, b)
    local overlap = not(
        (a.x + a.width < b.x) or (b.x + b.width < a.x) or 
        (a.y > b.y + b.height) or (b.y > a.y + a.height)
    )

    local shift_b_x, shift_b_y = 0, 0
    --[[
        if rectangles overlap we must consider four cases
        - B collided with A's right side, so we should
        push B to the right
        - B collided with A's left side, so we should
        push B to the left
        - B collided with A's lower area, so we should
        push B down
        - B collided with A's upper area, so we should
        push B up
    ]]
    if overlap then
        -- X axis 
        if (b.x + b.width > a.x + a.width / 2) then
            shift_b_x = a.x + a.width - b.x
        else
            shift_b_x = -(b.x + b.width - a.x)
        end

        -- Y axis
        if (b.y > a.y + a.height / 2) then
            shift_b_y = a.y + a.height - b.y
        else
            shift_b_y = -(b.y + b.height - a.y)
        end 
    end

    return overlap, shift_b_x, shift_b_y
end

function Collision.ballPaddleCollision(ball, paddle)
    local overlap, shift_ball_x, shift_ball_y = Collision.checkRectanglesOverlap(paddle, ball)
    
    if overlap then
        gSounds['paddle-hit']:play()

        ball.dy = -ball.dy
        ball.y = paddle.y - ball.height
        
        --[[
            if ball hits left part of paddle and paddle is moving left 
            we scale ball.dx based on balls distance to paddle center
        ]]
        if shift_ball_x < 0 and paddle.dx < 0 then
            ball.dx = -50 + -(8 * (paddle.x + paddle.width / 2 - ball.x))

        --[[
            if ball hits right part of paddle and paddle is moving right 
            we scale ball.dx based on balls distance to paddle center
        ]]
        elseif shift_ball_x > 0 and paddle.dx > 0 then
            ball.dx = 50 + (8 * math.abs(paddle.x + paddle.width / 2 - ball.x))
        
        --[[
            if ball hits paddle and paddle is not moving simply rebound
            the ball to the other direction
        ]]
        end
    end
end

function Collision.ballBrickCollision(ball, brick)
    local overlap, shift_ball_x, shift_ball_y = Collision.checkRectanglesOverlap(brick, ball)
    
    if overlap then
        gSounds['brick-hit']:play()

        local min_shift = math.min(math.abs(shift_ball_x), math.abs(shift_ball_y))

        if math.abs(shift_ball_x) == min_shift then
            ball.x = ball.x + shift_ball_x
            ball.dx = -ball.dx
        else
            ball.y = ball.y + shift_ball_y
            ball.dy = -ball.dy
        end
    end

    return overlap
end

function Collision.ballWallsCollision(ball)
    if ball.x <= 0 then
        gSounds['wall-hit']:play()
        
        ball.dx = -ball.dx
        ball.x = 0
    elseif ball.x + ball.width >= VIRTUAL_WIDTH then
        gSounds['wall-hit']:play()
        
        ball.dx = -ball.dx
        ball.x = VIRTUAL_WIDTH - ball.width
    elseif ball.y <= 0 then
        gSounds['wall-hit']:play()
        
        ball.dy = -ball.dy
        ball.y = 0
    end
end

function Collision.paddlePowerUpCollision(paddle, powerUp)
    local overlap, shift_b_x, shift_b_y = Collision.checkRectanglesOverlap(paddle, powerUp)

    if overlap then
        gSounds['power-up']:play()

        powerUp.inPlay = false
    end

    return overlap
end

function Collision.paddleWallsCollision(paddle)
    if paddle.dx < 0 then
        paddle.x = math.max(0, paddle.x)
    else
        paddle.x = math.min(VIRTUAL_WIDTH - paddle.width, paddle.x)
    end
end