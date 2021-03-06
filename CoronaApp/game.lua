-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

-- Load Game as Composer Scene
local composer = require( "composer" )
 
local scene = composer.newScene()

-- Physics Engine
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local died = false
local gameOver = false
 
-- Initialize display groups
local veryBackGroup
local backGroup
local mainGroup 
local uiGroup 

-- Game Objects
local obstacleTable = {}
local powerupTable = {}
local player
local floor
local gameLoopTimer
local livesText
local scoreText
local levelText
local shootTimer

local difficulty = composer.getVariable( "difficulty" )

-- Game Values (To be loaded based on difficulty settings)

local minTime = composer.getVariable("minTime")

-- HUD
local lives = composer.getVariable("lives")
local score = 0
local level = 1

-- Set Game Timer
local time = composer.getVariable("time")
local powerupTime = composer.getVariable("powerupTime")
local fireTime = composer.getVariable("fireTime")
local fireMode = composer.getVariable("fireMode")

-- PowerUp Settings
local alreadySpawned = 0
local playernumber = composer.getVariable("playernumber")
local shieldHealth = composer.getVariable("shieldHealth")

-- Boss Settings
local bingHealth = composer.getVariable("bingHealth")
local bingSpawned = 0

-- "Fun"
local missed = 0

-- Load Assets
local objectSheetOptions =
{
    frames =
    {
        {   -- 1) Internet Explorer
            x = 0,
            y = 0,
            width = 300,
            height = 300,
        },
        {   -- 2) Firefox
            x = 0,
            y = 300,
            width = 300,
            height = 300,
        },
        {   -- 3) Chrome
            x = 0,
            y = 600,
            width = 300,
            height = 300,
        },
        {   -- 4) Opera
            x = 0,
            y = 900,
            width = 300,
            height = 300,
        },
        {
            -- 5) Edge
            x = 0,
            y = 1200,
            width = 300,
            height = 300,
        },
        {
            -- 6) Safari
            x = 0,
            y = 2546,
            width = 300,
            height = 300,
        },
        {
            -- 7) SQL
            x = 0,
            y = 1500,
            width = 300,
            height = 524,
        },
        {
            -- 8) Javascript
            x = 0,
            y = 2024,
            width = 300,
            height = 522
        }
    },
}

local powerUpOptions =
{
    frames =
    {
        { -- 1) Opera Shield
            x = 0,
            y = 0,
            width = 200,
            height = 63
        },
        { -- 2) Bad boi Java
            x = 0,
            y = 64,
            width = 200,
            height = 200,
        },
        { -- 3) Add Lives (Lua)
            x = 0,
            y = 265,
            width = 200, 
            height = 270,
        }
    }
}

local bingFrames = 
{
    frames = {
        {   -- Bing Stage 1
            x = 0,
            y = 0,
            width = 300,
            height = 300
        },
        {   -- Bing Stage 2
            x = 0,
            y = 300,
            width = 300,
            height = 300
        }
    }
}

-- Index of Characters
local characters =
{
    { name = "firefox", start = 2, count = 1 },
    { name = "chrome", start = 3, count = 1 },
    { name = "opera", start = 4, count = 1 },
    { name = "edge", start = 5, count = 1 },
    { name = "safari", start = 6, count = 1}
}

local bingStates =
{
    { name = "healthy", start = 1, count = 1 },
    { name = "unhealthy", start = 2, count = 1 }
}

local objectSheet = graphics.newImageSheet( "assets/images/gameObjects.png", objectSheetOptions )
local powerUps = graphics.newImageSheet( "assets/images/powerUps.png", powerUpOptions )
local bings = graphics.newImageSheet( "assets/images/bingSheet.png", bingFrames )
local background = "empty"
local backdrop

