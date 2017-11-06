require 'fallingRocks'
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
	world = love.physics.newWorld(0, 9.15, true)
	world:setCallbacks(beginContact,endContact)
	rock = fallingRocks:makeRock(world, 100,50, tileQuads[6])
	self:buildGameWorld(_width, _height, _window_Name)
	return self
end

function gameWorld:buildGameWorld(_width, _height, _window_Name)
	width = _width
	height = _height
	window_Name = _window_Name
	
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


function gameWorld:update_GAME_START(dt) --	whatever parameters you want
	world:update(dt)
end

function gameWorld:update_GAME_PLAY(dt) --	whatever parameters you want
	world:update(dt)
end

function gameWorld:update_GAME_END(dt) --	whatever parameters you want
	world:update(dt)
end

function gameWorld:update_GAME_TEST(dt) --	whatever parameters you want
	world:update(dt)
end

function gameWorld:drawStartScreen() --	whatever parameters you want
	love.graphics.draw(background, 0, 0, 0, 1.56, 1.56, 0, 200)
	tilesetBatch:add(tileQuads[6], 150, 150, 0)
end

function gameWorld:drawGameScreen() --	whatever parameters you want
	love.graphics.draw(background, 0, 0, 0, 1.56, 1.56, 0, 200)
	tilesetBatch:add(tileQuads[6], 150, 150, 0)
end

function gameWorld:drawEndScreen() --	whatever parameters you want
	love.graphics.draw(background, 0, 0, 0, 1.56, 1.56, 0, 200)
	tilesetBatch:add(tileQuads[6], 150, 150, 0)
end

function gameWorld:drawTestScreen() --	whatever parameters you want
	love.graphics.draw(background, 0, 0, 0, 1.56, 1.56, 0, 200)
	love.graphics.draw(tilesetImage, rock:draw())
end

function gameWorld:updateTilesetBatch() --	whatever parameters you want
	tilesetBatch:clear()
	rock:draw(tilesetBatch, tileQuads)

	tilesetBatch:flush()
end

function gameWorld:getWidth()
	return width
end

function gameWorld:getHeight()
	return height
end

function gameWorld:getMidPoint(x1, y1, x2, y2)
	return ((x1 + x2) / 2), ((y1 + y2) / 2)
end

function  gameWorld:getWorld()
	return world
end

function gameWorld:getTileSetBatch()
	return tilesetBatch
end