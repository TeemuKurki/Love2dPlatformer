-- Esittää yhtä renderöitävää objectia
local Class = require 'libs.hump.class'

local Entity = Class{}

function Entity:init(world, x, y, w, h)
    self.world = world
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function Entity:getRect()
    return self.x, self.y, self.w, self.h
end

function Entity:draw()
    --Ei tehdä mitään defaulttina, mutta meillä pitää silti olla jotain mitä kutsua
end

function Entity:update(dt)
    --Ei tehdä mitään defaulttina, mutta meillä pitää silti olla jotain mitä kutsua
end

return Entity