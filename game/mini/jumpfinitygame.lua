local menuContinue = require "game.menu.continue"
local M = {}

local function isInAir(self) return self.player.y < self.winHeight - self.player.s - 30 end

local function spawnObstacles(self, dt)
  self.timer = self.timer + dt
  if self.timer > self.spawnTime then
    self.obstacles[#self.obstacles + 1] = {
      x = self.winWidth,
      y = self.winHeight - 30
    }
    self.timer = 0
  end
end

local function updateObstacles(self, dt)
  for _, o in ipairs(self.obstacles) do
    o.x = o.x - dt * 250 -- px / sec
  end
end

local function updatePlayer(self, dt)
  if self.player.dy ~= 0 and self.player.y + self.player.dy * dt > self.winHeight - self.player.s - 30 then
    -- If player is on / below "floor"
    self.player.y = self.winHeight - self.player.s - 30
    self.player.dy = 0
  end
  self.player.y = self.player.y + self.player.dy * dt
  
  if isInAir(self) then
    self.player.dy = self.player.dy + 25 -- gravity
  end
end

local function checkCollision(self)
  -- First discard impossible obstacles
  local possible = {}
  for _, o in ipairs(self.obstacles) do
    local distSqrd = (o.x - self.player.x) ^ 2 + (o.y - self.player.y) ^ 2
    -- math.sqrt(2 * 50 ^ 2) + math.sqrt(3) * 50 = ~157.3
    if distSqrd < 160 * 160 then
      possible[#possible + 1] = o
    end
  end
  
  local collided = false
  for _, o in ipairs(possible) do
    local ts = self.triangleShape
    local points = { o.x + ts.x1, o.y + ts.y1, o.x + ts.x2, o.y + ts.y2, o.x + ts.x3, o.y + ts.y3 }
    
    local px, py = self.player.x, self.player.y
    local px2, py2 = px + self.player.s, py + self.player.s
    
    for i=1, #points / 2 do
      local x, y = points[2 * i - 1], points[2 * i]
      local collidesX = x >= px and x <= px2
      local collidesY = y >= py and y <= py2
      if collidesX and collidesY then
        collided = true
        break
      end
    end
    
    if collided then
      state:nextGame()
      break
    end
  end
end

local function updateLevelTimer(self, dt)
  self.levelTimer = self.levelTimer - dt
  if self.levelTimer <= 0 then
    state:verifyContinuation({ level = self.level + 1, points = self.points + 100 })
  end
end

function M:new(data)
  data = data or { level = 1, points = 0 }
  local o = {}
  setmetatable(o, self)
  self.__index = self
  
  o.winWidth, o.winHeight = love.window.getMode()
  o.player = {
    x = 100,
    y = o.winHeight - 100 - 30,
    s = 100,
    dy = 0
  }
  
  local trSize = 50
  o.triangleShape = {
    x1 =  0 * trSize, y1 = -math.sqrt(3) * trSize,
    x2 =  1 * trSize, y2 =  0,
    x3 = -1 * trSize, y3 =  0,
  }
  
  o.obstacles = {}
  o.timer = 0
  o.spawnTime = 3
  
  o.levelTimer = 20
  o.level = data.level
  o.points = data.points
  
  return o
end

function M:draw(g)
  g.setColor(global.defaultColor)
  local tr = self.triangleShape
  for _, o in ipairs(self.obstacles) do
    g.polygon("fill", o.x + tr.x1, o.y + tr.y1, o.x + tr.x2, o.y + tr.y2, o.x + tr.x3, o.y + tr.y3)
  end
  --g.setColor(14 / 255, 108 / 255, 239 / 255)
  g.rectangle("fill", 0, self.winHeight - 30, self.winWidth, 15)
  g.setColor(global.accentColor)
  g.rectangle("fill", self.player.x, self.player.y, self.player.s, self.player.s)
end

function M:update(dt)
  spawnObstacles(self, dt)
  updateObstacles(self, dt)
  updatePlayer(self, dt)
  checkCollision(self)
  updateLevelTimer(self, dt)
end

function M:keypressed(key, scancode, isrepeat)
  if key == "space" and not isInAir(self) then
    self.player.dy = -750 -- px / sec, '-' means up
  end
end

function M:textinput(char) end

jumpfinitygame = M
return jumpfinitygame