local event = require "lib.event"
local state = require "game.state"
local controller = require "game.controller"
local menuMain = require "game.menu.main"

global = {}

function love.load()
  -- Initialize random
  math.randomseed(os.time())
  math.random() math.random() math.random()
  
  -- Disable stdout buffering
  io.stdout:setvbuf("no")
  
  -- Load fonts
  global.titleFont = love.graphics.newFont("assets/fonts/RobotoMono-Regular.ttf", 64)
  global.font = love.graphics.newFont("assets/fonts/RobotoMono-Regular.ttf", 36)
  
  global.defaultColor = { 120 / 255, 120 / 255, 120 / 255 }
  
  -- Setup window
  love.window.setMode(1920, 1080, { fullscreen = true })
  
  -- Register event handler
  event:subscribe(controller.handleEvent)
  
  -- Initialize state
  state.view = menuMain:new()
end

function love.draw()
  love.graphics.clear(253 / 255, 246 / 255, 228 / 255)
  love.graphics.setColor(global.defaultColor)
  state.view:draw(love.graphics)
end

function love.update(dt)
  state.view:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
  state.view:keypressed(key, scancode, isrepeat)
end

function love.textinput(char)
  state.view:textinput(char)
end
