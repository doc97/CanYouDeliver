local Menu = require "lib.menu"
local menuContinue = require "game.menu.continue"
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
  keys = { "h", "j", "k", "l" },
}

function M:new(data)
  data = data or {points = 0}
  local base = Menu:new()
  local o = {}
  setmetatable(o, self)
  setmetatable(self, base)
  self.__index = self
  base.__index = base

  o.points = data.points
  -- Flash the color | SHOW
  local winningTextColorIndex = math.random(#M.colorNames)
  o.winningText = M.colorNames[winningTextColorIndex]
  o.winningColorName = M.colorNames[math.random(#M.colorNames)]

  local shitColors = table.clone(M.colorNames)
  table.remove(shitColors, winningTextColorIndex)

  o.allColors = {}
  for i=1, 3 do 
    removedColor = table.remove(shitColors, math.random(#shitColors))
    table.insert(o.allColors, 1, removedColor)
  end 

  -- allColors has 3 colors for the other circles
  -- add the winning one into allColors
  o.correctKeyIndex = math.random(4)
  table.insert(o.allColors, o.correctKeyIndex, o.winningText)

  -- Timer
  o.winWidth, o.winHeight = love.window.getMode()
  o.lineX1 = o.winWidth / 2 - 50
  o.lineX2 = o.winWidth / 2 + 50
  o.lineY = o.winHeight / 2 + 50

  -- gui properties
  o.gui:setPos(o.winWidth / 2, o.winHeight / 2 + 50)
  o.gui:setSize(global.font:getWidth(" [ ] Orange"), global.font:getHeight())
  o.gui:setAlign("center", "center")

  return o
end

-- Quick and dirty hack
function table.clone(org) 
  return {unpack(org)}
end

function M:keypressed(key, scancode, isrepeat)
  if key == M.keys[self.correctKeyIndex] then
    state:verifyContinuation({ points = self.points + 100 })
  else
    state:nextGame()
  end
end

function M:draw(g)
  g.setFont(global.titleFont)
  g.setColor(M.colors[self.winningColorName])
  g.printf(self.winningText, 0, self.winHeight / 2 - 200, self.winWidth, "center")
  g.setFont(global.font)
  for i, colorName in ipairs(self.allColors) do
    local cx = i * self.winWidth / 5
    local cy = self.winHeight / 2 + 100
    local char = M.keys[i]

    g.setColor(M.colors[colorName])
    g.circle("fill", cx, cy, 50)
    g.setColor(0, 0, 0)
    g.printf(char, cx - 50, cy - global.font:getHeight() / 2, 100, "center")
  end
end

function M:update(dt)
  self.lineX2 = math.max(self.lineX1, self.lineX2 - (50 * dt))
  if self.lineX2 == self.lineX1 then
    state:nextGame()
  end
end

colorsgame = M
return colorsgame