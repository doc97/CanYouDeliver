local Menu = require("lib.menu")
local M = {
  colors = {
    red = { 1, 0, 0 },
    green = { 0, 1, 0 },
    blue = { 0, 0, 1},
    orange = { 1, 165/255, 0 }, 
    purple = { 128/255, 0, 128/255 },
    yellow = { 1, 1, 0 },
    grey = { 105/255, 105/255, 105/255 }
  },
  colorNames = { "red", "green", "blue", "orange", "purple", "yellow", "grey" },
}

function M:new()
  local base = Menu:new()
  local o = {}
  setmetatable(o, self)
  setmetatable(self, base)
  self.__index = self
  base.__index = base
 
  -- Flash the color | SHOW
  local randomColorIndex = math.random(#M.colorNames)
  local randomColorKey = M.colorNames[randomColorIndex]
  o.winningText = M.colorNames[math.random(#M.colorNames)]
  o.winningColor = M.colors[randomColorKey]

  local shitColors = table.clone(colorNames)
  table.remove(shitColors, randomColorIndex)
  
  o.bastardColors = []

  for i=1, 3 do 
    removedColor = table.remove(shitColors, math.random(#shitColors))
    table.insert(o.bastardColors, -1, removedColor)
  end 
  -- Timer
  o.winWidth, o.winHeight = love.window.getMode()
  o.lineX1 = o.winWidth / 2 - 50
  o.lineX2 = o.winWidth / 2 + 50
  o.lineY = o.winHeight / 2 + 50

  -- Bet menu | BET
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

  -- gui properties
  local winWidth, winHeight = love.window.getMode()
  o.gui:setPos(winWidth / 2, winHeight / 2 + 50)
  o.gui:setSize(global.font:getWidth(" [ ] Orange"), global.font:getHeight())
  o.gui:setAlign("center", "center")


  -- title
  -- o.title = "Select the color the text names: "
  -- o.titleWidth = global.titleFont:getWidth(o.title)

  -- States: show, bet
  o.state = "show"

  return o
end

-- Quick and dirty hack
function table.clone(org) 
  return {table.unpack(org)}
end

function M:draw(g)
  if self.state == "show" then
    g.setFont(global.titleFont)
    g.setColor(self.randomColor)
    g.printf(self.randomText, 0, self.winHeight / 2 - 100, self.winWidth, "center")
  elseif self.state == "bet" then
    g.setFont(global.font)
    g.printf(self.betQuestion, 0, self.winHeight / 2 - 100, self.winWidth, "center")
    self.betMenu.gui:draw(g)
  end
end
-- TODO Change 
function M:update(dt)
  if self.state == "show" then 
    self.lineX2 = math.max(self.lineX1, self.lineX2 - (50 * dt))
    if self.lineX2 == self.lineX1 then 
      self.state = "ask"
    end
  end
end

colorsgame = M
return colorsgame