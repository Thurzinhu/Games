push = require 'lib/push'
Class = require 'lib/class'

require 'src/constants'
require 'src/Util'
require 'src/Animation'
require 'src/Entity'
require 'src/Player'
require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/Tile'
require 'src/TileMap'
require 'src/states/Player/PlayerIdleState'
require 'src/states/Player/PlayerMoveState'
require 'src/states/Player/PlayerJumpState'
require 'src/states/Player/PlayerFallState'

gTextures = {
    ['playerSheet'] = love.graphics.newImage('graphics/green_alien.png'),
    ['tileSheet'] = love.graphics.newImage('graphics/tiles.png'),
    ['tileTopSheet'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['creaturesSheet'] = love.graphics.newImage('graphics/creatures.png'),
    ['jumpBlocksSheet'] = love.graphics.newImage('graphics/jump_blocks.png'),
    ['tileTopSheet'] = love.graphics.newImage('graphics/tile_tops.png')
}

gFrames = {
    ['player'] = generateQuads(gTextures['playerSheet'], PLAYER_WIDTH, PLAYER_HEIGHT),
    ['tiles'] = generateSets(gTextures['tileSheet'], 6, 10, TILE_SIZE, TILE_SIZE),
    ['jumpBlocks'] = generateSets(gTextures['jumpBlocksSheet'], 1, 5, TILE_SIZE, TILE_SIZE),
    ['tileTops'] = generateSets(gTextures['tileTopSheet'], 6, 18, TILE_SIZE, TILE_SIZE)
}