local function setBackground()
    local ran10 = false
    local ran20 = false
    local ran30 = false
    local ran40 = false
    local ran50 = false
    if (background == "empty") then
        -- Load the background
        background = display.newImageRect( backGroup, "assets/images/xp.jpg", 3730, 3000 )
        background.x = display.contentCenterX
        background.y = display.contentCenterY 
    elseif (level == 10 and ran10 == false) then
        ran10 = true
        backdrop = display.newImageRect( backGroup, "assets/images/vista.jpg", 3730, 3000 )
        backdrop.x = display.contentCenterX
        backdrop.y = display.contentCenterY 
        backdrop.alpha = 0
        transition.fadeIn( backdrop, { time=3000,
            onComplete = function()
                display.remove(background)
            end
        } )
    elseif (level == 20 and ran20 == false) then
        ran20 = true
        background = display.newImageRect( backGroup, "assets/images/7.jpg", 3730, 3000 )
        background.x = display.contentCenterX
        background.y = display.contentCenterY 
        background.alpha = 0
        transition.fadeIn( background, {
            onComplete = function()
                display.remove(backdrop)
            end
        } )
    elseif (level == 35 and ran30 == false) then
        ran30 = true
        backdrop = display.newImageRect( backGroup, "assets/images/8.jpg", 3730, 3000 )
        backdrop.x = display.contentCenterX
        backdrop.y = display.contentCenterY 
        backdrop.alpha = 0
        transition.fadeIn( backdrop, { time=3000,
            onComplete = function()
                display.remove(background)
            end
        } )
    elseif (level == 50 and ran40 == false) then
        ran40 = true
        background = display.newImageRect( backGroup, "assets/images/10.jpg", 3730, 3000 )
        background.x = display.contentCenterX
        background.y = display.contentCenterY 
        background.alpha = 0
        transition.fadeIn( background, {
            onComplete = function()
                display.remove(backdrop)
            end
        } )
    end
    return background
end

-- Fix player after they dead
local function restorePlayer()
    player.isBodyActive = false
    player.x = display.contentCenterX
    player.y = display.contentHeight - 200
    -- Fade in the player
    transition.to( player, { alpha=1, time=4000,
        onComplete = function()
            player.isBodyActive = true
            died = false
        end
    } )
end

local function shieldCollision( self, event )
    local other = event.other
    if (other.myName == "ie11") then
        if (shieldHealth > 0) then
            shieldHealth = shieldHealth - 5
            print("Shield Health: " .. shieldHealth)
        elseif (shieldHealth <= 0) then
            display.remove(self)
        end
    end
end

-- Function which enables the Opera shield
local function opera()
    playernumber = 3
    fireTime = 200
    fireMode = 1
    player:setSequence("opera")
    player:play()
    shootTimer._delay = fireTime
    shield = display.newImageRect(mainGroup, powerUps, 1, 300, 100)
    shield.x = player.x
    shield.y = player.y - 150
    shield.myName = "shield"
    shield.collision = shieldCollision
    shield:addEventListener( "collision" )
    shieldHealth = 100
    physics.addBody(shield, "static")
    return shield
end

local function highScores()
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

-- YOU DIED
local function endGame()
    composer.setVariable( "finalScore", score )
    timer.performWithDelay(1000, highScores, 1)
end

