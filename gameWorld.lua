require 'fallingRocks'
require 'building'
gameWorld = { 
  tileSize = 16,
  width,
  height,
  window_Name,
  world
}

gameWorld.__index = gameWorld

function gameWorld:initGameWorld(_width, _height, _window_Name, image_atlas) --	whatever parameters you want
	local self = setmetatable({}, gameWorld)

	self.width = _width
	self.height = _height
	self.window_Name = _window_Name

	love.window.setMode(_width, _height, {resizable=false})
	love.window.setTitle(_window_Name)
	love.physics.setMeter(15)

	-- Sets background image 
	background = love.graphics.newImage('media/iPadMenu_atlas0.png')
	
	-- Make nearest neighbor, so pixels are sharp
	background:setFilter("nearest", "nearest")
	tilesetImage = image_atlas
	tilesetImage:setFilter("nearest", "nearest")
	self:loadTiles()
	tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, 1500)
	self.world = love.physics.newWorld(0, 9.15, true)
	self.world:setCallbacks(beginContact,endContact)
	groundPosition = 0
	backgroundPosition = 0
	building1 = building:makeBuilding(650, 16, self.world)
	building2 = building:makeBuilding(1200, 16, self.world)

	self:buildGameWorld(self.width, self.height, _window_Name)
	return self
end

function gameWorld:buildGameWorld(_width, _height, _window_Name)

	
end

function gameWorld:loadTiles()
	-- Reference quad for the crate
	tileQuads[0] =	love.graphics.newQuad(0, 0, 
					18, 18,
					tilesetImage:getWidth(), tilesetImage:getHeight())
	-- Left corner
	tileQuads[1] =	love.graphics.newQuad(228, 0, 
					16, 16,
					tilesetImage:getWidth(), tilesetImage:getHeight())
	-- Top middle
	tileQuads[2] =	love.graphics.newQuad(324, 0, 
					16, 16,
					tilesetImage:getWidth(), tilesetImage:getHeight())
	-- Right middle
	tileQuads[3] =	love.graphics.newQuad(387, 68, 
					16, 16,
					tilesetImage:getWidth(), tilesetImage:getHeight())
	-- Middle1
	tileQuads[4] =	love.graphics.newQuad(100, 0, 
					16, 16,
					tilesetImage:getWidth(), tilesetImage:getHeight())
	tileQuads[5] =	love.graphics.newQuad(116, 0, 
					16, 16,
					tilesetImage:getWidth(), tilesetImage:getHeight())
	--	Rock 1
	tileQuads[6] =	love.graphics.newQuad(195, 327, 
					19, 19,
					tilesetImage:getWidth(), tilesetImage:getHeight())
	--	Rock 2
	tileQuads[7] =	love.graphics.newQuad(213, 325, 
					16, 16,
					tilesetImage:getWidth(), tilesetImage:getHeight())
	--	Rock 3
	tileQuads[8] =	love.graphics.newQuad(237, 327, 
					16, 16,
					tilesetImage:getWidth(), tilesetImage:getHeight())
	--	Rock 4
	tileQuads[9] =	love.graphics.newQuad(296, 327, 
					16, 16,
					tilesetImage:getWidth(), tilesetImage:getHeight())
end

function gameWorld:getTileQuad()
	return tileQuads[0];
end

function gameWorld:getWorld()
	return self.world
end

function gameWorld:update_GAME_START(dt) --	whatever parameters you want
	self.world:update(dt)
end

function gameWorld:update_GAME_PLAY(dt) --	whatever parameters you want
	self.world:update(dt)
	if groundPosition > -800 then
		groundPosition = groundPosition - dt * 100
	else
		groundPosition = 0
	end
	if backgroundPosition > -800 then
		backgroundPosition = backgroundPosition - dt * 50
	else
		backgroundPosition = 0
	end
end

function gameWorld:update_GAME_END(dt) --	whatever parameters you want
	self.world:update(dt)
end

function gameWorld:update_GAME_TEST(dt) --	whatever parameters you want
	self.world:update(dt)
	gameWorld:updateTilesetBatch()

	building1:update(groundPosition, dt, building2)
	building2:update(groundPosition, dt, building1)

	if groundPosition > -800 then
		groundPosition = groundPosition - dt * 100
	else
		groundPosition = 0
	end
	if backgroundPosition > -800 then
		backgroundPosition = backgroundPosition - dt * 50
	else
		backgroundPosition = 0
	end
end

function gameWorld:drawStartScreen() --	whatever parameters you want
	love.graphics.draw(background, 0, 0, 0, 1.56, 1.56, 0, 200)
	tilesetBatch:add(tileQuads[6], 150, 150, 0)
end

function gameWorld:drawGameScreen() --	whatever parameters you want
	love.graphics.draw(background, 0, 0, 0, 1.56, 1.56, 0, 200)
	--tilesetBatch:add(tileQuads[6], 150, 150, 0)
end

function gameWorld:drawEndScreen() --	whatever parameters you want
	love.graphics.draw(background, 0, 0, 0, 1.56, 1.56, 0, 200)
	tilesetBatch:add(tileQuads[6], 150, 150, 0)
end

function gameWorld:drawTestScreen() --	whatever parameters you want
	love.graphics.draw(background, backgroundPosition, 0, 0, 1.56, 1.56, 0, 200)
	love.graphics.draw(background, backgroundPosition + self.width, 0, 0, 1.56, 1.56, 0, 200)
	tilesetBatch:add(tileQuads[6], 150, 250, 0)

end

function gameWorld:updateTilesetBatch() --	whatever parameters you want
	tilesetBatch:clear()
	building1:draw(tilesetBatch, tileQuads);
	building2:draw(tilesetBatch, tileQuads);
	tilesetBatch:flush()
	
	
end

function gameWorld:getWidth()
	return self.width
end

function gameWorld:getHeight()
	return self.height
end

function gameWorld:getMidPoint(x1, y1, x2, y2)
	return ((x1 + x2) / 2), ((y1 + y2) / 2)
end

function  gameWorld:getWorld()
	return self.world
end

function gameWorld:getTileSetBatch()
	return tilesetBatch
end