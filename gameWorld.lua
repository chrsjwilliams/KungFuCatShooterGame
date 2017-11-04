gameWorld = { 
  tileSize = 16,
  width,
  height,
  window_Name,
  world
}

gameWorld.__index = gameWorld

function gameWorld:initGameWorld(_width, _height, _window_Name) --	whatever parameters you want
	local self = setmetatable({}, gameWorld)
	

	love.window.setMode(_width, _height, {resizable=false})
	love.window.setTitle(_window_Name)
	love.physics.setMeter(15)
	

	-- Sets background image 
	background = love.graphics.newImage('media/iPadMenu_atlas0.png')
	-- Make nearest neighbor, so pixels are sharp
	background:setFilter("nearest", "nearest")
	tilesetImage=love.graphics.newImage('media/play1_atlas0.png')
	tilesetImage:setFilter("nearest", "nearest")
	self:loadTiles()
	tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, 1500)
	world = love.physics.newWorld(0, 0, true)
	world:setCallbacks(beginContact,endContact)
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

function gameWorld:draw() --	whatever parameters you want
	love.graphics.draw(background, 0, 0, 0, 1.56, 1.56, 0, 200)
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