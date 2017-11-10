building = { 
  tileSize = 16,

  screen_height,

  x = 0,
  y = 0,
  width = 0,
  height = 0,
  body,
  shape,
  world
}

building.__index = building 

function building:makeBuilding(x,tileSize, _world)
	self.world = _world
	self:setupBuilding(x, tileSize, world)
	return self
end

function building:setupBuilding(x, tileSize, _world)

  self.tileSize = tileSize
  self.x = x
  self.y = 300

  --set width and height, body, and shape, but with some new fun math
  --math.ceil (x): Returns the smallest integer larger than or equal to x.
  -- so we set a random height and width love.math.random( ) 
  self.width  = math.ceil((1 * 10) + 20)
  self.height = math.ceil(5 + love.math.random( ) * 7)


  --attaches a collider to the body using all the variable set before this
  self.shape = love.physics.newRectangleShape(self.x, self.y, 
                                              self.tileSize * self.width, 
                                              self.tileSize * self.height)

	
  
  --associates a Lua value with a fixture
  --fixture = love.physics.newFixture(self.body, self.shape)

  --now we can refer to the building by using the string "Building"
  --fixture:setUserData("Building")
  
end

--this is the update function that runs on buildings that were made
--it takes a body, a timescale, and another building
--in this case, all buildings are being propogated by the first two buildings
--each time a building gets made, it sets up a new building using the SECOND building built
--this in turn calls all the necessary functions until we get to that second building building more buildings and so on.
function building:update(groundPosition, dt, other_building)

--it builds buildings based on the position of the player
--this is some math: if the player is more than halfway across the building, make a new building?
 if self.x + self.width/2 * self.tileSize < groundPosition then
      self:setupBuilding(
          other_building.x + other_building.width  * self.tileSize + 150, 
          16)
  end
end

function building:draw(tilesetBatch, tileQuads)

--these are the x and y of the building being drawn, grabbed from the metatable
  x1, y1 = self.shape:getPoints()

  for x=self.width - 1, 0, -1 do 
    for y=0,self.height - 1, 1 do
      if x == 0 and y == 0 then
        tilesetBatch:add(tileQuads[1], x1 + x * self.tileSize, y1 + y * self.tileSize, 0)
      else
        if y == 0 and x == self.width - 1 then
          tilesetBatch:add(tileQuads[3], x1 + x * self.tileSize, y1 + y * self.tileSize, 0)
        else 
          if y == 0 then
            tilesetBatch:add(tileQuads[2], x1 + x * self.tileSize, y1 + y * self.tileSize, 0)
          else 
            num = math.floor(x + y + x1 + y1)
            if (num)%1 == 0 then
              tilesetBatch:add(tileQuads[5], x1 + x * self.tileSize, y1 + y * self.tileSize, 0)
            else
              tilesetBatch:add(tileQuads[5], x1 + x * self.tileSize, y1 + y * self.tileSize, 0)
            end
          end
        end
      end
    end
  end
end
