push = require 'lib/push'
Class = require 'lib/class'
Timer = require 'lib/knife/timer'

require 'src/constants'
require 'src/Util'
require 'src/Animation'
require 'src/Entity'
require 'src/Player'
require 'src/Snail'
require 'src/GameObject'
require 'src/StateMachine'
require 'src/Tile'
require 'src/TileMap'
require 'src/Camera'
require 'src/LevelMaker'
require 'src/GameLevel'
require 'src/Button'
require 'src/states/BaseState'
require 'src/states/Game/TitleScreenState'
require 'src/states/Game/PlayState'
require 'src/states/Game/PauseState'
require 'src/states/Game/GameOverState'
require 'src/states/Player/PlayerIdleState'
require 'src/states/Player/PlayerMoveState'
require 'src/states/Player/PlayerJumpState'
require 'src/states/Player/PlayerFallState'
require 'src/states/Player/PlayerDeathState'
require 'src/states/Snail/SnailIdleState'
require 'src/states/Snail/SnailMoveState'
require 'src/states/Snail/SnailChaseState'

gTextures = {
    ['playerSheet'] = love.graphics.newImage('graphics/green_alien.png'),
    ['tileSheet'] = love.graphics.newImage('graphics/tiles.png'),
    ['tileTopSheet'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['creaturesSheet'] = love.graphics.newImage('graphics/creatures.png'),
    ['jumpBlocksSheet'] = love.graphics.newImage('graphics/jump_blocks.png'),
    ['tileTopSheet'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['slimes'] = love.graphics.newImage('graphics/slimes.png'),
    ['gems'] = love.graphics.newImage('graphics/gems.png'),
    ['bushes'] = love.graphics.newImage('graphics/bushes_and_cacti.png'),
    ['keysLocks'] = love.graphics.newImage('graphics/keys_and_locks.png')
}

gFrames = {
    ['player'] = generateQuads(gTextures['playerSheet'], PLAYER_WIDTH, PLAYER_HEIGHT),
    ['tiles'] = generateSets(gTextures['tileSheet'], 6, 10, TILE_SIZE, TILE_SIZE),
    ['jumpBlocks'] = generateSets(gTextures['jumpBlocksSheet'], 1, 5, TILE_SIZE, TILE_SIZE),
    ['tileTops'] = generateSets(gTextures['tileTopSheet'], 6, 18, TILE_SIZE, TILE_SIZE),
    ['slimes'] = generateSets(gTextures['slimes'], 2, 3, 16, 16),
    ['snails'] = table.slice(generateSets(gTextures['creaturesSheet'], 2, 7, 16, 16), 13, 14),
    ['gems'] = generateSets(gTextures['gems'], 4, 1, 16, 16),
    ['bushes'] = generateSets(gTextures['bushes'], 1, 5, 16, 16),
    ['keys'] = table.slice(generateQuads(gTextures['keysLocks'], 16, 16), 1, 4),
    ['locks'] = table.slice(generateQuads(gTextures['keysLocks'], 16, 16), 5, 8),
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['huge'] = love.graphics.newFont('fonts/font.ttf', 64),
}

gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['play'] = function() return PlayState() end,
    ['pause'] = function() return PauseState() end,
    ['gameOver'] = function() return GameOverState() end
}