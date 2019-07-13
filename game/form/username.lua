local Form = require "lib.form"
local M = {}

function M:new()
  local base = Form:new()
  local o = {}
  setmetatable(o, self)
  setmetatable(self, base)
  self.__index = self
  base.__index = base
  
  -- setup form fields
  o.form:newField("username", "Username")
  o.form:setSubmitCallback(function(fields) event:fire("username.submit", fields) end)
  o.form:reset()
  
  -- setup gui properties
  local winWidth, winHeight = love.window.getMode()
  o.gui:setPos(winWidth / 2, winHeight / 2)
  o.gui:setSize(global.font:getWidth("Username: ", global.font:getHeight()))
  o.gui:setAlign("center", "center")
  
  return o
end

function M:draw(g)
  self.gui:draw(g)
end

function M:update(dt) end

username = M
return username