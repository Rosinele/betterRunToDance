
local composer = require( "composer" )

local scene = composer.newScene()

local largura = display.contentWidth

local altura = display.contentHeight

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local backgroundMusic = audio.loadStream( "sons/menu.mp3" )

local function gotoGame()
	composer.gotoScene( "modo" )
	audio.pause()
end

local function gotoNivel()
	composer.gotoScene("niveis")
	audio.pause()
end

local function gotoCredito()
	composer.gotoScene("creditos")
	audio.pause()
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------



-- create()

function scene:create( event )

	local sceneGroup = self.view
	audio.play( backgroundMusic )
	-- Code here runs when the scene is first created but has not yet appeared on screen

	--local physics = require( "physics" )
	--physics.start()
	--physics.setGravity(0, 9.8)]]
	
 	local background = display.newImageRect(sceneGroup, "img/base/background.png", 1920, 1080)
	background.x = largura/2
	background.y = altura/4
	background.yScale = 0.5
	background.xScale = 0.5

	local chao = display.newImageRect( sceneGroup, "img/menu/chao.png", 1920, 144) --https://pixabay.com/
	chao.x = 0
	chao.y = altura 
	chao.yScale = 0.5
	--physics.addBody( chao, "static", {bounce=0} )

	local sheetOptions = { width = 67.4, height = 74, numFrames = 20 }
	local sheet = graphics.newImageSheet("img/base/bailar.png", sheetOptions )
	 
	--definimos uma animação (sequence)
	local sequences = {
	    {
	        name = "normalRun",
	        start = 1,
	        count = 20,
	        time = 350,
	        loopCount = 0,
	        loopDirection = "forward"
	    }
	}

	local running = display.newSprite( sheet, sequences )
	--physics.addBody(running, "dynamic", {radius=15, bounce=0})
	running.myName = "running"
	running.x = display.contentWidth / 4 + 40
	running.y = 255
	running:play()
	running.isVisible = true;
	sceneGroup:insert(running)

	local title = display.newImageRect( sceneGroup, "img/menu/titulo.png", 485, 421 )
    title.x = largura/4
	title.y = altura/2 - 60
	title.yScale = 0.4
	title.xScale = 0.4
    
    local playButton = display.newImageRect( sceneGroup, "img/menu/jogar.png" , 277, 98 )
    playButton.x = largura/2 + 120
	playButton.y = altura - 170
	playButton.yScale = 0.4
	playButton.xScale = 0.4
	playButton:addEventListener( "tap", gotoGame )

	local niveis = display.newImageRect( sceneGroup, "img/menu/niveis.png" , 277, 98 )
    niveis.x = largura/2 + 120
	niveis.y = altura - 120
	niveis.yScale = 0.4
	niveis.xScale = 0.4
	niveis:addEventListener("tap", gotoNivel)

	local creditos = display.newImageRect( sceneGroup, "img/menu/sobre.png" , 277, 98 )
    creditos.x = largura/2 + 120
	creditos.y = altura - 70
	creditos.yScale = 0.4
	creditos.xScale = 0.4
	creditos:addEventListener("tap", gotoCredito)
	


	
	

end


-- show()
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


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	display.remove(sceneGroup)
	--audio.pause()
	
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
