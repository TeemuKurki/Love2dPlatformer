--Lisää kirjastot
bump = require 'libs.bump.bump'
Gamestate = require 'libs.hump.gamestate'

Camera = require "libs.hump.camera"

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

    player = Player(world, 16, 415)

    Entities:add(player)

    local grounds = { 
        ground_0 = Ground(world, 120, 360, 640, 16),
        ground_1 = Ground(world, 0, 448, 640, 16),
        ground_3 = Ground(world, 0, 200, 640, 16),
        ground_4 = Ground(world, 0, 300, 640, 16)
    }

    camera = Camera(player.x, player.y)

    --Lisätään instanssi entities:tä Entity listaan
    Entities:addMany(grounds)
end

function gameLevel1:update(dt)
    local dx,dy = player.x - camera.x, player.y - camera.y
    camera:lockY( 200 )
    camera:move(dx/2, dy/2)
    Entities:update(dt)
end

function gameLevel1:draw()
    --camera:attach() lisää stackiin framen 1 ja näyttää sen.
    --Entities:draw() piirtää framen 2
    --camera:detach() postaa framen 1 stackistä
    --Toisella loopilla camera:attach() lisää stackiin framen 2 ja näyttää sen.
    -- Jne.

    camera:attach()
    Entities:draw()
    camera:detach()
end

return gameLevel1