local GUIElem = require "lib.guielem"

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
  if self.alignY == "center" then return self.y - (self.height * #self.form.fields) / 2 end
  if self.alignY == "bottom" then return self.y - (self.height * #self.form.fields) end
  return self.y
end

function M:draw(g)
  local x = self:getX()
  local y = self:getY()
  local fieldHeight = self.height
  
  for i, field in ipairs(self.form.fields) do
    local value = field.isPassword and ("*"):rep(#field.value) or field.value
    local cursor = i == self.form.curField and "_" or ""
    local entry = ("%s: %s%s"):format(field.label, value, cursor)
    g.print(entry, x, y + (i - 1) * fieldHeight)
  end
end

GUIForm = M
return GUIForm