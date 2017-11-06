require 'gameWorld'
require 'player'
require 'enemy'
require 'fallingRocks'

-- Parts of the tileset used for different tiles
tileQuads = {} 

-- Time variable. Used for animations
local time = 0


-- Our game states are defined by these numbers
GAME_START	= 0
GAME_PLAY	= 1
GAME_OVER	= 2
GAME_TEST	= 3
state		= GAME_TEST

--	Main should handle the life cycle of our game.
--	Ideally ALL state changes should be done through main

--	This way we can work in our own files and main will compile
--	them for us! If you need access to a variable in someone's 
--	script, let them know before altering their code.
function love.load()
	
	--	Moved tilesetImage out here in case any other classes need
	--	to access it. Just pass tilesetImage as a parameter.
	tilesetImage = love.graphics.newImage('media/play1_atlas0.png')

	text = ""
	--	Make world here
	--	All the physics stuff and loading of images for the game world
	--	shoule be done here
	gameWorld1 = gameWorld:initGameWorld(600, 300, "Game Name", tilesetImage)
	
	--	Make Player here
	--	Everything related to the player should be in player class.
	--	Input for the game is in the player.lua file
	--	Player is green
	player1 = player:makePlayer(gameWorld1:getWorld(), gameWorld1:getWidth() / 10, gameWorld1:getHeight() / 2)
	
	--	Make Enemy Here
	--	All enemy logic should be handled here. I'm not sure if this
	--	script is a description of an enemy or an enemy manager
	--	Enemy is red
	enemy1 = enemy:makeEnemy(gameWorld1:getWorld(), 50, 50)

	--	We make two draw calls as of now. One for our gameworld, and
	--	one for our entities (player enemies). We may want to have
	--	more if we want different layers in our game (ie foreground, background)
	entityImg = love.graphics.newImage("media/player2.png")
	entities = love.graphics.newSpriteBatch(entityImg, 1500)
	
	-- Sets font size to 12
	love.graphics.setNewFont(12)
end

function restartGame()
	state = GAME_PLAY
	love.load()
end


function love.update(dt)
	gameWorld1:updateTilesetBatch()
	updateTilesetBatch()
	if	(state == GAME_START) then
		startScreen(dt)
	elseif (state == GAME_PLAY) then
		gameScreen(dt)
	elseif (state == GAME_END) then
		endScreen(dt)
	elseif (state == GAME_TEST) then
		testScreen(dt)
	end
end

function startScreen(dt)
	gameWorld1:update_GAME_START(dt)
	player1:update_GAME_START(dt)
	enemy1:update_GAME_START(dt)
end

function prepGameScreen()
  -- Sets font size to 12
  love.graphics.setNewFont(12)
  state = GAME_PLAY
end

function gameScreen(dt)
	gameWorld1:update_GAME_PLAY(dt)
	player1:update_GAME_PLAY(dt)
	enemy1:update_GAME_PLAY(dt)
end

function endScreen(dt)
	gameWorld1:update_GAME_END(dt)
	player1:update_GAME_END(dt)
	enemy1:update_GAME_END(dt)
end

function testScreen(dt)
	gameWorld1:update_GAME_TEST(dt)
	player1:update_GAME_TEST(dt)
	enemy1:update_GAME_TEST(dt)
end

function love.draw()
	if(state == GAME_START) then
		drawStartScreen()
	elseif (state == GAME_PLAY) then
		drawGameScreen()
	elseif (state == GAME_OVER) then
		drawEndScreen()
	elseif (state == GAME_TEST) then
		drawTestScreen()
	end
end

function drawStartScreen()
	gameWorld1:draw()
	
	entities:add(player1:draw())
	entities:add(enemy1:draw())
	
	love.graphics.setColor(255, 255, 255)
end

function drawGameScreen()
	gameWorld1:draw()
	
	entities:add(player1:draw())
	entities:add(enemy1:draw())
	
	love.graphics.setColor(255, 255, 255)
end

function drawEndScreen()
	gameWorld1:draw()
	
	entities:add(player1:draw())
	entities:add(enemy1:draw())
	
	love.graphics.setColor(255, 255, 255)
end

function drawTestScreen()
	gameWorld1:drawTestScreen()

	entities:add(player1:draw())
	entities:add(enemy1:draw())	
	love.graphics.setColor(255, 255, 255)	
end

function updateTilesetBatch()
	entities:clear()
	entities:flush()	
end

-- This is called every time a collision begin.
function beginContact(bodyA, bodyB, coll)
  --Get the userdata from these two body, which we will print out later
  local aData=bodyA:getUserData()
  local bData =bodyB:getUserData()
  -- get the collider position, x and y
  cx,cy = coll:getNormal()
  --save the information we got from aData and bData, and also the position where collision happened
  text = text.."\n"..aData.." colliding with "..bData.." with a vector normal of: "..cx..", "..cy
  --print out the information we just saved
  print (text)
end


function endContact(bodyA, bodyB, coll)
--when contact ends, that means we are either falling or jumping, so we're no longer on the ground 
  onGround = false

  --these two local variables store the names of the objects overlapping
  --or maybe it's the "fixture" of the object because they are using the same strings as the fixture
  --as of right now, this is pretty much always the player and the building
  --"text" is the means by which we can log to the console.
  local aData=bodyA:getUserData()
  local bData=bodyB:getUserData()
  text = "Collision ended: " .. aData .. " and " .. bData

end

function love.focus(f)
  if not f then
    print("LOST FOCUS")
  else
    print("GAINED FOCUS")
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end