-- When something collides with an enemy
local function onEnemyCollision( self, event )
    local other = event.other
    if (event.other.myName == "pew" and self.myName ~= "bing" and self.myName ~= "java") then 
        display.remove(self)
        display.remove(other)
        for i = #obstacleTable, 1, -1 do
            if ( obstacleTable[i] == self ) then
                table.remove( obstacleTable, i )
                break
            end
        end
        -- Add Score
        score = score + 100
        scoreText.text = "Score: " .. score
    -- Edge is immune to IE, so it won't die when hit.
    elseif (event.other.myName == "player" and self.myName == "ie11") then
        if (playernumber ~= 4) then
            if (died == false) then
                died = true
                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives
                if (lives == 0) then
                    display.remove(other)
                    -- timer.performWithDelay( 2000, endGame )
                    gameOver = true
                    endGame()
                else
                    player.alpha = 0
                    timer.performWithDelay(1000, restorePlayer)
                end
            end
        end
    elseif (self.myName == "bing") then
        if (event.other.myName == "pew" and self.myName == "bing") then 
            if (bingHealth > 1) then
                display.remove(other)
                bingHealth = bingHealth - 1
                if (bingHealth == 1) then
                    bing:setSequence("unhealthy")
                    bing:play()
                end
            elseif (bingHealth == 1) then 
                bingHealth = 0
                display.remove(self)
                display.remove(other)
                for i = #obstacleTable, 1, -1 do
                    if ( obstacleTable[i] == self ) then
                        table.remove( obstacleTable, i )
                        break
                    end
                end
                score = score + 300
                scoreText.text = "Score: " .. score
            end
        elseif (event.other.myName == "player") then
            if (died == false) then
                died = true
                -- Subtract Score
                score = score - 100
                scoreText.text = "Score: " .. score
                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives
                if (lives == 0) then
                    display.remove(other)
                    -- timer.performWithDelay( 2000, endGame )
                    gameOver = true
                    endGame()
                else
                    player.alpha = 0
                    timer.performWithDelay(1000, restorePlayer)
                end
                -- Bing gains more health from your pain.
                bingHealth = bingHealth + 1
                if (bingHealth > 1) then
                    bing:setSequence("healthy")
                    bing:play()
                end
            end
        end
    elseif (self.myName == "java") then
        if (event.other.myName == "pew" and self.myName == "java") then 
            display.remove(other)
            display.remove(self)
            for i = #obstacleTable, 1, -1 do
                if ( obstacleTable[i] == self ) then
                    table.remove( obstacleTable, i )
                    break
                end
            end
            score = score + 200
            scoreText.text = "Score: " .. score
            timer.cancel(javaTimer)
            javaTimer = nil
            java = nil
        elseif (event.other.myName == "player") then
            if (died == false) then
                died = true
                -- Subtract Score
                score = score - 100
                scoreText.text = "Score: " .. score
                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives
                if (lives == 0) then
                    display.remove(other)
                    -- timer.performWithDelay( 2000, endGame )
                    gameOver = true
                    endGame()
                else
                    player.alpha = 0
                    timer.performWithDelay(1000, restorePlayer)
                end
            end
        end
    elseif (self.myName == "js") then
        if (event.other.myName == "pew") then 
            display.remove(other)
            display.remove(self)
            score = score + 50
            scoreText.text = "Score: " .. score
        elseif (event.other.myName == "player") then
            display.remove(self)
            if (died == false) then
                died = true
                -- Subtract Score
                score = score - 100
                scoreText.text = "Score: " .. score
                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives
                if (lives == 0) then
                    display.remove(other)
                    -- timer.performWithDelay( 2000, endGame )
                    gameOver = true
                    endGame()
                else
                    player.alpha = 0
                    timer.performWithDelay(1000, restorePlayer)
                end
            end
        end
    end
    -- Checks if score has reached level up threshold
    if (score >= level * 1000) then
        -- Level Up
        level = level + 1
        levelText.text = "Level: " .. level
        print("Level: " .. level)
        -- Make Game Run Faster
        if (time - 5 >= minTime) then
            time = time - 5
            composer.setVariable("time",time)
            gameLoopTimer._delay = time
        else 
            time = minTime
            composer.setVariable("time",time)
            gameLoopTimer._delay = time
        end
    end
end

local function resetTime()
    time = composer.getVariable("time")
end

local function javaShoot()
    local js = display.newImageRect( mainGroup, objectSheet, 8, 28, 80 )
    physics.addBody( js, "dynamic", {isSensor=true} )
    js.isBullet = true
    js.myName = "js"
    js.x = java.x
    js.y = java.y
    js.collision = onEnemyCollision
    js:addEventListener("collision")
    js:toBack()
    transition.to( js, { y = 2000, time=800, 
        onComplete = function() display.remove( js ) end 
    } )
