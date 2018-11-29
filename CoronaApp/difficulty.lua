
local composer = require( "composer" )

local scene = composer.newScene()

local difficulty = 2

local function gotoMenu()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

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
    composer.setVariable("bingHealth", bingHealth)
    print("Difficulty: " .. composer.getVariable("difficulty"))
	composer.gotoScene("game", { time=500, effect="crossFade" })
end

-- Setup Difficulty Settings
local function setUpGame()
    if (difficulty == 1) then
        -- Load Difficulty Settings
        minTime = 200

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

        -- Boss Settings
        bingHealth = 2
    elseif (difficulty == 2) then
        -- Load Difficulty Settings
        minTime = 100

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

        -- Boss Settings
        bingHealth = 2
    elseif (difficulty == 3) then
        -- Load Difficulty Settings
        minTime = 150

        -- HUD
        lives = 3

        -- Set Game Timer
        gameTime = 300
        powerupTime = 5000
        fireTime = 100
        fireMode = 1

        -- PowerUp Settings
        playernumber = 1
        shieldHealth = 50

        -- Boss Settings
        bingHealth = 3
	end
	gotoGame()
end

local function easy()
    difficulty = 1
    setUpGame()
    print("Difficulty: " .. difficulty)
end

local function normal()
    difficulty = 2
    setUpGame()
    print("Difficulty: " .. difficulty)
end

local function hard()
    difficulty = 3
    setUpGame()
    print("Difficulty: " .. difficulty)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	local background = display.newImageRect( sceneGroup, "assets/images/menu.jpg", 4510, 3627 )
    background.x = display.contentCenterX
	background.y = display.contentCenterY

	local header = display.newText( sceneGroup, "Select Difficulty", display.contentCenterX, 150, native.systemFont, 144 )

    local easyButton = display.newText( sceneGroup, "Easy", display.contentCenterX, display.contentCenterY - 150, native.systemFont, 100 )
    easyButton:setFillColor( 1 )
    easyButton:addEventListener( "tap", easy )

	local normalButton = display.newText( sceneGroup, "Normal", display.contentCenterX, display.contentCenterY, native.systemFont, 100 )
    normalButton:setFillColor( 1 )
    normalButton:addEventListener( "tap", normal )

    local hardButton = display.newText( sceneGroup, "Hard", display.contentCenterX, display.contentCenterY + 150, native.systemFont, 100 )
    hardButton:setFillColor( 1 )
    hardButton:addEventListener( "tap", hard )

    local backToMenu = display.newText( sceneGroup, "Back to Menu", display.contentCenterX, display.contentHeight - 100, native.systemFont, 72 )
	backToMenu:addEventListener( "tap", gotoMenu )
	
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
    composer.removeScene( "difficulty" )
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
