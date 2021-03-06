
local composer = require( "composer" )

local scene = composer.newScene()

composer.setVariable( "finalScore", 0 )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoDiff()
    composer.gotoScene( "difficulty", { time=500, effect="crossFade" } )
end
 
local function gotoHighScores()
    composer.gotoScene( "highscoreDifficulty", { time=800, effect="crossFade" } )
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

	composer.setVariable("background", background)
	
	local title = display.newImageRect( sceneGroup, "assets/images/title.png", 1000, 160 )
    title.x = display.contentCenterX
	title.y = 400
	
	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, display.contentCenterY, native.systemFont, 88 )
    playButton:setFillColor( 1 )
 
    local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, display.contentHeight - 100, native.systemFont, 88 )
    highScoresButton:setFillColor( 1 )

	playButton:addEventListener( "tap", gotoDiff )
	highScoresButton:addEventListener( "tap", gotoHighScores )
	
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
	composer.removeScene( "menu" )

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
