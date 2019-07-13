local menuContinue = require "game.menu.continue"
local Menu = require "lib.menu"
local M = {}

function M:new(data)
  data = data or { num = 0, points = 0 }
  local o = {}
  setmetatable(o, self)
  self.__index = self
  
  o.winWidth, o.winHeight = love.window.getMode()
  o.number = math.random(10 ^ (data.num), 10 ^ (data.num + 1) - 1)
  o.numberX = (o.winWidth - global.titleFont:getWidth(o.number)) / 2
  o.numberY = (o.winHeight - global.titleFont:getHeight()) / 2
  
  o.lineX1 = o.winWidth / 2 - 50
  o.lineX2 = o.winWidth / 2 + 50
  o.lineY = o.winHeight / 2 + 50
  
  o.question = "What was the number?"
  o.questionX = (o.winWidth - global.titleFont:getWidth(o.question)) / 2
  o.questionY = (o.winHeight - global.titleFont:getHeight()) / 2 - 25
  
  o.answer = ""
  o.points = data.points
  
  -- States: show, ask
  o.state = "show"
  
  return o
end

function M:draw(g)
  if self.state == "show" then
    g.setFont(global.titleFont)
    g.print(self.number, self.numberX, self.numberY)
    g.setLineWidth(5)
    g.line(self.lineX1, self.lineY, self.lineX2, self.lineY)
  elseif self.state == "ask" then
    g.setFont(global.titleFont)
    g.print(self.question, self.questionX, self.questionY)
    g.printf(self.answer .. "_", 0, self.winHeight / 2 + 25, self.winWidth, "center")
  end
end

function M:update(dt)
  if self.state == "show" then
    -- 50px / sec
    self.lineX2 = math.max(self.lineX1, self.lineX2 - (50 * dt))
    
    if self.lineX2 == self.lineX1 then
      self.state = "ask"
    end
  end
end

function M:keypressed(key, scancode, isrepeat)
  if self.state == "ask" then
    if key == "backspace" then
      self.answer = self.answer:sub(1, self.answer:len() - 1)
    elseif key == "return" then
      local num = tonumber(self.answer)
      if num == self.number then
        state:verifyContinuation({ num = self.answer:len(), points = self.points + 100 })
      else
        state.points = state.points + self.points
        state:nextGame()
      end
    end
  end
end

function M:textinput(char)
  if self.state == "ask" then
    local num = tonumber(char)
    if num then
      self.answer = self.answer .. char
    end
  end
end

memnumgame = M
return memnumgame