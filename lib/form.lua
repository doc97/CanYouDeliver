local BaseForm = require "lib.baseform"
local GUIForm = require "lib.guiform"

local M = {}

function M:new(o)
  o = o or {}
  o.form = BaseForm:new()
  o.gui = GUIForm:new({ form = o.form })
  setmetatable(o, self)
  self.__index = self
  return o
end

function M:keypressed(key, scancode, isrepeat)
  if key == "up" then
    self.form:prev()
  elseif key == "down" then
    self.form:next()
  elseif key == "return" then
    self.form:next()
  elseif key == "backspace" then
    self.form:delChar()
  end
end

function M:textinput(char)
  self.form:addChar(char)
end

Form = M
return Form