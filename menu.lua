
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view
    local screenWidth, screenHeight = display.contentWidth, display.contentHeight
	local screenCenter = { x = screenWidth / 2, y = screenHeight / 2 }
	local background = display.newImageRect( "bg1.png", 720, 1280 )
    background.x = screenWidth / 2
    background.y = screenHeight / 2
    sceneGroup:insert(background)
    local startButton = display.newRoundedRect( screenCenter.x,screenHeight/3 , screenWidth-20, 100 ,20)
    startButton.tapListener = function(event)
        composer.gotoScene("game")
        print("button CLicked")
    end
    sceneGroup:insert(startButton)
    local titleText = display.newText({x=screenCenter.x , y=40 , text="SKYFALL" ,fontSize=40,font=native.systemFontBold})
    startButton:setFillColor(0,0,0)
    sceneGroup:insert(titleText)
    titleText:setFillColor(1,1,0.3)
    local titleSubText = display.newText({x=screenCenter.x , y=80 , text="To infinity and beyond!" ,fontSize=25,font=native.systemFontBold})
    sceneGroup:insert(titleSubText)
    titleSubText:setFillColor(1,0.6,0.2)
    local startText = display.newText({x=screenCenter.x , y=screenHeight/3 , text="NEW GAME" ,fontSize=40,font=native.systemFontBold})
    sceneGroup:insert(startText)
    startText:setFillColor(1,1,0.3)
    startButton:addEventListener( "tap", startButton.tapListener)
    --How To Play Button
    local howToPlayButton = display.newRoundedRect( screenCenter.x, screenHeight/3 +180, screenWidth-20, 100 ,20)
    howToPlayButton:setFillColor(0,0,0)
    howToPlayButton.tapListener = function(event)
        composer.gotoScene("how_to")
    end
    local howToPlayText = display.newText({x=screenCenter.x ,y=screenHeight/3+180, text="HOW TO PLAY" ,fontSize=40,font=native.systemFontBold})
    sceneGroup:insert(howToPlayButton)
    sceneGroup:insert(startText)
    sceneGroup:insert(howToPlayText)
    howToPlayText:setFillColor(1,1,0.3)
    howToPlayButton:addEventListener( "tap", howToPlayButton.tapListener)
    --Credits Button
    --[[local creditsButton = display.newRoundedRect( screenCenter.x, screenHeight/3 +180*2, screenWidth-20, 100 ,20)
    creditsButton:setFillColor(0,0,0)
    creditsButton.tapListener = function(event)
        composer.gotoScene("credits")
    end
    local creditsText = display.newText({x=screenCenter.x ,y=screenHeight/3+180*2, text="CREDITS" ,fontSize=40,font=native.systemFontBold})
    sceneGroup:insert(creditsButton)
    sceneGroup:insert(creditsText)
    creditsText:setFillColor(1,1,0.3)
    creditsButton:addEventListener( "tap", creditsButton.tapListener)
--]]
   --[[ local creditsButton = display.newRoundedRect( 0+100, screenHeight/3 +180*2, (screenWidth-20)/2, 100/2 ,20)
    creditsButton:setFillColor(0,0,0)
    local creditsText = display.newText({x=0+100 ,y=screenHeight/3+180*2, text="option 1" ,fontSize=20,font=native.systemFontBold})
   -- sceneGroup:insert(creditsButton)
    --sceneGroup:insert(creditsText)
    creditsText:setFillColor(1,1,0.3)
    local creditsButton2 = display.newRoundedRect( screenCenter.x+100, screenHeight/3 +180*2, (screenWidth-20)/2, 100/2 ,20)
    creditsButton2:setFillColor(0,0,0)
    local creditsText2 = display.newText({x=screenCenter.x +100,y=screenHeight/3+180*2, text="option 2" ,fontSize=20,font=native.systemFontBold})
    --sceneGroup:insert(creditsButton)
   -- sceneGroup:insert(creditsText)
    creditsText2:setFillColor(1,1,0.3)
    --]]
    --High Score Display
    local highScore
    local highScoreDisplay = display.newText({x=screenCenter.x ,y=screenHeight/3+180*2+80, text="High Score : " ,fontSize=40,font=native.systemFontBold})
    highScoreDisplay:setFillColor(1,1,0.3)
    sceneGroup:insert(highScoreDisplay)
    highScore = 0
    local path = system.pathForFile( "high_score.txt", system.DocumentsDirectory )
    -- Open the file handle
    local file, errorString = io.open( path, "r" )

    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Read data from file
        local contents = file:read( "*a" )
        -- Output the file contents
        print( "Contents of " .. path .. "\n" .. contents )
        -- Close the file handle
        highScore=tonumber(contents)
        highScoreDisplay.text="High Score : " .. highScore
        io.close( file )
    end
    file = nil
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
