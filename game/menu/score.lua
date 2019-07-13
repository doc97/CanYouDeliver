local Menu = require "lib.menu"
local M = {}

function M:new(data)
  local base = Menu:new()
  local o = {}
  setmetatable(o, self)
  setmetatable(self, base)
  self.__index = self
  base.__index = base
  
  o.menu:newEntry("Continue", function() event:fire("score.continue") end)
  o.menu:set(1)
  
  o.winWidth, o.winHeight = love.window.getMode()
  o.gui:setPos(o.winWidth / 2, o.winHeight / 2)
  o.gui:setSize(global.font:getWidth("[*] Continue"), global.font:getHeight())
  o.gui:setAlign("center", "center")
  
  o.score = "Final Score: " .. data.points
  
  return o
end

function M:draw(g)
  g.setFont(global.titleFont)
  g.printf(self.score, 0, self.winHeight / 2 - 200, self.winWidth, "center")
  g.setFont(global.font)
  self.gui:draw(g)
end

function M:update(dt) end

score = M
return score