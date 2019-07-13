local M = {
  x = 0, y = 0,
  width = 0, height = 0,
  alignX = "left", alignY = "top"
}

function M:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function M:setPos(x, y)
  self.x = x
  self.y = y
end

function M:setSize(width, height)
  self.width = width
  self.height = height
end

function M:setAlign(alignX, alignY)
  self.alignX = alignX
  self.alignY = alignY
end

function M:setAlignX(alignX)
  self.alignX = alignX
end

function M:setAlignY(alignY)
  self.alignY = alignY
end

GUIElem = M
return GUIElem