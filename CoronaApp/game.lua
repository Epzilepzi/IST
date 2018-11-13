-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Load Game as Composer Scene
local composer = require( "composer" )
 
local scene = composer.newScene()

-- Load Difficulty Settings
require( "difficulty" )

-- Physics Engine
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Initialize variables
local score = 0
local died = false
local gameOver = false
 
-- Initialize display groups
local backGroup
local mainGroup 
local uiGroup 

local obstacleTable = {}
local player
local floor
local gameLoopTimer
local livesText
local scoreText
local levelText
local powerupTimer

local lives = 3
local score = 0
local level = 1

local playernumber = 1

local fireSpeed = 100

-- Set Game Timer
local time = 300
local powerupTime = 5000

-- Load Assets
local objectSheetOptions =
{
    frames =
    {
        {   -- 1) Internet Explorer
            x = 0,
            y = 0,
            width = 206,
            height = 206,
        },
        {   -- 2) Firefox
            x = 0,
            y = 207,
            width = 206,
            height = 206,
        },
        {   -- 3) Chrome
            x = 0,
            y = 413,
            width = 200,
            height = 200,
        },
        {   -- 4) Opera
            x = 0,
            y = 614,
            width = 200,
            height = 200,
        }
    },
}

local powerUpOptions =
{
    frames =
    {
        { -- 1) Up Firespeed (Chrome)

        }
    }
}

-- Index of Characters
local characters =
{
    { name = "firefox", start = 2, count = 1 },
    { name = "chrome", start = 3, count = 1 },
    { name = "opera", start = 4, count = 1 }
}

local objectSheet = graphics.newImageSheet( "assets/images/gameObjects.png", objectSheetOptions )
local powerUps = graphics.newImageSheet( "assets/images/powerUps.png", powerUpOptions )

-- Create "Enemies"
local function createObstacles()
    local whoDis = math.random( 300 )
    local whereFrom = math.random( 3 )
    local newObstacle
    local newPowerup
    if (whoDis >= 10) then
        newObstacle = display.newImageRect( mainGroup, objectSheet, 1, 200, 200 )
        table.insert( obstacleTable, newObstacle )
        physics.addBody( newObstacle, "dynamic", {radius=100, bounce=0.5, isSensor=true} )
        newObstacle.myName = "enemy"
        if (whereFrom == 1) then
            newObstacle.x = -60
            newObstacle.y = math.random ( 800 )
            newObstacle:setLinearVelocity( math.random( level * 100, level * 150), math.random((level * 2), (level * 100)) )
        elseif (whereFrom == 2) then
            newObstacle.x = math.random (display.contentCenterX - 520, display.contentCenterX + 520)
            newObstacle.y = -60
            newObstacle:setLinearVelocity( 0, math.random( level * 50, level * 200) )
        elseif (whereFrom == 3) then
            newObstacle.x = display.contentWidth + 60
            newObstacle.y = math.random( 800 )
            newObstacle:setLinearVelocity( math.random( level * -150, level * -100), math.random( level * 2, level * 100) )
        end
    else 
        local powerUpNumber = math.random( 2, 4 )
        newPowerup = display.newImageRect( mainGroup, objectSheet, powerUpNumber, 200, 200 )
        table.insert( obstacleTable, newPowerup )
        physics.addBody( newPowerup, "dynamic", {radius=100, bounce=0.5, isSensor=true} )
        if (powerUpNumber == 2) then
            newPowerup.myName = "firefox"
        elseif (powerUpNumber == 3) then
            newPowerup.myName = "chrome"
        elseif (powerUpNumber == 4) then
            newPowerup.myName = "opera"
        end
        print(newPowerup.myName)
        if (whereFrom == 1) then
            newPowerup.x = -60
            newPowerup.y = math.random ( 800 )
            newPowerup:setLinearVelocity( math.random( level * 100, level * 150), math.random((level * 2), (level * 100)) )
        elseif (whereFrom == 2) then
            newPowerup.x = math.random (display.contentCenterX - 520, display.contentCenterX + 520)
            newPowerup.y = -60
            newPowerup:setLinearVelocity( 0, math.random( level * 50, level * 200) )
        elseif (whereFrom == 3) then
            newPowerup.x = display.contentWidth + 60
            newPowerup.y = math.random( 800 )
            newPowerup:setLinearVelocity( math.random( level * -150, level * -100), math.random( level * 2, level * 100) )
        end
        newPowerup:applyTorque( math.random( -100,100 ) )
    end
end

-- Shoot Stuff
local shooting = false

