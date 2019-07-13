local Menu = require "lib.menu"
local M = {}

function M:new(data)
  local base = Menu:new()
  local o = {}
  setmetatable(o, self)
  setmetatable(self, base)
  self.__index = self
  base.__index = base
  
  -- setup menu entries
  local event = event
  o.winWidth, o.winHeight = love.window.getMode()
  o.menu:newEntry("Yes", function() event:fire("continue.yes", { game = data.game, data = data.data }) end)
  o.menu:newEntry("No", function() event:fire("continue.no", { points = data.data.points }) end)
  o.menu:set(1)
  
  -- setup gui properties
  o.gui:setPos(o.winWidth /2, o.winHeight / 2 + 50)
  o.gui:setSize(global.font:getWidth("[ ] Yes"), global.font:getHeight())
  o.gui:setAlign("center", "center")
  
  o.question = "Do you want to continue?"
  o.points = "Collected points: " .. data.data.points
  
  return o
end

function M:draw(g)
  g.setFont(global.titleFont)
  g.printf(self.question, 0, self.winHeight / 2 - 200, self.winWidth, "center")
  g.setFont(global.font)
  g.printf(self.points, 0, self.winHeight / 2 - 100, self.winWidth, "center")
  self.gui:draw(g)
end

function M:update(dt) end

continue = M
return continue