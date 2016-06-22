
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
    --title
    local titleText = display.newText({x=screenCenter.x , y=40 , text="SKYFALL" ,fontSize=40,font=native.systemFontBold})
    sceneGroup:insert(titleText)
    titleText:setFillColor(1,1,0.3)
    local titleSubText = display.newText({x=screenCenter.x , y=80 , text="To infinity and beyond!" ,fontSize=25,font=native.systemFontBold})
    sceneGroup:insert(titleSubText)
    titleSubText:setFillColor(1,0.6,0.2)

    --Game Icon
    local icon=display.newImage("Icon-xxxhdpi.png",screenCenter.x , 200)
    sceneGroup:insert(icon)

    --Developed by
    local creditsText = display.newText({x=screenCenter.x ,y=screenHeight/1.5, text="Developed By ," ,fontSize=25,font=native.systemFontBold})
    sceneGroup:insert(creditsText)
    creditsText:setFillColor(1,1,0.3)
    local creditsText1 = display.newText({x=screenCenter.x ,y=screenHeight/1.5+50, text="Aman Mehta" ,fontSize=25,font=native.systemFontBold})
    sceneGroup:insert(creditsText1)
    creditsText1:setFillColor(1,1,0.3)
    local creditsText2 = display.newText({x=screenCenter.x ,y=screenHeight/1.5+50*2, text="Ayush Kumar" ,fontSize=25,font=native.systemFontBold})
    sceneGroup:insert(creditsText2)
    creditsText2:setFillColor(1,1,0.3)
    local creditsText3 = display.newText({x=screenCenter.x ,y=screenHeight/1.5+50*3, text="Bineet Kumar" ,fontSize=25,font=native.systemFontBold})
    sceneGroup:insert(creditsText3)
    creditsText3:setFillColor(1,1,0.3)
    local creditsText4 = display.newText({x=screenCenter.x ,y=screenHeight/1.5+50*4, text="Deepak Jayaprakash" ,fontSize=25,font=native.systemFontBold})
    sceneGroup:insert(creditsText4)
    creditsText4:setFillColor(1,1,0.3)

--Animation 1 function
    local function anim1()
        -- body
        icon.alpha = 0
        icon.xScale = 0.1; icon.yScale = 0.1
        local showGameOver = transition.to( icon, { alpha=1.0, xScale=1.0, yScale=1.0, time=1000 } )
    end
    anim1()

--Loading text
    local loadingText = display.newText({x=screenCenter.x ,y=display.contentHeight+130, text="Loading ..." ,fontSize=25,font=native.systemFontBold})
    loadingText:setFillColor(1,1,1)

--Loading Bar
    local loadingBar = display.newImageRect("loading.png", 400, 45)
    loadingBar.y=display.contentHeight+130
    local loadingBarBack = display.newImageRect("load_behind.png", 800, 45)
    loadingBarBack.y=display.contentHeight+130
    loadingBar:toBack()
    sceneGroup:insert(loadingBarBack)
    sceneGroup:insert(loadingBar)
    sceneGroup:insert(loadingText)

    local function updateProgress(percentage)
        loadingBar.xScale = percentage
    end
    local x = 0.1
    local function fn( )
        -- body
        if(x<=1.8) then
            updateProgress(x)
            local t=x*100/1.8
            local perc=string.format("%4.2f",t)
            loadingText.text="Loading "..perc.."%"
            x=x+0.005
        else
            loadingText.text="Loaded!"
            Runtime:removeEventListener("enterFrame",fn)
            composer.gotoScene( "menu" )
        end
    end
    Runtime:addEventListener("enterFrame",fn)
   
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
