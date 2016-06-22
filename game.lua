--SkyFall Game by CodeBlooded

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
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY
    local _W = display.contentWidth
    local _H = display.contentHeight

    -- Require the widget library
    local widget = require( "widget" )

    -- Activate physics engine
    local physics = require("physics")
    physics.start()
    physics.setGravity(0,9.8)

    local gameOverGroup = display.newGroup()
    local gameStarted=0


    -- Create master display group (for global "camera" scrolling effect)
    local game = display.newGroup();
    game.x = 0
    game.y=0
    display.setDefault("textureWrapY", "mirroredRepeat")

    --for sky background animation
    local background = display.newRect(display.contentCenterX, display.contentCenterY-80, _W, _H*2)
    background.fill = {type = "image", filename = "color_blur.png" }
    background:toBack()

    local function animateBackground()
        transition.to( background.fill, { time=10000, y=1, delta=true, onComplete=animateBackground } )
    end
    sceneGroup:insert(background)
    local ball

    --animateBackground()

    --for background music and sound effects
    local backgroundMusic,backgroundMusicChannel
    local power_up_music,power_up_music_channel,mine_explode_music,mine_explode_music_channel,game_over_music,game_over_music_channel,level_up_music,level_up_music_channel


    --speed variable

    local speed=1

    --Create walls

    local wall_left,wall_right
    local platformsCreated=0

    --Handle left and right touches

    local function moveLeft()
    		ball:setLinearVelocity(-125,0)
    		ball.setAngularVelocity=40
    end

    local function moveRight()
    		ball:setLinearVelocity(125,0)
    		ball.setAngularVelocity=-40
    end

    --Create Left and Right Buttons


    local leftButton,rightButton
    --scores
    local score
    local scoreDisplay = display.newText( "0", 0, 0, native.systemFont, 25 )
    scoreDisplay.anchorX = 1	-- right
    scoreDisplay.x = display.contentWidth - 25
    scoreDisplay.y = 50
    scoreDisplay:setFillColor(1,1,1)
    score = 0

    local highScore
    local highScoreDisplay = display.newText( "High Score : 0 ", 0, 0, native.systemFontBold, 20 )
    highScoreDisplay.anchorX = 1	-- right
    highScoreDisplay.x = display.contentWidth - 25
    highScoreDisplay.y = 25
    highScoreDisplay:setFillColor(0.6, 0.2, 0.0)
    highScore = 0

    --high score file
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

    local level
    local levelDisplay = display.newText( " Level : 1", 0, 0, native.systemFont, 25 )
    levelDisplay.anchorX = 1	-- right
    levelDisplay.x = display.contentWidth - 25
    levelDisplay.y = 75
    level = 1


    local speed_up_taken_var=0
    local speed_up_timer,mine_explode_timer
    local platforms={}
    local obstacles={}
    local monster
    local monsterOn=math.random(12)+1
    local speed_up
    local speed_up_on=math.random(12)+1
    local nop,k
    nop=1
    local lastPlatform
    k=_H/3.0


    --Create PLatforms

    local function createPlatform( x, y )
    	local platform = display.newImageRect( "platform.png", 140, 32 )
    	game:insert(platform)
    	physics.addBody( platform, "static", { bounce=0, friction=0.7 } )
    	platform.x, platform.y = x, y
    	return platform
    end

    --Monster collision
    local function monsterCollision(event)
      if(event.other.myName=="Ball") then
        if(speed_up_taken_var==1) then
          local new_ball=display.newImage("char.png",-100,-100)
        else
          local new_ball=display.newImage("char_speed_up.png",-100,-100)
        end
        transition.dissolve(ball,ball_new,1000)
        mine_explode_music=audio.loadStream("mine_explode.wav")
        mine_explode_music_channel=audio.play(mine_explode_music,{channel=3})
        power_up_music_channel=audio.setVolume(0.4,{channel=3})
        --mine_explode_timer=timer.performWithDelay(1000,gameOver,2)
        gameOver()
      end
    end


    local power_up_taken_image

    local function end_speed_up()
      print("speed up ended")
      speed_up_taken_var=0
      speed=speed*2
      if ball~=nil then
        ball.gravityScale=ball.gravityScale/1.5
        ball.fill = {type = "image", filename = "char.png" }
        power_up_music_channel=nil
      end
        display.remove(power_up_taken_image)
    end


    local function speed_up_taken(event)
      if(event.other.myName=="Ball") then
        speed_up:removeSelf()
        speed_up=nil
        speed_up_taken_var=1
        print("speed up taken")
        speed=speed/2
        ball.gravityScale=ball.gravityScale*1.5
        speed_up_timer=timer.performWithDelay(5000,end_speed_up,1)
        --transition.dissolve(ball,ball_new,500)
          ball.fill = {type = "image", filename = "char_speed_up.png" }
          power_up_music=audio.loadStream("power_up_taken.mp3")
          power_up_music_channel=audio.play(power_up_music,{channel=2})
          power_up_music_channel=audio.setVolume(0.4,{channel=2})
          power_up_taken_image=display.newImage("speed_up.png",30,35)
     end
    end

    local function initPlatform()
      platformsCreated=1
      monsterOn=math.random(11)+1
      print(monsterOn)
      speed_up_on=math.random(11)+1
      for i=1,12 do
      	local x=-math.random(_W/2)+30
      	platforms[nop]=createPlatform(x,i*k)
        --platforms[nop]:addEventListener("collision",ballTouchesPlatform)
      	nop=nop+1
      	platforms[nop]=createPlatform(x+190,i*k)
        obstacles[i]=display.newImage("Icon-Small.png",x+190+math.random(platforms[1].width-29+29),i*k)
        game:insert(obstacles[i])
        physics.addBody(obstacles[i],"dynamic",{bounce=1,friction=0.7})
        obstacles[i]:setLinearVelocity(0,k)
        if(i==monsterOn) then
          monster=display.newImage("monster.png",math.random(_W),i*k-43)
          game:insert(monster)
          physics.addBody(monster,"static")
          monster:addEventListener("collision",monsterCollision)
        end
        if(i==speed_up_on) then
          speed_up=display.newImage("speed_up.png",math.random(_W),i*k-43)
          game:insert(speed_up)
          physics.addBody(speed_up,"static")
          speed_up:addEventListener("collision",speed_up_taken)
        end
      	nop=nop+1
      	platforms[nop]=createPlatform(x+380,i*k)
      	nop=nop+1
      end
      lastPlatform=platforms[#platforms].y
    end

    local function removeAllPlatforms()
      platformsCreated=0
      for i=1,36 do
        platforms[i]:removeSelf()
        platforms[i]=nil
        if(i%3==0) then
          obstacles[i/3]:removeSelf()
          obstacles[i/3]=nil
        end
        if(i/3==monsterOn) then
          if monster~=nil then
            monster:removeEventListener("collision",monsterCollision)
            monster:removeSelf()
            monster=nil
          end
        end
        if(i/3==speed_up_on) then
          if(speed_up_taken_var==0) then
            if speed_up~=nil then
              speed_up:removeEventListener("collision",speed_up_taken)
              speed_up:removeSelf()
              speed_up=nil
            end
          end
        end
      end
    end



    local levelUpImage
    local function removeImage()
      levelUpImage.isVisible=false
      print("in remove image")
    end
    local function levelUp()
      level_up_music=audio.loadStream("level_up_sound.mp3")
      level_up_music_channel=audio.play(level_up_music,{channel=5})
      level_up_music_channel=audio.setVolume(1.0,{channel=5})
      levelUpImage = display.newText( "Good Going!\nLevel Up!", centerX, centerY,native.systemFont,30)
      levelUpImage.alpha = 0.5
      levelUpImage.xScale = 0.7; levelUpImage.yScale = 0.7
      levelUpImage:setFillColor(1.0, 1.0, 0.0)
      local showGameOver = transition.to( levelUpImage, { alpha=1.0, xScale=1.5, yScale=1.5, time=1000,onComplete=removeImage } )
    end

    --check level up

    local function level_up_check()
      if(score==400 or score==800 or score==1300 ) then
        speed=speed*1.12
        level=level+1
        levelUp()
        levelDisplay.text="Level : ".. level
      elseif(score%(500*math.pow(2,level-1))==0) then
        speed=speed*1.08
        level=level+1
        ball.gravityScale=ball.gravityScale*1.33
        levelUp()
        levelDisplay.text="Level : ".. level
      end

    end



    local currentPlatform=0
    -- Camera follows bolder automatically
    --change speed according to game.y ,i.e., change levels
    local function moveCamera()
      if(gameStarted~=0) then
        --print(game.y.."+"..ball.y)
      -- Checking whether ball is in the screen
        if(ball.y<-game.y-ball.height/2) then
          print("Game over!"..ball.y)
          gameOver()
          return
        --randomizing platforms in a circular queue
        elseif (-game.y-k*2-platforms[currentPlatform*3+1].y)<speed and (-game.y-k*2-platforms[currentPlatform*3+1].y)>=0 then
        	 print("changing")
            local x=-math.random(_W/2)+30
            for l=1,3 do
                platforms[currentPlatform*3+l].y=lastPlatform+k;
                platforms[currentPlatform*3+l].x=x+(l-1)*190;
                if (l==2) then
                    print("changing obstacles"..currentPlatform)
                    obstacles[currentPlatform].y=lastPlatform+k-32;
                    obstacles[currentPlatform].x=x+190+math.random(platforms[1].width-29)+29;
                    obstacles[currentPlatform]:setLinearVelocity(0,k)
                end
            end
            if(monster.y<-game.y-monster.height/2) then
              monster.y=-game.y+_H+k*(math.random(6)+1)-43
              monster.x=math.random(_W)
            end
            if(speed_up_taken_var==0) then
                if speed_up==nil then
                  print("aa gaya main")
                  speed_up=display.newImage("speed_up.png")
                  game:insert(speed_up)
                  physics.addBody(speed_up,"static")
                  speed_up:addEventListener("collision",speed_up_taken)
                elseif(speed_up.y<-game.y-speed_up.height/2) then
                  speed_up.y=-game.y+_H+k*(math.random(6)+1)-43
                  speed_up.x=math.random(_W)
                end
            end
            lastPlatform=platforms[currentPlatform*3+1].y
            print(currentPlatform .."+".. #platforms)
            currentPlatform=currentPlatform+1
            if(currentPlatform%(#platforms/3.0)==0) then
              currentPlatform=1
            end
        end
        	game.y=game.y-speed
          leftButton.y=leftButton.y+speed
          rightButton.y=rightButton.y+speed
          wall_left.y=wall_left.y+speed
          wall_right.y=wall_right.y+speed
        -- Updating scores
        score=score+1;
      	scoreDisplay.text=score
        -- Updating levels
        level_up_check()

      	if(highScore<score) then
      		highScoreDisplay.text="High Score : " .. score
      		highScore=score
      		highScoreDisplay:setFillColor(0.9,0.9,0)
      		scoreDisplay:setFillColor(0.9,0.9,0)
        else
          scoreDisplay:setFillColor(1,1,1)
        end
      end
    end



    local function ballTouchesPlatform(event)
      print("collision")
    	gameStarted=1
      return true
    end

    --Initialize game

    local function init(event)
      gameOverGroup:removeSelf()
      gameOverGroup=nil
      backgroundMusic=audio.stop()
      backgroundMusicChannel=nil
      gameOverGroup=nil
    	print("init")
      nop=1
      game.y=0
      gameStarted=0
      currentPlatform=1
      backgroundMusic=audio.loadStream("bg_music.mp3")
      backgroundMusicChannel=audio.play(backgroundMusic,{channel=1,loops=-1,fadein=5000})
      if(platformsCreated==1) then
        removeAllPlatforms()
      end
      initPlatform()
      Runtime:addEventListener("enterFrame",moveCamera)
    	scoreDisplay.text=score
      ball = display.newImage( "char.png" )
      game:insert(ball)
      physics.addBody( ball, { density=15.0, friction=1, bounce=0,gravity=-100, radius=22 } )
      ball:setLinearVelocity(-100,0)
      ball.x=math.random(_W-10)
      ball.y=100
      ball.gravityScale=1.25
      ball.myName="Ball"
      leftButton = display.newRect(game, 80, -80, _W/2, _H+200)
      game:insert(leftButton)
      leftButton.isVisible = false
      leftButton.isHitTestable = true
      leftButton.anchorY = 0
      leftButton:addEventListener("touch", moveLeft )
      speed_up_taken_var=0
      rightButton = display.newRect( game,_W/2+80, -80, _W/2, _H+200 )
      game:insert(rightButton)
      rightButton.isVisible = false
      rightButton.isHitTestable = true
      rightButton.anchorY = 0
      rightButton:addEventListener("touch",moveRight)
    	score=0
      level=1
      speed=2.5
      scoreDisplay.text=score
      levelDisplay.text="Level : ".. level
      platforms[1]:addEventListener("collision",ballTouchesPlatform)
      platforms[2]:addEventListener("collision",ballTouchesPlatform)
      platforms[3]:addEventListener("collision",ballTouchesPlatform)
      wall_left=display.newImage("wall.png",0,0)
      physics.addBody(wall_left,"static",{friction=0.2, bounce=0.5})
      game:insert(wall_left)
      wall_left.isVisible=false
      wall_right=display.newImage("wall.png",_W,0)
      physics.addBody(wall_right,"static",{friction=0.2, bounce=0.5})
      game:insert(wall_right)
      wall_right.isVisible=false

    end

    --Game over function
    function gameOver()
      game_over_music=audio.loadStream("game_over_sound.mp3")
      game_over_music_channel=audio.play(game_over_music,{channel=4})
      game_over_channel=audio.setVolume(0.4,{channel=4})
      leftButton:removeEventListener("touch",moveLeft)
      rightButton:removeEventListener("touch",moveRight)
      display.remove(power_up_taken_image)
      local path = system.pathForFile( "high_score.txt", system.DocumentsDirectory )
      -- Open the file handle
      local file, errorString = io.open( path, "w" )
      if not file then
          -- Error occurred; output the cause
          print( "File error: " .. errorString )
      else
          -- Read data from file
          file:write( highScore )   
          io.close( file )
      end
      file = nil
      ball:removeSelf()
      ball=nil
      wall_left:removeSelf()
      wall_left=nil
      wall_right:removeSelf()
      wall_right=nil
      leftButton:removeSelf()
      leftButton=nil
      rightButton:removeSelf()
      rightButton=nil
      platforms[1]:removeEventListener("collision",ballTouchesPlatform)
      platforms[2]:removeEventListener("collision",ballTouchesPlatform)
      platforms[3]:removeEventListener("collision",ballTouchesPlatform)
      Runtime:removeEventListener("enterFrame",moveCamera)
    	gameOverGroup = display.newGroup()
    	local overGame = display.newImage( "game_over.png", centerX, centerY, true )
    	gameOverGroup:insert(overGame)
    	overGame.alpha = 0
    	overGame.xScale = 1.5; overGame.yScale = 1.5
    	local showGameOver = transition.to( overGame, { alpha=1.0, xScale=1.0, yScale=1.0, time=500 } )
      local button = widget.newButton(
          {
              width = 240,
              height = 120,
              defaultFile = "play_again.png",
              --overFile = "buttonRedOver.png",
              --label = "Click to restart!",
              onEvent = init
          }
      )
      gameOverGroup:insert(button)
      -- Position the button
      button.x = display.contentCenterX
      button.y = _H-_H/5
    	--overGame:addEventListener("touch",init)
    end

    init()
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
