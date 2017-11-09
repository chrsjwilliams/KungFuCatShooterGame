local anim8 = require 'anim8'
require 'bullet'
require 'gameWorld'
player = { 
  tileSize = 16,
  xPos,
  yPos,
  moveSpeed
}

player.__index = player

function player:makePlayer(_world,xPos, yPos) --	whatever parameters you want
	body = love.physics.newBody(_world, xPos, yPos, "dynamic")
	-- Create a shape for the body.
	player_box = love.physics.newRectangleShape(15, 15, 30, 30)

	-- Create fixture between body and shape
	fixture = love.physics.newFixture(body, player_box)

	-- We can now refer to the player using the string "Player"
	fixture:setUserData("Player")
  
	-- Calculate the mass of the body based on attatched shapes.
	-- This gives realistic simulations.
	body:setMassData(player_box:computeMass( 1 ))

	body:setFixedRotation(true)

	playerImg = love.graphics.newImage("media/player2.png")
	local g = anim8.newGrid(30, 30, playerImg:getWidth(), playerImg:getHeight())
	runAnim = anim8.newAnimation(g('1-14',1), 0.05)
	jumpAnim = anim8.newAnimation(g('15-19',1), 0.1)
	inAirAnim = anim8.newAnimation(g('1-8',2), 0.1)
	rollAnim = anim8.newAnimation(g('9-19',2), 0.05)

	-- Sets current animation
	currentAnim = inAirAnim
	self:initPlayer()
	return self
end

function player:initPlayer() --	whatever parameters you want
	moveSpeed = 130
end

function player:Move(x,y)
	body:setLinearVelocity(x, y)
end
function player:shoot()
bullet:makeBullet(gameWorld:getWorld(), self.xPos, self.yPos, playerImg, 100)
bullet:draw()
end
function love.keypressed( key, isrepeat )
	if (key == "up" and (state == GAME_PLAY or state == GAME_TEST)) then
		player:Move(0, -moveSpeed)
	elseif (key == "down" and (state == GAME_PLAY or state == GAME_TEST)) then
		player:Move(0, moveSpeed)
	elseif(key == "space"  and (state == GAME_PLAY or state == GAME_TEST)) then
		player:shoot()
	end
end

function player:update_GAME_START(dt) --	whatever parameters you want
end

function player:update_GAME_PLAY(dt) --	whatever parameters you want
end

function player:update_GAME_END(dt) --	whatever parameters you want
end

function player:update_GAME_TEST(dt) --	whatever parameters you want
end

function player:draw() --	whatever parameters you want
	love.graphics.setColor(0, 255, 0)
	return currentAnim:draw(playerImg, body:getX(), body:getY(), body:getAngle())
end

function player:getMoveSpeed()
	return moveSpeed
end