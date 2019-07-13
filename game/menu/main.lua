local Menu = require "lib.menu"
local M = {}

function M:new()
  local base = Menu:new()
  local o = {}
  setmetatable(o, self)
  setmetatable(self, base)
  self.__index = self
  base.__index = base
  
  -- setup menu entries
  local event = event
  o.menu:newEntry("New Game", function() event:fire("main.newgame") end)
  o.menu:newEntry("Quit", function() event:fire("main.quit") end)
  o.menu:set(1)
  
  -- setup gui properties
  o.winWidth, o.winHeight = love.window.getMode()
  o.gui:setPos(o.winWidth / 2, o.winHeight / 2)
  o.gui:setSize(global.font:getWidth("[ ] New Game"), global.font:getHeight())
  o.gui:setAlign("center", "top")
  
  o.title = "Can You Deliver?"
  o.titleWidth = global.titleFont:getWidth(o.title)
  o.titleX = o.winWidth / 2 - o.titleWidth / 2
  
  o.circles = {}
  
  return o
end

function M:draw(g)
  for _, circle in ipairs(self.circles) do
    g.setColor(circle.color)
    g.circle("fill", circle.x, circle.y, circle.radius)
  end
  
  g.setColor(global.defaultColor)
  g.setFont(global.titleFont)
  g.print(self.title, self.titleX, 200)
  g.setFont(global.font)
  self.gui:draw(g)
end

function M:update(dt)
  if math.random() < 0.02 then
    local circle = {
      x = math.random(self.winWidth),
      color = { 240 / 255, 145 / 255, 15 / 255, math.random() * 0.8 },
      radius = math.random(self.winHeight / 8)
    }
    circle.y = self.winHeight + circle.radius
    self.circles[#self.circles + 1] = circle
  end
  
  for _, circle in ipairs(self.circles) do
    circle.y = circle.y - dt * 50 * circle.color[4]
  end
end

main = M
return main