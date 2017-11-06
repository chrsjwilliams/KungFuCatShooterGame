fallingRocks = { 
  tileSize = 16,
  rock_body,
  rock_shape,
  rock_fixture,
  rock_img
}

fallingRocks.__index = fallingRocks

function fallingRocks:makeRock(_world,xPos, yPos, rockImg) --	whatever parameters you want
	self.rock_body = love.physics.newBody(_world, xPos, yPos, "dynamic")
	-- Create a shape for the body.
	self.rock_shape = love.physics.newRectangleShape(15, 15, 30, 30)

	-- Create fixture between body and shape
	self.rock_fixture = love.physics.newFixture(self.rock_body, self.rock_shape)

	-- We can now refer to the player using the string "Player"
	self.rock_fixture:setUserData("Rock")
  
	-- Calculate the mass of the body based on attatched shapes.
	-- This gives realistic simulations.
	self.rock_body:setMassData(self.rock_shape:computeMass( 5 ))

	--print("\nIn falling rocks: "..tilesetImage)
	self.rock_img = rockImg

	self:initRock()
	return self
end

function fallingRocks:initRock() --	whatever parameters you want
end

function fallingRocks:update_GAME_START(dt) --	whatever parameters you want
end

function fallingRocks:update_GAME_PLAY(dt) --	whatever parameters you want
end

function fallingRocks:update_GAME_END(dt) --	whatever parameters you want
end

function fallingRocks:update_GAME_TEST(dt) --	whatever parameters you want
end

function fallingRocks:draw() --	whatever parameters you want
	x1, y1 = self.rock_shape:getPoints()
	
	return self.rock_img,self.rock_body:getX(), self.rock_body:getY(), self.rock_body:getAngle()
	--return currentAnim:draw(enemyImg, enemy_body:getX(), enemy_body:getY(), enemy_body:getAngle())
end