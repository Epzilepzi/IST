
local composer = require( "composer" )

local scene = composer.newScene()

local difficulty = 2

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
    -- Set Up Global Variables for Game
	composer.setVariable("difficulty", difficulty)
	composer.setVariable("minTime", minTime)
	composer.setVariable("lives", lives)
	composer.setVariable("time", gameTime)
	composer.setVariable("powerupTime", powerupTime)
	composer.setVariable("fireTime", fireTime)
	composer.setVariable("fireMode", fireMode)
	composer.setVariable("playernumber", playernumber)
    composer.setVariable("shieldHealth", shieldHealth)
    print(composer.getVariable("difficulty"))
    print(composer.getVariable("minTime"))
    print(composer.getVariable("lives"))
    print(composer.getVariable("time"))
    print(composer.getVariable("powerupTime"))
    print(composer.getVariable("fireTime"))
    print(composer.getVariable("fireMode"))
    print(composer.getVariable("playernumber"))
    print(composer.getVariable("shieldHealth"))
	composer.gotoScene("game", { time=500, effect="crossFade" })
end

-- Setup Difficulty Settings
local function setUpGame()
    if (difficulty == 1) then
        -- Load Difficulty Settings
        minTime = 50

        -- HUD
        lives = 3

        -- Set Game Timer
        gameTime = 500
        powerupTime = 3000
        fireTime = 100
        fireMode = 1

        -- PowerUp Settings
        playernumber = 1
        shieldHealth = 200
    elseif (difficulty == 2) then
        -- Load Difficulty Settings
        minTime = 1

        -- HUD
        lives = 3

        -- Set Game Timer
        gameTime = 400
        powerupTime = 5000
        fireTime = 100
        fireMode = 1

        -- PowerUp Settings
        playernumber = 1
        shieldHealth = 100
	end
	gotoGame()
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	local background = display.newImageRect( sceneGroup, "assets/images/background.png", 4510, 3627 )
    background.x = display.contentCenterX
	background.y = display.contentCenterY

	local header = display.newText( sceneGroup, "Select Difficulty", display.contentCenterX, 150, native.systemFont, 144 )

	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, display.contentCenterY, native.systemFont, 88 )
    playButton:setFillColor( 0.82, 0.86, 1 )

	playButton:addEventListener( "tap", setUpGame )
	
end


--[[ show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end
]]--

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
