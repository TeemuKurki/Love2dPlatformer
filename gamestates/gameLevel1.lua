--Lisää kirjastot
bump = require 'libs.bump.bump'
Gamestate = require 'libs.hump.gamestate'

-- Lisää entities
local Entities = require 'entities.Entities'
local entity = require 'entities.Entity'

--Luodaan uus tila
local gameLevel1 = Gamestate.new()

-- Lisää Entityt jotka loimme
local Player = require 'entities.player'
local Ground = require 'entities.ground'

--Esitellään tärkeät muuttujat
player = nil
ground = nil


function gameLevel1:enter()
    --Luodaan uusi world jonka laattakoko (tile size) on 16px
    world = bump.newWorld(16)

    --Alustetaan Entity systeemi
    Entities:enter() 
    player = Player(world, 16, 16)
    ground_0 = Ground(world, 120, 360, 640, 16)
    ground_1 = Ground(world, 0, 448, 640, 16)

    --Lisätään instanssi entities:tä Entity listaan
    Entities:addMany({player, ground_0, ground_1})
end

function gameLevel1:update(dt)
    Entities:update(dt)
end

function gameLevel1:draw()
    Entities:draw()
end

return gameLevel1