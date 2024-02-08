Brick = Class{}

local MAX_TIERS = 4

-- colors to be used with particle system
paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
}

function Brick:init(x, y, skin, tier)
    self.width = 32
    self.height = 16

    self.x = x
    self.y = y
    self.inPlay = true

    self.skin = skin
    self.tier = tier
    self.isLocked = false
    self.hasKey = false

    self.hasPowerUp = math.random(5) == 1 and true or false

    self.psystem = love.graphics.newParticleSystem(gTextures.particle)
    
    self.psystem:setPosition(self.x + self.width / 2, self.y + self.height / 2)
    
    self.psystem:setLinearAcceleration(-20, 0, 20, 80)
    
    self.psystem:setParticleLifetime(0.5, 0.75)

    self.psystem:setEmissionArea('normal', 10, 10)
end

function Brick:lock()
    self.skin = 5
    self.tier = 1
    self.isLocked = true
end

function Brick:unlock()
    self.isLocked = false
end

function Brick:hit()
    self.psystem:emit(24)

    -- setting colors so particles fade away
    -- to get this effect we have to put the alpha parameter value to 0
    self.psystem:setColors(
        paletteColors[self.skin]['r'] / 255,
        paletteColors[self.skin]['g'] / 255,
        paletteColors[self.skin]['b'] / 255,
        1,
        paletteColors[self.skin]['r'] / 255,
        paletteColors[self.skin]['g'] / 255,
        paletteColors[self.skin]['b'] / 255,
        0
    )

    if not self.isLocked then
        if self.tier > 1 then
            if self.skin == 1 then
                self.tier = self.tier - 1
                self.skin = 5
            else
                self.skin = self.skin - 1
            end
        else
            if self.skin == 1 then
                self.inPlay = false
            else 
                self.skin = self.skin - 1
            end
        end
    end 

    return self.psystem -- returning particles to be rendered
end

function Brick:render()
    if self.isLocked then
        love.graphics.draw(gTextures.main, gFrames['locked-brick'], self.x, self.y)
    else
        love.graphics.draw(gTextures.main, gFrames['bricks'][((self.skin - 1) * MAX_TIERS) + self.tier], self.x, self.y)
    end
end