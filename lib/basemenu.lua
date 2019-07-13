local tableutil = require "lib.tableutil"
local M = {}

function M:new(o)
  o = o or { entries = {}, spaces = {} }
  setmetatable(o, self)
  self.__index = self
  return o
end

function M:setWrap(isWrap)
  self.isWrap = isWrap
end

function M:newEntry(name, callback, index)
  index = index or #self.entries + 1
  table.insert(self.entries, index, { name = name, callback = callback })
end

function M:newSpace(index)
  index = index or #self.entries + 1
  self.spaces = tableutil.arrayInsertSorted(self.spaces, index)
end

function M:clearEntries()
  self.entries = {}
end

function M:select()
  if self.selected then
    local entry = self.entries[self.selected]
    if entry.callback then entry.callback() end
  end
end

function M:set(index)
  if index > 0 and index <= #self.entries then
    self.selected = index
  else
    self.selected = nil
  end
end

function M:prev()
  if not self.selected then return end
  self.selected = self.selected - 1
  if self.selected == 0 then
    self.selected = self.isWrap and #self.entries or 1
  end
end

function M:next()
  if not self.selected then return end
  self.selected = self.selected + 1
  if self.selected == #self.entries + 1 then
    self.selected = self.isWrap and 1 or #self.entries
  end
end

BaseMenu = M
return BaseMenu