end

local function onPowerupCollision( self, event )
    local other = event.other
    if (died == false) then
        if (event.other.myName == "pew" or event.other.myName == "player") then
            display.remove(self)
            score = score + 200
            -- Removes event.other if it is pew
            if (event.other.myName == "pew") then
                display.remove(other)
            end
            -- Check what type of powerup self is.
            if (self.myName == "firefox") then
                if (playernumber == 3) then
                    display.remove(shield)
                end
                playernumber = 1
                fireTime = 100
                fireMode = 1
                player:setSequence("firefox")
                player:play()
                shootTimer._delay = fireTime
            elseif (self.myName == "chrome") then
                if (playernumber == 3) then
                    display.remove(shield)
                end
                playernumber = 2
                fireTime = 350
                fireMode = 2
                player:setSequence("chrome")
                player:play()
                shootTimer._delay = fireTime
            elseif (self.myName == "opera") then
                timer.performWithDelay(5, opera, 1)
            elseif (self.myName == "edge") then
                if (playernumber == 3) then
                    display.remove(shield)
                end
                playernumber = 4
                fireTime = 100
                fireMode = 1
                player:setSequence("edge")
                player:play()
                shootTimer._delay = fireTime
            elseif (self.myName == "safari") then
                if (playernumber == 3) then
                    display.remove(shield)
                end
                playernumber = 5
                fireTime = 50
                fireMode = 1
                player:setSequence("safari")
                player:play()
                shootTimer._delay = fireTime
            elseif (self.myName == "lua") then
                display.remove(self)
                lives = lives + 1
                livesText.text = "Lives: " .. lives
            end
            -- Removes Powerup from Table so it doesn't break game.
            for i = #powerupTable, 1, -1 do
                if ( powerupTable[i] == self ) then
                    table.remove( powerupTable, i )
                    break
                end
            end
        end
    end
end

