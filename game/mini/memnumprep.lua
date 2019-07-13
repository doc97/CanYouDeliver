local NumberMemoryGame = "game.mini.memnumgame"
local Form = require "lib.form"
local M = {}

function M:new()
  local base = Form:new()
  local o = {}
  setmetatable(o, self)
  setmetatable(self, base)
  self.__index = self
  base.__index = base
  
  o.form:newField("answer", "Your promise: ")
  o.form:setSubmitCallback(function(fields) event:fire("minigame.submit", { fields = fields }) end)
  o.form:reset()
  
  o.gui:setPos(100, 600 - 100)
  o.gui:setSize(100, 16)
  o.gui:setAlign("left", "bottom")
  
  o.error = ""
  o.question = "The average person can remember 7 numbers at once. Can you do more?"

  return o
end

function M:draw(g)
  g.print(self.error, 100, self.gui.y - self.gui.height * 4)
  g.print(self.question, 100, self.gui.y - self.gui.height * 2)
  self.gui:draw(g)
end

function M:handleEvent(subType, data, state)
  if subType == "submit" then
    local num = tonumber(data.fields.answer)
    if num then
      state.view = NumberMemoryGame:new()
    else
      self.error = "Answer is not a number!"
      self.form:reset()
    end
  else
    return false
  end
  return true
end

memnumprep = M
return memnumprep