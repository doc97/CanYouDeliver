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
  o.menu:newEntry("Start", function() event:fire("nextgame.game", { code = data.nextCode }) end)
  o.menu:set(1)
  
  -- setup gui properties
  o.winWidth, o.winHeight = love.window.getMode()
  o.gui:setPos(o.winWidth / 2, o.winHeight / 2 + 50)
  o.gui:setSize(global.font:getWidth("[*] Start"), global.font:getHeight())
  o.gui:setAlign("center", "center")
  
  o.title = "Next: " .. data.nextName
  o.titleWidth = global.titleFont:getWidth(o.title)
  o.titleX = o.winWidth / 2 - o.titleWidth / 2
  
  return o
end

function M:draw(g)
  g.setFont(global.titleFont)
  g.printf(self.title, 0, 250, self.winWidth, "center")
  g.setFont(global.font)
  g.printf("Total points: " .. state.points, 0, 350, self.winWidth, "center")
  self.gui:draw(g)
end

function M:update(dt) end

selectgame = M
return selectgame