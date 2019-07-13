local GUIElem = require "lib.guielem"
local string = string

local M = GUIElem:new()

function M:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function M:getX()
  if not self.alignX then return self.x end
  if self.alignX == "center" then return self.x - self.width / 2 end
  if self.alignX == "right" then return self.x - self.width end
  return self.x
end

function M:getY()
  if not self.alignY then return self.y end
  if self.alignY == "center" then return self.y - (self.height * #self.menu.entries) / 2 end
  if self.alignY == "bottom" then return self.y - (self.height * #self.menu.entries) end
  return self.y
end

function M:draw(g)
  local x = self:getX()
  local y = self:getY()
  local entryHeight = self.height
  local nextSpaceIdx = 1
  local nextSpace = self.menu.spaces[nextSpaceIdx]
  local spaces = 0
  for i, entry in ipairs(self.menu.entries) do
    if i == nextSpace then
      nextSpaceIdx = nextSpaceIdx + 1
      nextSpace = self.menu.spaces[nextSpaceIdx]
      spaces = spaces + 1
    end
    
    local lineFormat = i == self.menu.selected and "[*] %s" or "[ ] %s"
    g.print(lineFormat:format(entry.name), x, y + (i - 1 + spaces) * entryHeight)
  end
end

GUIMenu = M
return GUIMenu