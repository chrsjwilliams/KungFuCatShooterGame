local anim8 = require 'anim8'
require 'player'

enemy = {}


enemy.__index = enemy

--load enemy image and animation
function enemy:load()
  -- enemy is the walkers
  walkerImage = love.graphics.newImage("media/walker2.png")
  -- default player if we didn't get a player
  --player = {xPos = 0, yPos = 0, angle = 0, width = 64, height = 64, speed=200, img=walkerImage}

  -- here is the player animation
  local g = anim8.newGrid(120, 80, walkerImage:getWidth(), walkerImage:getHeight())
    
  runAnim = anim8.newAnimation(g('1-6',1), 0.05)
  AttackAnim = anim8.newAnimation(g('1-6',2), 0.05)

  currentAnim = runAnim
  -- set the enemy spawn timer
  spawnTimer = 0
  spawnTimerMax = 1
  -- how quickly our walker walk
  walkerSpeed = 200
  -- how quickly walker charge to player
  chargeSpeed = 500
  enemiesKilled = 0
  --enemies group where put all the enemies
  enemies = {}
  hit		= love.audio.newSource("media/bomb_hit.mp3", "static")
  explode	= love.audio.newSource("media/bomb_explode.mp3", "static")
  return self

end

--draw enemy
function enemy:draw()
  -- draw the enemy here
  love.graphics.setColor(255, 0, 0)
  for index, enemy in ipairs(enemies) do
    currentAnim:draw(enemy.img, enemy.xPos, enemy.yPos, enemy.angle, 1, 1)
  end
end

--update the enemies spawn, check collision
function enemy:update(dt)

    updateEnemies(dt)
    checkCollisions()
    currentAnim:update(dt)
end

--to see if there is enough enemies, otherwise spawn more
function updateEnemies(dt)
  if spawnTimer > 0 then
    spawnTimer = spawnTimer - dt
  else
    spawnEnemy()
  end

  for i=table.getn(enemies), 1, -1 do
    enemy=enemies[i]
    enemy.update = enemy:update(dt)
    currentAnim:draw(walkerImage,enemy.xPos, enemy.yPos,0)
    if enemy.xPos < -enemy.width then
      table.remove(enemies, i)
    end
  end
end
-- how do we different type of  enemies
function spawnEnemy()
  y = love.math.random(0, love.graphics.getHeight() - 64)
  enemyType = love.math.random(0, 2)

  if enemyType == 0 then
    enemy = Enemy:new{yPos = y, speed = walkerSpeed, img = walkerImage, update=moveLeft}
  elseif enemyType == 1 then
    enemy = Enemy:new{yPos = y, speed = walkerSpeed, img = walkerImage, update=moveToPlayer}
  else
    enemy = Enemy:new{yPos = y, speed = walkerSpeed, img = walkerImage, update=chargePlayer}
  end
  table.insert(enemies, enemy)

  spawnTimer = spawnTimerMax
end

Enemy = {xPos = love.graphics.getWidth(), yPos = 0, width = 120, height = 80, angle = 0}

function Enemy:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- one type of enemy just move left
function moveLeft(obj, dt)
  currentAnim = runAnim
  obj.xPos = obj.xPos - obj.speed * dt
  return moveLeft
end

-- one type of enemy will move to player
function moveToPlayer(obj, dt)
  xSpeed = math.sin(math.rad (60)) * obj.speed
  ySpeed = math.cos(math.rad (60)) * obj.speed
  currentAnim = AttackAnim
  if (obj.yPos - player.yPos) > 10 then
    obj.yPos = obj.yPos - ySpeed * dt
    obj.xPos = obj.xPos - xSpeed * dt
    obj.angle = 0.1
  elseif (obj.yPos - player.yPos) < -10 then
    obj.yPos = obj.yPos + ySpeed * dt
    obj.xPos = obj.xPos - xSpeed * dt
    obj.angle = -0.1
  else
    obj.xPos = obj.xPos - obj.speed * dt
    obj.angle = 0
  end
  return moveToPlayer
end

-- one type of enemy will charge to player
function chargePlayer(obj, dt)
  xDistance = math.abs(obj.xPos - player.xPos)
  yDistance = math.abs(obj.yPos - player.yPos)
  distance = math.sqrt(yDistance^2 + xDistance^2)
  if distance < 150 then
    obj.speed = chargeSpeed
    obj.angle = 0
    return moveLeft
  end 
  moveToPlayer(obj, dt)
  return chargePlayer
end

-- check if we should kill player.. go die!!
function checkCollisions()
  for index, enemy in ipairs(enemies) do
    if (intersects(player, enemy) or intersects(enemy, player)) then
      state = GAME_OVER
	  bgm:stop()
	  titleScreenMusic:play()
      break
    end

     for index2, bullet in ipairs(bullets) do
       if intersects(enemy, bullet) then
		 hit:play()
		 explode:play()
		 enemiesKilled = enemiesKilled + 1
         table.remove(enemies, index)
         table.remove(bullet, index2)
         break
       end
     end
  end
end

-- check if two game object counter with each other, someone must die...
function intersects(rect1, rect2)
  if rect1.xPos < rect2.xPos and rect1.xPos + rect1.width > rect2.xPos and
     rect1.yPos < rect2.yPos and rect1.yPos + rect1.height > rect2.yPos then
    return true
  else
    return false
  end
end
