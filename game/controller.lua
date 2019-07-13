local state = require "game.state"
local formUsername = require "game.form.username"
local menuMain = require "game.menu.main"
local menuSelectGame = require "game.menu.selectgame"

local M = { func = {} }
local minigames = {
  memnumgame = require "game.mini.memnumgame",
  colorsgame = require "game.mini.colorsgame",
}

function M.func.main(subType, data, state)
  if subType == "newgame" then
    state.view = formUsername:new()
  elseif subType == "quit" then
    love.event.quit()
  else
    return false
  end
  return true
end

function M.func.username(subType, data, state)
  if subType == "submit" then
    if data.username == "" then
      state.view = menuMain:new()
    else
      state.view = menuSelectGame:new()
    end
    return true
  end
  return false
end

function M.func.selectgame(subType, data, state)
  if subType == "game" then
    state.view = minigames[data.name]:new()
  elseif subType == "exit" then
    state.view = menuMain:new()
  else
    return false
  end
  return true
end

function M.func.continue(subType, data, state)
  if subType == "yes" then
    state.view = minigames[data.game]:new(data.data)
  elseif subType == "no" then
    state.points = state.points + data.points
    state.view = menuSelectGame:new()
  else
    return false
  end
  return true
end

function M.func.minigame(subType, data, state)
  if not state.view:handleEvent(subType, data, state) then
    error(("Error processing minigame event %q"):format(subType))
  end
  return true
end

function M.handleEvent(e, data)
  local mainType, subType = e:match("(%a+)%.(%a+)")
  local handler = M.func[mainType]
  
  if not handler then
    error(("Unknown event %q"):format(mainType .. "." .. subType))
  elseif not handler(subType, data, state) then
    error(("Error processing event %q"):format(mainType .. "." .. subType))
  end
end

controller = M
return controller