-- Create "Enemies"
local function createObstacles()
    local whoDis = math.random( 300 )
    local whereFrom = math.random( 4 )
    local newObstacle
    local newPowerup
    local randomPosition
    local rand1
    local rand2
    local rand3
    if (difficulty == 1) then
        randomPosition = math.random( 500 )
        rand1 = math.random( level * 10, level * 50 )
        rand2 = math.random( level * -50, level * -10 )
        rand3 = math.random( level * 2, level * 15 )
    elseif (difficulty == 2) then
        randomPosition = math.random( 700 )
        rand1 = math.random( level * 25, level * 75 )
        rand2 = math.random( level * -75, level * -25 )
        rand3 = math.random( level * 2, level * 25 )
    elseif (difficulty == 3) then
        randomPosition = math.random( 900 )
        rand1 = math.random( level * 50, level * 100 )
        rand2 = math.random( level * -100, level * -50 )
        rand3 = math.random( level * 10, level * 50 )
    end
    local rand4 = math.random(display.contentCenterX - 520, display.contentCenterX + 520)
    local powerUpNumber = math.random( 2, 6 )
    if (whoDis > 150 or level < 10 or alreadySpawned > 0 or powerUpNumber == playernumber + 1) then
        newObstacle = display.newImageRect( mainGroup, objectSheet, 1, 200, 200 )
        table.insert( obstacleTable, newObstacle )
        physics.addBody( newObstacle, "dynamic", {radius=100, bounce=0.5} )
        newObstacle.myName = "ie11"
        newObstacle.collision = onEnemyCollision
        newObstacle:addEventListener( "collision" )
        if (whereFrom == 1) then
            newObstacle.x = -60
            newObstacle.y = randomPosition
            newObstacle:setLinearVelocity( rand1, rand3 )
        elseif (whereFrom == 2 or whereFrom == 4) then
            newObstacle.x = rand4
            newObstacle.y = -60
            newObstacle:setLinearVelocity( 0, rand1 )
        elseif (whereFrom == 3) then
            newObstacle.x = display.contentWidth + 60
            newObstacle.y = randomPosition
            newObstacle:setLinearVelocity( rand2, rand3 )
        end
        return newObstacle
    elseif (whoDis > 90 and level > 10 and bingSpawned == 0) then
        bingSpawned = 3
        bingHealth = composer.getVariable("bingHealth")
        bing = display.newSprite( mainGroup, bings, bingStates )
        table.insert( obstacleTable, bing )
        physics.addBody( bing, "dynamic", {radius=100, bounce=0.5, isSensor=true} )
        bing.myName = "bing"
        bing:setSequence("healthy")
        bing:scale((200/300), (200/300))
        bing:play()
        bing.collision = onEnemyCollision
        bing:addEventListener( "collision" )
        if (whereFrom == 1) then
            bing.x = -60
            bing.y = randomPosition
            bing:setLinearVelocity( rand1 * (2/3), rand3 * (2/3) )
        elseif (whereFrom == 2 or whereFrom == 4) then
            bing.x = rand4
            bing.y = -60
            bing:setLinearVelocity( 0, rand1 * (2/3) )
        elseif (whereFrom == 3) then
            bing.x = display.contentWidth + 60
            bing.y = randomPosition
            bing:setLinearVelocity( rand2 * (2/3), rand3  * (2/3))
        end
        print("Lord Bing is Here!")
        print("Bing Health: " .. bingHealth)
        return bing
    elseif (whoDis > 60 and level > 10 and alreadySpawned == 0 and java == nil) then
        alreadySpawned = 5
        java = display.newImageRect( mainGroup, powerUps, 3, 200, 200)
        table.insert( obstacleTable, java )
        physics.addBody( java, "dynamic", {radius=100, bounce=0.5, isSensor=true} )
        java.myName = "java"
        java.collision = onEnemyCollision
        java:addEventListener( "collision" )
        javaTimer = timer.performWithDelay(800, javaShoot, 5)
        if (whereFrom == 1) then
            java.x = -60
            java.y = randomPosition
            java:setLinearVelocity( rand1 * (1/2), rand3 * (1/2) )
        elseif (whereFrom == 2 or whereFrom == 4) then
            java.x = rand4
            java.y = -60
            java:setLinearVelocity( 0, rand1 * (1/2) )
        elseif (whereFrom == 3) then
            java.x = display.contentWidth + 60
            java.y = randomPosition
            java:setLinearVelocity( rand2 * (1/2), rand3  * (1/2))
        end
        print("Java is Here!")
        return java
    else
        local type = math.random(1, 2)
        if (type == 1) then
            newPowerup = display.newImageRect( mainGroup, objectSheet, powerUpNumber, 200, 200 )
            table.insert( powerupTable, newPowerup )
            physics.addBody( newPowerup, "dynamic", {radius=100, bounce=0.5} )
            alreadySpawned = 10
            newPowerup.collision = onPowerupCollision
            newPowerup:addEventListener( "collision" )
            if (powerUpNumber == 2) then
                newPowerup.myName = "firefox"
            elseif (powerUpNumber == 3) then
                newPowerup.myName = "chrome"
            elseif (powerUpNumber == 4) then
                newPowerup.myName = "opera"
            elseif (powerUpNumber == 5) then
                newPowerup.myName = "edge"
            elseif (powerUpNumber == 6) then
                newPowerup.myName = "safari"
            end
        elseif (type == 2) then
            local number = math.random(2, 2)
            newPowerup = display.newImageRect( mainGroup, powerUps, number, 200, 200 )
            table.insert( powerupTable, newPowerup )
            physics.addBody( newPowerup, "dynamic", {radius=100, bounce=0.5} )
            alreadySpawned = 10
            newPowerup.collision = onPowerupCollision
            newPowerup:addEventListener( "collision" )
            if (number == 2) then
                newPowerup.myName = "lua"
            end
        end
        print("Powerup: " .. newPowerup.myName)
        if (whereFrom == 1) then
            newPowerup.x = -60
            newPowerup.y = math.random ( 800 )
            newPowerup:setLinearVelocity( math.random( 100, 300 ), math.random( 2, 200) )
        elseif (whereFrom == 2 or whereFrom == 4) then
            newPowerup.x = math.random (display.contentCenterX - 520, display.contentCenterX + 520)
            newPowerup.y = -60
            newPowerup:setLinearVelocity( 0, math.random( 50, 300) )
        elseif (whereFrom == 3) then
            newPowerup.x = display.contentWidth + 60
            newPowerup.y = math.random( 800 )
            newPowerup:setLinearVelocity( math.random( -150, -100 ), math.random( 50, 150 ) )
        end
        newPowerup:applyTorque( math.random( -100,100 ) )
        return newPowerup
    end
