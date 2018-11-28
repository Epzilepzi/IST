
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables
local json = require( "json" )
 
local easyScoresTable = {}
local normalScoresTable = {}
local hardScoresTable = {}
 
-- Accesses stored scores in JSON file
local easyFilePath = system.pathForFile( "easyScores.json", system.DocumentsDirectory )
local normalFilePath = system.pathForFile( "normalScores.json", system.DocumentsDirectory )
local hardFilePath = system.pathForFile( "hardScores.json", system.DocumentsDirectory )

local function easyLoadScores()
 
    local file = io.open( easyFilePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        easyScoresTable = json.decode( contents )
    end
 
    if ( easyScoresTable == nil or #easyScoresTable == 0 ) then
        easyScoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    end
end

local function easySaveScores()
 
    for i = #easyScoresTable, 11, -1 do
        table.remove( easyScoresTable, i )
    end
 
    local file = io.open( easyFilePath, "w" )
 
    if file then
        file:write( json.encode( easyScoresTable ) )
        io.close( file )
    end
end

local function normalLoadScores()
 
    local file = io.open( normalFilePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        easyScoresTable = json.decode( contents )
    end
 
    if ( normalScoresTable == nil or #normalScoresTable == 0 ) then
        normalScoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    end
end

local function normalSaveScores()
 
    for i = #normalScoresTable, 11, -1 do
        table.remove( normalScoresTable, i )
    end
 
    local file = io.open( normalFilePath, "w" )
 
    if file then
        file:write( json.encode( normalScoresTable ) )
        io.close( file )
    end
end

local function hardLoadScores()
 
    local file = io.open( hardFilePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        hardScoresTable = json.decode( contents )
    end
 
    if ( hardScoresTable == nil or #hardScoresTable == 0 ) then
        hardScoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    end
end

local function hardSaveScores()
 
    for i = #hardScoresTable, 11, -1 do
        table.remove( hardScoresTable, i )
    end
 
    local file = io.open( hardFilePath, "w" )
 
    if file then
        file:write( json.encode( hardScoresTable ) )
        io.close( file )
    end
end

local function gotoMenu()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	if (composer.getVariable("difficulty") == 1) then
		-- Load the previous scores
		easyLoadScores()
		
		-- Insert the saved score from the last game into the table, then reset it
		table.insert( easyScoresTable, composer.getVariable( "finalScore" ) )
		composer.setVariable( "finalScore", 0 )
		
		-- Sort the table entries from highest to lowest
		local function compare( a, b )
			return a > b
		end
		table.sort( easyScoresTable, compare )
		
		-- Save the scores
		easySaveScores()
	elseif (composer.getVariable("difficulty") == 2) then
		-- Load the previous scores
		normalLoadScores()
		
		-- Insert the saved score from the last game into the table, then reset it
		table.insert( normalScoresTable, composer.getVariable( "finalScore" ) )
		composer.setVariable( "finalScore", 0 )
		
		-- Sort the table entries from highest to lowest
		local function compare( a, b )
			return a > b
		end
		table.sort( normalScoresTable, compare )
		
		-- Save the scores
		normalSaveScores()
	elseif (composer.getVariable("difficulty") == 3) then
		-- Load the previous scores
		hardLoadScores()
		
		-- Insert the saved score from the last game into the table, then reset it
		table.insert( hardScoresTable, composer.getVariable( "finalScore" ) )
		composer.setVariable( "finalScore", 0 )
		
		-- Sort the table entries from highest to lowest
		local function compare( a, b )
			return a > b
		end
		table.sort( hardScoresTable, compare )
		
		-- Save the scores
		hardSaveScores()
	end

	local background = display.newImageRect( sceneGroup, "assets/images/menu.jpg", 4510, 3627 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
     
	local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 150, native.systemFont, 144 )
	local levelHeader

	if (composer.getVariable("difficulty") == 1) then
		levelHeader = display.newText( sceneGroup, "Easy Difficulty", display.contentCenterX, 325, native.systemFont, 80 )
	elseif (composer.getVariable("difficulty") == 2) then
		levelHeader = display.newText( sceneGroup, "Normal Difficulty", display.contentCenterX, 325, native.systemFont, 80 )
	elseif (composer.getVariable("difficulty") == 3) then
		levelHeader = display.newText( sceneGroup, "Hard Difficulty", display.contentCenterX, 325, native.systemFont, 80 )
	end

	local backToMenu = display.newText( sceneGroup, "Back to Menu", display.contentCenterX, display.contentHeight - 100, native.systemFont, 72 )
	backToMenu:addEventListener( "tap", gotoMenu )
	if (composer.getVariable("difficulty") == 1) then
		for i = 1, 10 do
			if ( easyScoresTable[i] ) then
				local yPos = 350 + ( i * 120 )
	
				local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 80, center )
				-- rankNum:setFillColor( 0.8 )
				rankNum.anchorX = 1
	
				local thisScore = display.newText( sceneGroup, easyScoresTable[i], display.contentCenterX-30, yPos, native.systemFont, 80, center )
				thisScore.anchorX = 0
			end
		end
	elseif (composer.getVariable("difficulty") == 2) then
		for i = 1, 10 do
			if ( normalScoresTable[i] ) then
				local yPos = 350 + ( i * 120 )
	
				local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 72, center )
				-- rankNum:setFillColor( 0.8 )
				rankNum.anchorX = 1
	
				local thisScore = display.newText( sceneGroup, normalScoresTable[i], display.contentCenterX-30, yPos, native.systemFont, 72, center )
				thisScore.anchorX = 0
			end
		end
	elseif (composer.getVariable("difficulty") == 3) then	
		for i = 1, 10 do
			if ( hardScoresTable[i] ) then
				local yPos = 350 + ( i * 120 )
	
				local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 72, center )
				-- rankNum:setFillColor( 0.8 )
				rankNum.anchorX = 1
	
				local thisScore = display.newText( sceneGroup, hardScoresTable[i], display.contentCenterX-30, yPos, native.systemFont, 72, center )
				thisScore.anchorX = 0
			end
		end
	end
end


-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
end


-- hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "did" ) then
		-- Removes scene when going to new scene
		composer.removeScene( "highscores" )
	end
end


-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view
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
