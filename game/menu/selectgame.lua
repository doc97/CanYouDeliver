local state = require "game.state"
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
  o.menu:newEntry("Number Memory", function() event:fire("selectgame.game", { name = "memnumgame" }) end)
  o.menu:newEntry("Exit", function() event:fire("selectgame.exit") end)
  o.menu:set(1)
  
  -- setup gui properties
  o.winWidth, o.winHeight = love.window.getMode()
  o.gui:setPos(o.winWidth / 2, o.winHeight / 2 + 50)
  o.gui:setSize(global.font:getWidth("[ ] Number Memory"), global.font:getHeight())
  o.gui:setAlign("center", "center")
  
  o.title = "Select mini-game"
  o.titleWidth = global.titleFont:getWidth(o.title)
  o.titleX = o.winWidth / 2 - o.titleWidth / 2
  
  return o
end

function M:draw(g)
  g.setFont(global.titleFont)
  g.printf(self.title, 0, 150, self.winWidth, "center")
  g.setFont(global.font)
  g.printf("Total points: " .. state.points, 0, 250, self.winWidth, "center")
  self.gui:draw(g)
end

function M:update(dt) end

selectgame = M
return selectgame