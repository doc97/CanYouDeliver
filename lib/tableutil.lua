local ipairs = ipairs
local pairs = pairs
local M = {}

function M.arrayInsertSorted(array, value)
  local res = {}
  if #array == 0 then
    res[1] = value
  else
    for i in ipairs(array) do
      if i < value or i == #array then
        table.insert(res, i, value)
        break
      end
    end
  end
  return res
end

function M.sortByKeys(t)
  local keys = {}
  local values = {}
  for k, v in pairs(t) do
    if #values == 0 then
      keys[1] = k
      values[1] = v
    else
      local hasAdded = false
      for i, key in ipairs(keys) do
        if k:upper() < key:upper() then
          table.insert(keys, i, k)
          table.insert(values, i, v)
          hasAdded = true
          break
        end
      end
      if not hasAdded then
        keys[#keys + 1] = k
        values[#values + 1] = v
      end
    end
  end
  return keys, values
end

function M.reverse(t, len)
  len = len or #t
  local res = t
  for i = 1, len / 2 do
    res[i], res[len - i + 1] = res[len - i + 1], res[i]
  end
  return res
end

function M.filter(t, func)
  local res = {}
  for k, v in pairs(t) do
    if func(v) then res[k] = v end
  end
  return res
end

function M.map(t, func)
  local res = {}
  for k, v in pairs(t) do
    res[k] = func(v)
  end
  return res
end

function M.filterKeys(t, func)
  local res = {}
  for k, v in pairs(t) do
    if func(k) then res[k] = v end
  end
  return res
end

function M.mapKeys(t, func)
  local res = {}
  for k, v in pairs(t) do
    res[func(k)] = v
  end
  return res
end

tableutil = M
return tableutil