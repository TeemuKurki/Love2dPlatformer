pause = Gamestate.new()

function pause:enter(from)
    self.from = from
end

function pause:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    --piirrä edellinen näyttö
    self.from:draw()

    --Näytä pause viesti
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill",0,0,w,h)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("PAUSE", 0, h/2, w, "center")
end

function pause:keypressed(key)
    if key == "p" then
        return Gamestate.pop()
    end
end

return pause