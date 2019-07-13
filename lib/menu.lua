local BaseMenu = require "lib.basemenu"
local GUIMenu = require "lib.guimenu"

local M = {}

function M:new(o)
  o = o or {}
  o.menu = BaseMenu:new()
  o.gui = GUIMenu:new({ menu = o.menu })
  setmetatable(o, self)
  self.__index = self
  return o
end

function M:keypressed(key, scancode, isrepeat)
  if key == "up" then
    self.menu:prev()
  elseif key == "down" then
    self.menu:next()
  elseif key == "return" then
    self.menu:select()
  end
end

function M:textinput(char) end

Menu = M
return Menu