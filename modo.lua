
local composer = require( "composer" )
local scene = composer.newScene()

local largura = display.contentWidth
local altura = display.contentHeight

local function gotoRapido()
    composer.gotoScene( "africa" )
end

local function gotoInfinito()
	composer.gotoScene("infinito1")
end

local function gotoMenu()
	composer.gotoScene("menu")
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

	-- Background Cima
	local background = display.newImage("img/base/background.png")
	background.x = largura/2
	background.y = altura/2
	background.yScale = 0.5
	background.xScale = 0.5
	sceneGroup:insert(background)

    
    local infinito = display.newImage("img/modo/infinito.png")
	infinito.x = 400
    infinito.y = altura/2 + 30
    infinito.yScale = 0.3
	infinito.xScale = 0.3
	sceneGroup:insert(infinito)
	infinito:addEventListener( "tap", gotoInfinito )
	

    local rapido = display.newImage("img/modo/rapido.png")
	rapido.x = 100
    rapido.y = altura/2 + 30
    rapido.yScale = 0.3
	rapido.xScale = 0.3
	sceneGroup:insert(rapido)
	rapido:addEventListener( "tap", gotoRapido )

	local voltar = display.newImage("img/base/voltar.png")
	voltar.x = largura - 2
    voltar.y = 40
    voltar.yScale = 0.3
	voltar.xScale = 0.3
	sceneGroup:insert(voltar)
	voltar:addEventListener( "tap", gotoMenu )


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
