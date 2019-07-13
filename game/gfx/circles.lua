local M = { circles = {} }

function M:draw(g)
  for _, circle in ipairs(self.circles) do
    g.setColor(circle.color)
    g.circle("fill", circle.x, circle.y, circle.radius)
  end
end

function M:update(dt)
  if math.random() < 0.02 then
    local winWidth, winHeight = love.window.getMode()
    local circle = {
      x = math.random(winWidth),
      color = { 240 / 255, 145 / 255, 15 / 255, math.random() * 0.8 },
      radius = math.random(winHeight / 8)
    }
    circle.y = winHeight + circle.radius
    self.circles[#self.circles + 1] = circle
  end
  
  for _, circle in ipairs(self.circles) do
    circle.y = circle.y - dt * 50 * circle.color[4]
  end
end

circles = M
return circles