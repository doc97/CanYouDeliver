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
  local winWidth, winHeight = love.window.getMode()
  o.gui:setPos(winWidth / 2, winHeight / 2 + 100)
  o.gui:setSize(global.font:getWidth("[ ] New Game"), global.font:getHeight())
  o.gui:setAlign("center", "top")
  
  o.title = "Can You Deliver?"
  o.titleWidth = global.titleFont:getWidth(o.title)
  o.titleX = winWidth / 2 - o.titleWidth / 2
  
  return o
end

function M:draw(g)
  g.setFont(global.titleFont)
  g.print(self.title, self.titleX, 200)
  g.setFont(global.font)
  self.gui:draw(g)
end

function M:update(dt) end

main = M
return main