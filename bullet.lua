bullet = {
	tileSize = 18,
	bullet_body,
	bullet_shape,
	bullet_fixture,
	bullet_img
}

--empty bullet table to keep track of bullets on screen

canFire = false
bulletTimerMax = 0.2
bulletTimer = bulletTimerMax
bulletStartSpeed = 100
bulletEndSpeed = 300

function bullet:makeBullet(_world, xPos, yPos, bulletImg, speed)
self.bullet_body = love.physics.newBody(_world, xPos, yPos, "dynamic")
self.bullet_shape = love.physics.newRectangleShape(15, 15, 30, 30)
self.bullet_fixture = love.physics.newFixture(self.bullet_body, self.bullet_shape)
self.bullet_fixture:setUserData("Bullet")
self.bullet_body:setMassData(self.bullet_shape:computeMass(3));
self.bullet_img = bulletImg
self.bullet_body:applyLinearImpulse(1000, 0)
--self:initBullet()

function bullet:initBullet()
end

function bullet:update_GAME_START(dt)
end

function bullet:update_GAME_PLAY(dt)
end

function bullet:update_GAME_END(dt)
end

function bullet:update_GAME_TEST(dt)
end

function bullet:draw()
	x1, y1 = self.bullet_shape:getPoints()

	return self.bullet_img, self.bullet_body:getX(), self.bullet_body:getY(), self.bullet_body:getAngle()

	end
end