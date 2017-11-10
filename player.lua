local anim8 = require 'anim8'
require 'bullet'
require 'gameWorld'

player = {xPos = 0, yPos = 0, width = 140, height = 140, speed = 200}
player.__index = player
bullets = {}

function player:makePlayer() --	whatever parameters you want
playerImg = love.graphics.newImage("media/player.png")
tilesetImage=love.graphics.newImage('media/play1_atlas0.png')
spaceShitAtlas = love.graphics.newImage('media/iPadPlay2_atlas0.png')
tilesetImage:setFilter("nearest", "nearest") -- this "linear filter" removes some artifacts if we were to scale the tiles
tileSize = 16

shipImg = love.graphics.newQuad(129, 0, 256, 128, spaceShitAtlas:getWidth(), spaceShitAtlas:getHeight())

bulletImg = love.graphics.newQuad(0, 28, 
    40, 78,
    tilesetImage:getWidth(), tilesetImage:getHeight())

 tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, 1500)
 --bullet = tilesetBatch:add(tileQuads[0], player.xPos, player.yPos, 0)

 canFire = false;
 bulletTimerMax = 0.2
 bulletTimer = bulletTimerMax
 bulletStartSpeed = 100
 bulletMaxSpeed = 300

local g = anim8.newGrid(140, 140, playerImg:getWidth(), playerImg:getHeight())
idleAnim = anim8.newAnimation(g('1-2',3), .25)
shootAnim = anim8.newAnimation(g('1-6',2), .05)
currentPlayerAnim = idleAnim
	preShoot	= love.audio.newSource("media/bomb_pre.mp3", "static")
	launchShot	= love.audio.newSource("media/bomb_launch.mp3", "static")
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

function player:update_GAME_START(dt) --	whatever parameters you want
end

function player:update_GAME_END(dt) --	whatever parameters you want
end

function player:update_GAME_PLAY(dt) --	whatever parameters you want
updatePlayer(dt)
updateBullets(dt)
currentPlayerAnim:update(dt)
end

function player:draw() --	whatever parameters you want
 love.graphics.setColor(255, 255, 255)
 currentPlayerAnim:draw(playerImg, player.xPos, player.yPos, 0, .5)
 for index, bullet in ipairs(bullets) do
	love.graphics.draw(tilesetImage, bullet.img, bullet.xPos, bullet.yPos, -359.75, .5)
	end
 love.graphics.draw(spaceShitAtlas, shipImg, player.xPos + player.width - 65, player.yPos + 10, 0, -1, 1)
end

function player:getMoveSpeed()
	return moveSpeed
end

function updatePlayer(dt)
down = love.keyboard.isDown("down")
up = love.keyboard.isDown("up")
left = love.keyboard.isDown("left")
right = love.keyboard.isDown("right")

speed = player.speed

downUp = love.keyboard.isDown("down") or love.keyboard.isDown("up")
leftRight = love.keyboard.isDown("left") or love.keyboard.isDown("right")

if(down or up or left or right) then
end

if(downUp and leftRight) then 
	speed = speed / math.sqrt(2)
end

if down and player.yPos < love.graphics.getHeight() - player.height then
	player.yPos = player.yPos + dt * speed
elseif up and player.yPos > 0 then
	player.yPos = player.yPos - dt * speed
end

if right and player.xPos < love.graphics.getWidth() - player.width then
	player.xPos = player.xPos + dt * speed
elseif left and player.xPos > 0 then
	player.xPos = player.xPos - dt * speed
end

if love.keyboard.isDown("space") then 
	preShoot:play()
	bulletSpeed = bulletStartSpeed
	bulletSpeed = bulletSpeed + player.speed * 2
	currentPlayerAnim = shootAnim
	spawnBullet(player.xPos + player.width - 75, player.yPos + player.height/2 + 25, bulletSpeed)
end

if bulletTimer > 0 then
	bulletTimer = bulletTimer - dt
else
currentPlayerAnim = idleAnim
	canFire = true
end
end

function spawnBullet(x, y, speed)
	if canFire then
		preShoot:stop()
		bullet = {xPos = x, yPos = y, width = 16, height = 16, speed = speed, img = bulletImg}
		table.insert(bullets, bullet)
		launchShot:play()
		canFire = false
		bulletTimer = bulletTimerMax
	end
end

function updateBullets(dt)
	
for index, bullet in ipairs(bullets) do
	bullet.xPos = bullet.xPos + dt * bullet.speed
	if bullet.speed < bulletMaxSpeed then
		bullet.speed = bulletSpeed + dt * 100
		
	end
	if bullet.xPos > love.graphics.getWidth() then
	table.remove(bullets, index)
	end
  end
end