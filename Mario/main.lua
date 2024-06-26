require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Mario Bros')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        vsync = true,
        fullscreen = false
    })
    math.randomseed(os.time())
    gStateMachine:change('title')
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end

function printWithShadow(text, x, y, limit, allign, highlightColor)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(text, x, y + 2, limit, allign)
    if highlightColor then
        love.graphics.setColor(highlightColor)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.printf(text, x, y, limit, allign)
end