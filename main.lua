--Hae gamestate hump kirjastota
Gamestate = require 'libs.hump.gamestate'

--Hae tarvittavat tilat
local mainMenu = require 'gamestates.mainmenu'
local gameLevel1 = require 'gamestates.gameLevel1'
local pause = require 'gamestates.pause'

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(gameLevel1)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end

--love.update ja love.draw funktioita ei tarviste kirjoittaa, koska nämä löytyvät Gamestate tiedostosta