bump = require 'libs.bump.bump'

world = nil

ground_0 = {}
ground_1 = {}

-- Asetetaan player objekti 
player = {
    x = 16,
    y = 16,

    -- Nämä ensimäiset attribuutit ovat tärketä jotta fysiikka toimii kuten sen pitää
    xVelocity = 0,
    yVelocity = 0, -- x,y tämän hetkiset nopeudet

    acc = 100, --Pelaajan kiihtyvyys
    maxSpeed = 600, --huippunopeus
    friction = 20, --kitkan määrä
    gravity = 80, --Painovoiman määrä

    --Nämä arvot ovat hyppyjä varten
    isJumping = false, --Hypätäänkö tällähetkellä
    isGrounded = false, --Ollaanko maassa tällähetkellä
    hasReachedMax = false, --Ollaanko niin korkella kuin pystyy
    jumpAcc = 500, --Hypyn kiihtyvyys
    jumpMaxSpeed = 9.5, --Hypyn huppunopeus



    img = nil
}

player.filter = function(item, other)
    local x, y, w, h = world:getRect(other)
    local px, py, pw, ph = world:getRect(item)
    local playerBottom = py + ph
    local otherBotto = y + h

    --Jos pelaajan pohja on korkeammalla (pienempi luku) kuin alustan me palautamma "slide"
    --"slide" on collision tyyppi joka liuttaa pelaaja törmäyksen jälkeen kuten esim super mariossa 
    if playerBottom <= y then
        return "slide"
    end
    --Jos pelaaja ei ole alusta yllä emme palauta mitään jolloin ei tapahdu törmäystä
end

function love.load()
    --Aseta bump
    --16 on meidän laatan koko (tile) 
    world = bump.newWorld(16)

    --Luodaan pelaaja
    player.img = love.graphics.newImage("assets/character_block.png")

    world:add(player, player.x, player.y, player.img:getWidth(), player.img:getHeight())

    --Piirretään taso
    world:add(ground_0, 120, 360, 640, 16)
    world:add(ground_1, 0, 448, 640, 32)   

end

function love.update(dt)
    --Liikutetan pelaajaa velocityn mukaan
    --Yleensä liikutus tapahtuu vasta syötteen tulosta, mutta collision detection toimii paremmin näin päin
    --goalX, goalY on koordiaatiti minne halutaan mennä
    local goalX = player.x + player.xVelocity
    local goalY = player.y + player.yVelocity

    --bump.lua yrittää liikuttaa pelaajaa ja palauttaa koordinaatit, jos ei pysty liikuttaa se palautaa koordinaatit pysähtymisestä
    -- annettii vielä aattribuutti player.filter joka on asetettu ylempänä
    player.x, player.y, collisions, len = world:move(player, goalX, goalY, player.filter)

    --Käydään kaikki törmäykset läpi ja tällähetkellä vain annetaan lupa hypätä uudestaan
    for i, coll in ipairs(collisions) do 
        if coll.touch.y > goalY then
            player.hasReachedMax = true
            player.isGrounded = false
        elseif coll.normal.y < 0 then
            player.hasReachedMax = false
            player.isGrounded = true
        end
    end

    --Aseta kitkan
    --tässä kerrotaan tämän hetkinen velocity luvulla 0 ja 1 väliltä
    --math.min ottaa pienemmän luvun luvuista (dt * player.friction) ja 1, ja asettaa sen kitkan määräksi
    player.xVelocity = player.xVelocity * (1 - math.min(dt * player.friction, 1))
    player.yVelocity = player.yVelocity * (1 - math.min(dt * player.friction, 1))

    --Aseta Painovoima
    player.yVelocity = player.yVelocity + player.gravity * dt

    --Kun liikutaan vasemalle me vähennämme xVelocity:stä ja jun liikutaan oikealle me lisätään siihen
    if love.keyboard.isDown("left", "a") and player.xVelocity > -player.maxSpeed then
        player.xVelocity = player.xVelocity - player.acc * dt
    elseif love.keyboard.isDown("right", "d") and player.xVelocity < player.maxSpeed then
        player.xVelocity = player.xVelocity + player.acc * dt
    end

    --hyppy
    if love.keyboard.isDown("up", "w") then
        if -player.yVelocity < player.jumpMaxSpeed and not player.hasReachedMax then
            player.yVelocity = player.yVelocity - player.jumpAcc * dt
        elseif math.abs(player.yVelocity) > player.jumpMaxSpeed then
            player.hasReachedMax = true
        end

        --Ei kosketa enään maahan
        player.isGrounded = false
    end    
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end

function love.draw(dt)
    love.graphics.draw(player.img, player.x, player.y)
    love.graphics.rectangle("fill", world:getRect(ground_0))
    love.graphics.rectangle("fill", world:getRect(ground_1))
end