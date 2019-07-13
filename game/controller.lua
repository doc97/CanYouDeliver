local state = require "game.state"
local menuMain = require "game.menu.main"

local M = { func = {} }

function M.func.main(subType, data, state)
  if subType == "newgame" then
    state:reset()
    state:nextGame()
  elseif subType == "quit" then
    love.event.quit()
  else
    return false
  end
  return true
end

function M.func.nextgame(subType, data, state)
  if subType == "game" then
    state:startGame(data.code)
  elseif subType == "exit" then
    state.view = menuMain:new()
  else
    return false
  end
  return true
end

function M.func.continue(subType, data, state)
  if subType == "yes" then
    state:continueGame(data.data)
  elseif subType == "no" then
    state.points = state.points + data.points
    state:nextGame()
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