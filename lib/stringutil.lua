local table = table
local ipairs = ipairs
local M = {}

function M.split(str, delim)
  local result = {}
  local from = 1
  local delimFrom, delimTo = str:find(delim, from)
  while delimFrom do
    result[#result + 1] = str:sub(from, delimFrom - 1)
    from = delimTo + 1
    delimFrom, delimTo = str:find(delim, from)
  end
  result[#result + 1] = str:sub(from)
  return result
end

function M.wrap(str, maxCharCount, wrapStr)
  wrapStr = wrapStr or ""
  assert(wrapStr:len() < maxCharCount)
  
  local lines = {}
  for _, line in ipairs(M.split(str, "\n")) do
    local curLen = 0
    local curLineWords = {}
    
    for _, word in ipairs(M.split(line, " ")) do
      local wasWrap = false
      local wordPart = word
      if wordPart ~= "" then
        while curLen + wordPart:len() > maxCharCount do
          -- If the character AND "-" DON'T fit on the line, move
          -- the character to the next line
          local fitsOnLine = maxCharCount - curLen > 1
          local lineStart = table.concat(curLineWords, " ") .. (curLen > 0 and " " or "")
          local lineEnd = ""
          
          if wordPart:len() > 1 then
            if fitsOnLine then
              lineEnd = wordPart:sub(1, math.max(0, maxCharCount - curLen - 1)) .. "-"
              wordPart = wordPart:sub(maxCharCount - curLen)
            end
          else -- wordpart:len() == 1
            lineEnd = wordPart
            wordPart = ""
          end
          
          lines[#lines + 1] = ("%s%s"):format(lineStart, lineEnd)
          curLineWords = { wrapStr }
          curLen = wrapStr:len() + 1 -- +1: space
          wasWrap = true
        end
      end
      
      curLineWords[#curLineWords + 1] = wordPart
      curLen = curLen + wordPart:len() + 1 -- +1: space
    end
    
    if curLen > 0 then lines[#lines + 1] = table.concat(curLineWords, " ") end
  end
  
  return table.concat(lines, "\n"), #lines
end

function M.toBits(n)
  local t = {}
  while n > 0 do
    local rest = n % 2
    t[#t + 1] = rest
    n = (n - rest) / 2
  end
  for i = #t + 1, 8 do t[i] = 0 end
  return table.concat(t):reverse()
end

function M.strToBits(str, sep)
  sep = sep or ""
  local res = {}
  for ch in str:gmatch(".") do
    res[#res + 1] = M.toBits(string.byte(ch))
  end
  return table.concat(res, sep)
end

function M.bitsToStr(bits)
  local integers = {}
  local byteFormat = ("(%s)"):format(("[01]"):rep(8))
  for binary in bits:gmatch(byteFormat .. "%s?") do
    local integer = tonumber(binary, 2)
    if integer then
      integers[#integers + 1] = integer
    else
      return nil
    end
  end
  if #integers == 0 then return nil end
  local ret = string.char(unpack(integers))
  return ret
end

stringutil = M
return stringutil