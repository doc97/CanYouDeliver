local ipairs = ipairs
local M = { }

function M:new(o)
  o = o or { fields = {} }
  setmetatable(o, self)
  self.__index = self
  return o
end

function M:newField(name, label, isPassword)
  self.fields[#self.fields + 1] = { name = name, label = label, value = "", isPassword = isPassword }
end

function M:setSubmitCallback(func)
  self.submitCallback = func
end

function M:submit()
  if self.submitCallback then
    local fields = {}
    for _, field in ipairs(self.fields) do
      fields[field.name] = field.value
    end
    self.submitCallback(fields)
  end
end

function M:reset()
  for _, field in ipairs(self.fields) do
    field.value = ""
  end
  self.curField = #self.fields > 0 and 1 or nil
end

function M:next()
  if #self.fields > 0 then
    if self.curField == #self.fields then
      self:submit()
    else
      self.curField = self.curField and self.curField + 1 or 1
    end
  end
end

function M:prev()
  if #self.fields > 0 then
    self.curField = (self.curField and self.curField > 1) and self.curField - 1 or 1
  end
end

function M:addChar(char)
  if self.curField then
    local field = self.fields[self.curField]
    field.value = field.value .. char
  end
end

function M:delChar()
  if self.curField then
    local field = self.fields[self.curField]
    if field.value:len() > 0 then
      field.value = field.value:sub(1, -2)
    end
  end
end

BaseForm = M
return BaseForm