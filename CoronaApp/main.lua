-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Physics Engine
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Seed the random number generator
math.randomseed( os.time() )

-- Initialize variables
local score = 0
local dead = false
 
local obstacleTable = {}
local player
local floor
local gameLoopTimer
local livesText
local scoreText
local levelText

local lives = 3
local score = 0
local level = 1

local time = 3000 - (level * 2)
local fireSpeed = 100

-- Load Assets
local sheetOptions =
{
    frames =
    {
        {   -- 1) Cordial
            x = 0,
            y = 0,
            width = 756,
            height = 756,
        },
        {   -- 2) Firefox
            x = 0,
            y = 756,
            width = 462,
            height = 461,
        },
    },
}

local objectSheet = graphics.newImageSheet( "assets/images/gameObjects.png", sheetOptions )

-- Set up display groups
local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for the player, Obstacles, lasers, etc.
local uiGroup = display.newGroup()    -- Display group for UI objects like the score

-- Load the background
local background = display.newImageRect( backGroup, "assets/images/background.JPG", 1080, 1920 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- Load the Player
player = display.newImageRect( mainGroup, objectSheet, 2, 200, 200 )
player.x = display.contentCenterX
player.y = display.contentHeight - 200
physics.addBody( player, "kinematic", {radius=100, isSensor=true,} )
player.myName = "player"

-- Load Floor
floor = display.newRect( mainGroup, display.contentHeight, display.contentCenterX, 1, display.contentWidth)
physics.addBody( floor, "static", {radius=40} )

-- Display lives and score
livesText = display.newText( { parent=uiGroup, text="Lives: " .. lives, x=900, y=150, font=native.systemFont, fontSize=72, align=right } )
scoreText = display.newText( uiGroup, "Score: " .. score, display.contentCenterX, 150, native.systemFont, 72 )
levelText = display.newText( uiGroup, "Level: " .. level, 180, 150, native.systemFont, 72 )

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Create "Enemies"
local function createObstacles()
    local newObstacle = display.newImageRect( mainGroup, objectSheet, 1, 200, 200 )
    table.insert( obstacleTable, newObstacle )
    physics.addBody( newObstacle, "kinematic", {radius=100, bounce=0.5} )
    newObstacle.name = Enemy
    local whereFrom = math.random( 3 )
    if (whereFrom == 1) then
        newObstacle.x = -60
        newObstacle.y = math.random ( 200 )
        newObstacle:setLinearVelocity( math.random( level * 100, level * 150), math.random((level * 0), (level * 100)) )
    elseif (whereFrom == 2) then
        newObstacle.x = math.random (display.contentWidth)
        newObstacle.y = -60
        newObstacle:setLinearVelocity( 0, math.random( level * 50, level * 200) )
    elseif (whereFrom == 3) then
        newObstacle.x = display.contentWidth + 60
        newObstacle.y = math.random( 200 )
        newObstacle:setLinearVelocity( math.random( level * -150, level * -100), math.random( level * 0, level * 100) )
    end
    -- newObstacle:applyTorque( math.random( -10,10 ) )
end

-- Shoot Stuff
local shooting = false

local function fireShit()
    if (shooting == true) then
        local pew = display.newImageRect( mainGroup, objectSheet, 1, 28, 80 )
        physics.addBody( pew, "dynamic", {isSensor=true} )
        pew.isBullet = true
        pew.myName = "pew pew"
        pew.x = player.x
        pew.y = player.y
        pew:toBack()
        transition.to( pew, { y=-40, time=500, 
            onComplete = function() display.remove( newLaser ) end 
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

-- Listens for touch on player
player:addEventListener( "touch", startFire )

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
    elseif ( "moved" == phase ) then
        -- Move the player to the new touch position
        player.x = event.x - player.touchOffsetX
        player.y = event.y - player.touchOffsetY
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the player
        display.currentStage:setFocus( nil )
    end
    return true  -- Prevents touch propagation to underlying objects
end

player:addEventListener( "touch", movePlayer )

-- Game Loop
local function gameLoop()
 
    -- Create new obstacle
    createObstacles()
    if time >= 50 then
        time = time - 1
    end

end

-- Game Loop Timer
gameLoopTimer = timer.performWithDelay( time, gameLoop, 0 )
shootTimer = timer.performWithDelay( fireSpeed, fireShit, 0 )