end

-- Counts Down alreadySpawned after powerup spawns
local function alreadySpawnedCount()
    if (alreadySpawned > 0) then
        alreadySpawned = alreadySpawned - 1
    end
    if (bingSpawned > 0) then
        bingSpawned = bingSpawned - 1
    end
end

-- Shoot Stuff
local shooting = false

local function shootThings()
    if (shooting == true and died == false) then
        if (fireMode == 1) then
            local pew = display.newImageRect( mainGroup, objectSheet, 7, 28, 80 )
            physics.addBody( pew, "dynamic", {isSensor=true} )
            pew.isBullet = true
            pew.myName = "pew"
            pew.x = player.x
            pew.y = player.y
            pew:toBack()
            transition.to( pew, { y=-40, time=500, 
                onComplete = function() display.remove( pew ) end 
            } )
            return pew
        elseif (fireMode == 2) then
            local pew1 = display.newImageRect( mainGroup, objectSheet, 7, 28, 80 )
            local pew2 = display.newImageRect( mainGroup, objectSheet, 7, 28, 80 )
            local pew3 = display.newImageRect( mainGroup, objectSheet, 7, 28, 80 )
            pew2.rotation = 5.71
            pew3.rotation = 354.29
            physics.addBody( pew1, "dynamic", {isSensor=true} )
            physics.addBody( pew2, "dynamic", {isSensor=true} )
            physics.addBody( pew3, "dynamic", {isSensor=true} )
            pew1.isBullet = true
            pew2.isBullet = true
            pew3.isBullet = true
            pew1.myName = "pew"
            pew2.myName = "pew"
            pew3.myName = "pew"
            pew1.x = player.x
            pew1.y = player.y
            pew2.x = player.x
            pew2.y = player.y
            pew3.x = player.x
            pew3.y = player.y
            pew1:toBack()
            pew2:toBack()
            pew3:toBack()
            transition.to( pew1, { y=-50, time=1000, 
                onComplete = function() display.remove( pew1 ) end 
            } )
            transition.to( pew2, { x=player.x+500, y=-50, time=1000, 
                onComplete = function() display.remove( pew2 ) end 
            } )
            transition.to( pew3, { x=player.x-500, y=-50, time=1000, 
                onComplete = function() display.remove( pew3 ) end 
            } )
        end
    end
end

local function startFire( event )
    local phase = event.phase
    if ("began" == phase) then
        shooting = true
    elseif ("ended" == phase) then
        shooting = false
    end
end

