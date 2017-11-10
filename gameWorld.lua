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
	backgroundLayer = love.graphics.newImage('media/iPadMenu_atlas0.png')
	
	-- Make nearest neighbor, so pixels are sharp
	backgroundLayer:setFilter("nearest", "nearest")
	tilesetImage = image_atlas
	tilesetImage:setFilter("nearest", "nearest")
	self:loadTiles()
	tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, 1500)
	self.world = love.physics.newWorld(0, 9.15, true)
	self.world:setCallbacks(beginContact,endContact)
	groundPosition = 0
	bgPos = 0
	bgm	= love.audio.newSource("media/18-machinae_supremacy-lord_krutors_dominion.mp3", "stream")
	scrollSpeed = 250
	return self
end

function gameWorld:loadGameWorld()
	love.audio.setVolume( 0.2 )

	bgm:play()
	scrollSpeed = 250
	groundPosition = 0
	bgPos = 0
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
	if bgPos > -800 then
		bgPos = bgPos - dt * scrollSpeed
	else
		bgPos = 0
	end
end

function gameWorld:update_GAME_PLAY(dt) --	whatever parameters you want
	self.world:update(dt)

	
	if bgPos > -800 then
		bgPos = bgPos - dt * scrollSpeed
	else
		bgPos = 0
	end
end

function gameWorld:update_GAME_END(dt) --	whatever parameters you want
	self.world:update(dt)
end

function gameWorld:drawStartScreen() --	whatever parameters you want
	love.graphics.setColor(125, 125, 125)
	love.graphics.draw(backgroundLayer, bgPos, 0, 0, 1.56, 1.56, 0, 200)
	love.graphics.draw(backgroundLayer, bgPos + self.width, 0, 0, 1.56, 1.56, 0, 200)
end

function gameWorld:drawGameScreen() --	whatever parameters you want
	love.graphics.setColor(125, 125, 125)
	love.graphics.draw(backgroundLayer, bgPos, 0, 0, 1.56, 1.56, 0, 200)
	love.graphics.draw(backgroundLayer, bgPos + 795, 0, 0, 1.56, 1.56, 0, 200)
end

function gameWorld:drawEndScreen() --	whatever parameters you want
	love.graphics.draw(backgroundLayer, 0, 0, 0, 1.56, 1.56, 0, 200)
end


function gameWorld:updateTilesetBatch() --	whatever parameters you want
	tilesetBatch:clear()
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