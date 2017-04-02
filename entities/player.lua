local Class = require("libs.hump.class")
local Entity = require("entities.Entity")

local Player = Class{
    --Player luokka perii Entity luokan
    _includes = Entity
}

function Player:init(world, x, y)
    self.img = love.graphics.newImage("/assets/character_block.png")

    Entity:init(self, world, x, y, self.img:getWidth(), self.img:getHeigth())

    --Uniikit attribuutit Player objectille
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
    jumpMaxSpeed = 11, --Hypyn huppunopeus

    --self.getRect() palauttaa x, y, w, h
    self.world:add(self, self.getRect())
end

function Player:collisionFilter(other)
    local x, y, w, h = self.world:getRect(other)
    local playerBottom = self.y, self.h
    local otherBottom = y, h

    --Jos pelaajan pohja on korkeammalla (pienempi luku) kuin alustan me palautamma "slide"
    --"slide" on collision tyyppi joka liuttaa pelaaja törmäyksen jälkeen kuten esim super mariossa 
    if playerBottom <= y then
        return "slide"
    end
end

function Player:update(dt)
    local prevX, prevY = self.x, self.y

    --Aseta kitkan
    --tässä kerrotaan tämän hetkinen velocity luvulla 0 ja 1 väliltä
    --math.min ottaa pienemmän luvun luvuista (dt * self.friction) ja 1, ja asettaa sen kitkan määräksi
    self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))
    self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))

    --Aseta Painovoima
    self.yVelocity = self.yVelocity + self.gravity * dt

    --Kun liikutaan vasemalle me vähennämme xVelocity:stä ja jun liikutaan oikealle me lisätään siihen
    if love.keyboard.isDown("left", "a") and self.xVelocity > -self.maxSpeed then
        self.xVelocity = self.xVelocity - self.acc * dt
    elseif love.keyboard.isDown("right", "d") and self.xVelocity < self.maxSpeed then
        self.xVelocity = self.xVelocity + self.acc * dt
    end

    --hyppy
    if love.keyboard.isDown("up", "w") then
        if -self.yVelocity < self.jumpMaxSpeed and not self.hasReachedMax then
            self.yVelocity = self.yVelocity - self.jumpAcc * dt
        elseif math.abs(self.yVelocity) > self.jumpMaxSpeed then
            self.hasReachedMax = true
        end
        --Ei kosketa enään maahan
        self.isGrounded = false
    end

     --Liikutetan pelaajaa velocityn mukaan
    --Yleensä liikutus tapahtuu vasta syötteen tulosta, mutta collision detection toimii paremmin näin päin
    --goalX, goalY on koordiaatiti minne halutaan mennä
    local goalX = self.x + self.xVelocity
    local goalY = self.y + self.yVelocity

    --bump.lua yrittää liikuttaa pelaajaa ja palauttaa koordinaatit, jos ei pysty liikuttaa se palautaa koordinaatit pysähtymisestä
    -- annettii vielä aattribuutti self.collisionFilter joka on asetettu ylempänä
    self.x, self.y, collisions, len = world:move(self, goalX, goalY, self.collisionFilter)

    --Käydään kaikki törmäykset läpi ja tällähetkellä vain annetaan lupa hypätä uudestaan
    for i, coll in ipairs(collisions) do 
        if coll.touch.y > goalY then
            self.hasReachedMax = true
            self.isGrounded = false
        elseif coll.normal.y < 0 then
            self.hasReachedMax = false
            self.isGrounded = true
        end
    end 
end

function Player:draw()
    love.graphics.draw(self.img, self.x, self.y)
end

return Player