local pairs = pairs
local M = { listeners = {} }

function M:subscribe(listener) if listener then self.listeners[listener] = true end end
function M:unsubscribe(listener) if listener then self.listeners[listener] = nil end end

function M:fire(event, data)
  for listener, _ in pairs(self.listeners) do
    listener(event, data)
  end
end

event = M
return event