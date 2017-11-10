require 'gameWorld'
require 'player'
require 'enemy'

-- Parts of the tileset used for different tiles
tileQuads = {} 

-- Time variable. Used for animations
local time = 0


-- Our game states are defined by these numbers
GAME_START	= 0
GAME_PLAY	= 1
GAME_OVER	= 2
GAME_TEST	= 3
state		= GAME_START

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
	gameWorld1 = gameWorld:initGameWorld(600, 300, "Kung Fu Cat 3", tilesetImage)
	
	--	Make Player here
	--	Everything related to the player should be in player class.
	--	Input for the game is in the player.lua file
	--	Player is green
	player1 = player:makePlayer()
	
	--	Make Enemy Here
	--	All enemy logic should be handled here. I'm not sure if this
	--	script is a description of an enemy or an enemy manager
	--	Enemy is red
	enemy1 = enemy:load()

	--	We make two draw calls as of now. One for our gameworld, and
	--	one for our entities (player enemies). We may want to have
	--	more if we want different layers in our game (ie foreground, background)
	
	-- Sets font size to 12
	
	titleFont = love.graphics.newFont("media/Flixel.ttf", 50)
	love.graphics.setFont(titleFont)

	gameFont = love.graphics.newFont("media/Flixel.ttf", 10)
	love.graphics.setFont(gameFont)

	text = "Hello"
	--restartGame()
end

function restartGame()
	gameFont = love.graphics.newFont("media/Flixel.ttf", 10)
	love.graphics.setFont(gameFont)
	gameWorld1:loadGameWorld()
	state = GAME_PLAY
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

	if love.keyboard.isDown("space") then 
		state = GAME_PLAY
	end

end

function prepGameScreen()
  -- Sets font size to 12
  love.graphics.setNewFont(12)
  state = GAME_PLAY
end

function gameScreen(dt)
	gameWorld1:update_GAME_PLAY(dt)
	player1:update_GAME_PLAY(dt)
	enemy1:update(dt)
end

function endScreen(dt)
	gameWorld1:update_GAME_END(dt)
	player1:update_GAME_END(dt)
	enemy1:update_GAME_END(dt)
end

function love.draw()
	

	if(state == GAME_START) then
		drawStartScreen()
		love.graphics.setFont(titleFont)
		text = "Kung Fu Cat 3:"
		text = text .. "\n   Feline Fine"
		
		love.graphics.print(text, gameWorld1:getWidth()/10, gameWorld1:getWidth()* (1/9))
		love.graphics.setFont(gameFont)
		text = "\n\nPress SPACE to Play"
		love.graphics.print(text, gameWorld1:getWidth()* (7/18), gameWorld1:getWidth()* (3/9))
	elseif (state == GAME_PLAY) then
		drawGameScreen()
		text = "Rat-bots Destroyed: " .. enemiesKilled
		love.graphics.setColor(255, 255, 255)
		love.graphics.print(text, 10,10)
	elseif (state == GAME_OVER) then
		drawEndScreen()
	elseif (state == GAME_TEST) then
		drawTestScreen()
	end
	
end

function drawStartScreen()
	gameWorld1:drawStartScreen()
	love.graphics.setColor(255, 255, 255)
end

function drawGameScreen()
	gameWorld1:drawGameScreen()
	
	player1:draw()
	enemy1:draw()
	
	love.graphics.setColor(255, 255, 255)
end

function drawEndScreen()
	gameWorld1:draw()
	
	love.graphics.setColor(255, 255, 255)
end

function drawTestScreen()
	gameWorld1:drawTestScreen()
	player1:draw()
	enemy1:draw()
	love.graphics.setColor(255, 255, 255)	
end

function updateTilesetBatch()

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