local menuSelectGame = require "game.menu.selectgame"
local Menu = require "lib.menu"
local M = {}

function M:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self
  
  o.winWidth, o.winHeight = love.window.getMode()
  o.number = math.random(9)
  o.numberX = (o.winWidth - global.titleFont:getWidth(o.number)) / 2
  o.numberY = (o.winHeight - global.titleFont:getHeight()) / 2
  
  o.lineX1 = o.winWidth / 2 - 50
  o.lineX2 = o.winWidth / 2 + 50
  o.lineY = o.winHeight / 2 + 50
  
  o.question = "What was the number?"
  o.questionX = (o.winWidth - global.titleFont:getWidth(o.question)) / 2
  o.questionY = (o.winHeight - global.titleFont:getHeight()) / 2 - 25
  
  o.answer = ""
  
  local base = Menu:new()
  o.betQuestion = "Do you want to continue?"
  o.betMenu = {}
  setmetatable(o.betMenu, base)
  base.__index = base
  
  local event = event
  o.betMenu.menu:newEntry("Yes", function() event:fire("minigame.yes") end)
  o.betMenu.menu:newEntry("No", function() event:fire("minigame.no") end)
  o.betMenu.menu:set(1)
  
  o.betMenu.gui:setPos(o.winWidth /2, o.winHeight / 2 + 50)
  o.betMenu.gui:setSize(global.font:getWidth("[ ] Yes"), global.font:getHeight())
  o.betMenu.gui:setAlign("center", "center")
  
  -- States: show, ask, bet
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
  elseif self.state == "bet" then
    g.setFont(global.font)
    g.printf(self.betQuestion, 0, self.winHeight / 2 - 100, self.winWidth, "center")
    self.betMenu.gui:draw(g)
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
        self.state = "bet"
      else
        state.view = menuSelectGame:new()
      end
    end
  elseif self.state == "bet" then
    self.betMenu:keypressed(key, scancode, isrepeat)
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

function M:handleEvent(subType, data, state)
  if self.state == "bet" then
    if subType == "yes" then
      self.state = "show"
      self.number = math.random(10 ^ (self.answer:len()), 10 ^ (self.answer:len() + 1) - 1)
      self.numberX = (self.winWidth - global.titleFont:getWidth(self.number)) / 2
      self.answer = ""
      self.lineX2 = self.winWidth / 2 + 50
    elseif subType == "no" then
      state.view = menuSelectGame:new()
    else
      return false
    end
    return true
  end
  return false
end

memnumgame = M
return memnumgame