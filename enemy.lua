local anim8 = require 'anim8'
enemy = { 
  tileSize = 16
}

enemy.__index = enemy

function enemy:makeEnemy(_world,xPos, yPos) --	whatever parameters you want
	enemy_body = love.physics.newBody(_world, xPos, yPos, "dynamic")
	print(xPos)
	-- Create a shape for the body.
	enemy_box = love.physics.newRectangleShape(15, 15, 30, 30)

	-- Create fixture between body and shape
	enemy_fixture = love.physics.newFixture(enemy_body, enemy_box)

	-- We can now refer to the player using the string "Player"
	enemy_fixture:setUserData("Enemy")
  
	-- Calculate the mass of the body based on attatched shapes.
	-- This gives realistic simulations.
	enemy_body:setMassData(enemy_box:computeMass( 1 ))

	enemy_body:setFixedRotation(true)

	enemyImg = love.graphics.newImage("media/player2.png")
	local g = anim8.newGrid(30, 30, enemyImg:getWidth(), enemyImg:getHeight(), 3)
	runAnim = anim8.newAnimation(g('1-14',1), 0.05)
	jumpAnim = anim8.newAnimation(g('15-19',1), 0.1)
	inAirAnim = anim8.newAnimation(g('1-8',2), 0.1)
	rollAnim = anim8.newAnimation(g('9-19',2), 0.05)

	-- Sets current animation
	currentAnim = inAirAnim

	self:initEnemy()
	return self
end

function enemy:initEnemy() --	whatever parameters you want
end

function enemy:update_GAME_START(dt) --	whatever parameters you want
end

function enemy:update_GAME_PLAY(dt) --	whatever parameters you want
end

function enemy:update_GAME_END(dt) --	whatever parameters you want
end

function enemy:update_GAME_TEST(dt) --	whatever parameters you want
end

function enemy:draw() --	whatever parameters you want
	love.graphics.setColor(255, 0, 0)
	return currentAnim:draw(enemyImg, enemy_body:getX(), enemy_body:getY(), enemy_body:getAngle())
end