local function fireShit()
    if (shooting == true and died == false) then
        local pew = display.newImageRect( mainGroup, objectSheet, 1, 28, 80 )
        physics.addBody( pew, "dynamic", {isSensor=true} )
        pew.isBullet = true
        pew.myName = "pew"
        pew.x = player.x
        pew.y = player.y
        pew:toBack()
        transition.to( pew, { y=-40, time=500, 
            onComplete = function() display.remove( pew ) end 
        } )
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
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the player
        display.currentStage:setFocus( nil )
        shooting = false
    end
    return true  -- Prevents touch propagation to underlying objects
end

-- Game Loop
local function gameLoop()
    if (gameOver == false) then
        -- Create new obstacle
        createObstacles()
        --[[
        if (level <= 10) then
            createObstacles()
        elseif (level >= 10) then
            createObstacles()
            createObstacles()
        elseif (level >= 20) then
            createObstacles()
            createObstacles()
            createObstacles()
        elseif (level >= 30) then
            createObstacles()
            createObstacles()
            createObstacles()
            createObstacles()
        end
        if time >= 50 then
            time = time - 1
        end ]]--
    end
    -- Remove enemies which have drifted off screen
    for i = #obstacleTable, 1, -1 do
        local thisBoi = obstacleTable[i]
        if ( thisBoi.x < -100 or
             thisBoi.x > display.contentWidth + 100 or
             thisBoi.y < -100 or
             thisBoi.y > display.contentHeight + 100 )
        then
            display.remove( thisBoi )
            table.remove( obstacleTable, i )
        end
    end
    -- Check Score and Level Up?
end

-- Fix player after they dead
local function restorePlayer()
    playernumber = playernumber + 1
-- Testing Stuff  
    if (playernumber == 2) then
        player:setSequence("chrome")
        player:play()
    elseif (playernumber == 3) then
        player:setSequence("opera")
        player:play()
    end 
-- 
    player:play()
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

local function endGame()
    composer.gotoScene( "gameOver", { time=800, effect="crossFade" } )
end

-- Collision Handling
local function onCollision( event )
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2
        -- What to do if the contact stuff is pew and badboi
        if ((obj1.myName == "pew" and obj2.myName == "enemy") or (obj1.myName == "enemy" and obj2.myName == "pew")) then
            -- Remove both the pew and badboi
            display.remove( obj1 )
            display.remove( obj2 )
            -- Remove stuff when boom
            for i = #obstacleTable, 1, -1 do
                if ( obstacleTable[i] == obj1 or obstacleTable[i] == obj2 ) then
                    table.remove( obstacleTable, i )
                    break
                end
            end
            score = score + 100
            scoreText.text = "Score: " .. score
            if (score >= level * 1000) then
                level = level + 1
                levelText.text = "Level: " .. level
                if (time - (level * 10) >= 5) then
                    time = time - (level * 10)
                else 
                    time = 5
                end
            end
        elseif (( obj1.myName == "player" and obj2.myName == "enemy" ) or ( obj1.myName == "enemy" and obj2.myName == "player" )) then
            if (died == false) then
                died = true
                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives
                if (lives == 0) then
                    display.remove(player)
                    -- timer.performWithDelay( 2000, endGame )
                    gameOver = true
                else
                    player.alpha = 0
                    timer.performWithDelay(1000, restorePlayer)
                end
            end
        end
    end
end

--[[ Resets Everything
local function resetGame()
    score = 0
    level = 1
    lives = 3
    fireSpeed = 100
    died = false
    time = 500
    powerupTime = 5000
end
--]]

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view
    
    -- Code here runs when the scene is first created but has not yet appeared on screen
    physics.pause()

    -- Set up display groups
    backGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group
 
    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
 
    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

    -- Load the background
    local background = display.newImageRect( backGroup, "assets/images/background.JPG", 1800, 3200 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY  

    -- Load the Player
    player = display.newSprite( mainGroup, objectSheet, characters )
    player.x = display.contentCenterX
    player.y = display.contentHeight - 200
    physics.addBody( player, "dynamic", {radius=100, isSensor=true,} )
    player.myName = "player"
    player:setSequence("firefox")
    player:play()

    -- Display lives and score
    livesText = display.newText( { parent=uiGroup, text="Lives: " .. lives, x=930, y=100, font=native.systemFont, fontSize=72, align=right } )
    scoreText = display.newText( uiGroup, "Score: " .. score, display.contentCenterX, 125, native.systemFont, 72 )
    levelText = display.newText( uiGroup, "Level: " .. level, 150, 100, native.systemFont, 72 )

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
        powerupTimer = timer.performWithDelay( fireSpeed, fireShit, 0 )
        player:addEventListener( "touch", movePlayer )
        Runtime:addEventListener( "collision", onCollision )
        gameLoopTimer = timer.performWithDelay( time, gameLoop, 0 )
	end
end


-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( gameLoopTimer )
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener( "collision", onCollision )
        physics.pause()
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