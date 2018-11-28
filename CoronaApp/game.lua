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
local java = false

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
        { -- 2) Slow "Time" (Java)
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

-- Index of Characters
local characters =
{
    { name = "firefox", start = 2, count = 1 },
    { name = "chrome", start = 3, count = 1 },
    { name = "opera", start = 4, count = 1 },
    { name = "edge", start = 5, count = 1 },
    { name = "safari", start = 6, count = 1}
}

local objectSheet = graphics.newImageSheet( "assets/images/gameObjects.png", objectSheetOptions )
local powerUps = graphics.newImageSheet( "assets/images/powerUps.png", powerUpOptions )

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
    print("Shield Health: " .. shieldHealth)
    if (other.myName == "ie11") then
        if (shieldHealth > 0) then
            shieldHealth = shieldHealth - 5
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
    if (event.other.myName == "pew") then 
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
        if (score >= level * 1000) then
            -- Level Up
            level = level + 1
            levelText.text = "Level: " .. level
            print("Level: " .. level)
            -- Make Game Run Faster
            if (time - 5 >= minTime) then
                time = time - 5
                gameLoopTimer._delay = time
            else 
                time = minTime
                gameLoopTimer._delay = time
            end
        end
    elseif (event.other.myName == "player" and playernumber ~= 4) then
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
end

local function onPowerupCollision( self, event )
    local other = event.other
    if (playernumber == 3) then
        display.remove(shield)
    end
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
                playernumber = 1
                fireTime = 100
                fireMode = 1
                player:setSequence("firefox")
                player:play()
                shootTimer._delay = fireTime
            elseif (self.myName == "chrome") then
                playernumber = 2
                fireTime = 350
                fireMode = 2
                player:setSequence("chrome")
                player:play()
                shootTimer._delay = fireTime
            elseif (self.myName == "opera") then
                timer.performWithDelay(5, opera, 1)
            elseif (self.myName == "edge") then
                playernumber = 4
                fireTime = 100
                fireMode = 1
                player:setSequence("edge")
                player:play()
                shootTimer._delay = fireTime
            elseif (self.myName == "safari") then
                playernumber = 5
                fireTime = 50
                fireMode = 1
                player:setSequence("safari")
                player:play()
                shootTimer._delay = fireTime
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
    if (java == true) then
        if (difficulty == 1) then
            randomPosition = math.random( 500 )
        elseif (difficulty == 2) then
            randomPosition = math.random( 700 )
        elseif (difficulty == 3) then
            randomPosition = math.random( 900 )
        end
        rand1 = 100
        rand2 = -100
        rand3 = 25
    elseif (difficulty == 1) then
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
    if (whoDis >= 60 or level < 10 or alreadySpawned > 0 or powerUpNumber == playernumber + 1) then
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
    else
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
    end
end

-- Counts Down alreadySpawned after powerup spawns
local function alreadySpawnedCount()
    if (alreadySpawned > 0) then
        alreadySpawned = alreadySpawned - 1
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
    backGroup = display.newGroup()  -- Display group for the dynamic background image(s)
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group

    veryBackGroup = display.newGroup()  -- Display group for the initial background image
    sceneGroup:insert( veryBackGroup )  -- Insert into the scene's view group
 
    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
 
    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

    -- Load the background
    local background = display.newImageRect( veryBackGroup, "assets/images/xp.png", 4510, 3627 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY  

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
        player:addEventListener( "touch", startFire )
        player:addEventListener( "touch", movePlayer )
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