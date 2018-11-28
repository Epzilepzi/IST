
local composer = require( "composer" )

local scene = composer.newScene()

local difficulty = 2

local function nextStep()
    composer.setVariable("difficulty", difficulty)
    composer.gotoScene("highscores", { time=500, effect="crossFade" })
end

local function easy()
    difficulty = 1
    print("Difficulty: " .. difficulty)
    nextStep()
end

local function normal()
    difficulty = 2
    print("Difficulty: " .. difficulty)
    nextStep()
end

local function hard()
    difficulty = 3
    print("Difficulty: " .. difficulty)
    nextStep()
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
    composer.removeScene( "highscoresDifficulty" )
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