-- Move Player
local function movePlayer( event )
    local player = event.target
    local phase = event.phase
    if ("began" == phase) then
        -- Make player the focus
        display.currentStage:setFocus( player )
        -- Store initial offset position
        player.touchOffsetX = event.x - player.x
        player.touchOffsetY = event.y - player.y
        shooting = true
    elseif ( "moved" == phase ) then
        -- Move the player to the new touch position
        player.x = event.x - player.touchOffsetX
        player.y = event.y - player.touchOffsetY
        if (playernumber == 3) then
            shield.x = player.x
            shield.y = player.y - 150
        end
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the player
        display.currentStage:setFocus( nil )
        shooting = false
    end
    return true  -- Prevents touch propagation to underlying objects
end

-- Game Loop
local function gameLoop()
    -- Performs Game Loop if not deaded.
    if (gameOver == false and died == false) then
        -- Create new obstacle
        -- createObstacles()
        --
        if (level < 10) then
            createObstacles()
            randomPosition = math.random( 1200 )
        elseif (level >= 10) then
            createObstacles()
            createObstacles()
            setBackground()
        elseif (level >= 20) then
            createObstacles()
            createObstacles()
            createObstacles()
        end
    end
    -- Remove enemies which have drifted off screen
    for i = #obstacleTable, 1, -1 do
        local thisBoi = obstacleTable[i]
        if ( thisBoi.x < -100 or
             thisBoi.x > display.contentWidth + 100 or
             thisBoi.y < -100 or
             thisBoi.y > display.contentHeight + 100 )
        then
            missed = missed + 1
            display.remove( thisBoi )
            table.remove( obstacleTable, i )
            print("Enemies Missed: " .. missed)
        end
    end
    -- Remove powerups which have drifted off into oblivion.
    for i = #powerupTable, 1, -1 do
        local yes = powerupTable[i]
        if ( yes.x < -100 or
             yes.x > display.contentWidth + 100 or
             yes.y < -100 or
             yes.y > display.contentHeight + 100 )
        then
            display.remove( thisBoi )
            table.remove( powerupTable, i )
        end
    end
end

-- Game Timers
gameLoopTimer = timer.performWithDelay( time, gameLoop, 0 )
shootTimer = timer.performWithDelay( fireTime, shootThings, 0 )
spawnTimer = timer.performWithDelay( 1000, alreadySpawnedCount, 0 )

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view
    
    -- Code here runs when the scene is first created but has not yet appeared on screen
    physics.pause()

    -- Set up display groups

    -- veryBackGroup = display.newGroup()  -- Display group for the initial background image
    -- sceneGroup:insert( veryBackGroup )  -- Insert into the scene's view group

    backGroup = display.newGroup()  -- Display group for the dynamic background image(s)
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group
 
    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
 
    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

    setBackground() 

    print(display.contentHeight)

    -- Load the Player
    player = display.newSprite( mainGroup, objectSheet, characters )
    player.x = display.contentCenterX
    player.y = display.contentHeight - 200
    physics.addBody( player, "dynamic", {radius=100, isSensor=true,} )
    player.myName = "player"
    player:setSequence("firefox")
    player:scale((200/300), (200/300))
    player:play()

    -- Display lives and score
    livesText = display.newText( uiGroup, "Lives: " .. lives, display.contentCenterX + 360, 75, native.systemFont, 72, right )
    scoreText = display.newText( uiGroup, "Score: " .. score, display.contentCenterX, 150, native.systemFont, 72, center )
    levelText = display.newText( uiGroup, "Level: " .. level, display.contentCenterX - 360, 75, native.systemFont, 72 )
end


-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        physics.start()
        -- Event Listeners

        -- Listens for touch on player
        local function addPlayerEventListeners()
            player:addEventListener( "touch", startFire )
            player:addEventListener( "touch", movePlayer )
        end

        timer.performWithDelay(5, addPlayerEventListeners, 1)
        -- Listen for collisions
        -- Runtime:addEventListener( "collision", onCollision )
	end
end


-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( gameLoopTimer )
        timer.cancel( shootTimer )
        timer.cancel( spawnTimer )
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        physics.pause()
        composer.removeScene( "game" )
    end

end


-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene

-- -----------------------------------------------------------------------------------