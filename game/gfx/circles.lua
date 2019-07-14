local M = { circles = {} }

function M:draw(g, color)
  local col = color or global.accentColor
  for _, circle in ipairs(self.circles) do
    col[4] = circle.alpha
    g.setColor(col)
    g.circle("fill", circle.x, circle.y, circle.radius)
  end
end

function M:update(dt)
  if math.random() < 0.02 then
    local winWidth, winHeight = love.window.getMode()
    local circle = {
      x = math.random(winWidth),
      alpha = math.random() + 0.8,
      radius = math.random(winHeight / 8)
    }
    circle.y = winHeight + circle.radius
    self.circles[#self.circles + 1] = circle
  end
  
  for _, circle in ipairs(self.circles) do
    circle.y = circle.y - dt * 50 * circle.alpha
  end
end

circles = M
return circles