local menuNextGame = require "game.menu.nextgame"
local menuContinue = require "game.menu.continue"
local menuScore = require "game.menu.score"
local menuMain = require "game.menu.main"

local M = { view = {}, points = 0, collectedPoints = 0, nextGameIdx = 0,
  gameCodes = {
    "jumpfinitygame",
    "memnumgame",
    "colorsgame",
  },
  games = {
    jumpfinitygame = { name = "Jump Finity", view = require "game.mini.jumpfinitygame" },
    memnumgame = { name = "Number Memory", view = require "game.mini.memnumgame" },
    colorsgame = { name = "Color Recognition", view = require "game.mini.colorsgame" },
  },
}

function M:reset()
  self.points = 0
  self.collectedPoints = 0
  self.nextGameIdx = 0
end

function M:nextGame()
  self.nextGameIdx = self.nextGameIdx + 1
  
  if self.nextGameIdx <= #M.gameCodes then
    local code = M.gameCodes[self.nextGameIdx]
    local name = M.games[code].name
    self.view = menuNextGame:new({ nextCode = code, nextName = name })
  else
    self.view = menuScore:new({ points = self.points })
  end
end

function M:startGame(code)
  self.view = M.games[M.gameCodes[self.nextGameIdx]].view:new()
end

function M:verifyContinuation(data)
  self.view = menuContinue:new({ game = self:getCurrentCode(), data = data })
end

function M:continueGame(data)
  self.view = M.games[M.gameCodes[self.nextGameIdx]].view:new(data)
end

function M:getCurrentCode()
  return M.gameCodes[self.nextGameIdx]
end

function M:getCurrentName()
  return M.games[self.nextGameIdx].name
end

state = M
return state
