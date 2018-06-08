
local composer = require( "composer" )
local scene = composer.newScene()

local largura = display.contentWidth
local altura = display.contentHeight

local backGroup = display.newGroup()  -- Grupo para as imgens de fundo (parede, nuvem, postes e chão)
local mainGroup = display.newGroup()  -- Guarda o personagem e os objetos flutuantes.
local uiGroup = display.newGroup()    -- Exibir pontuação
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function gotoMenu()
	composer.gotoScene("scene.menu")
end
-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	-- O dobro da parede2 para fazer a animação--

	physics.pause()

	local background = display.newImage("img/base/background.png")
	background.x = largura/2
	background.y = altura/2
	background.yScale = 0.5
	background.xScale = 0.5
	sceneGroup:insert(background)

	local morta = display.newImage("img/gameover/morta.png")
	morta.x = largura/2 -50
	morta.y = altura/2 
	morta.yScale = 0.3
	morta.xScale = 0.3
	sceneGroup:insert(morta)

	local tentar = display.newImage("img/base/tentar.png")
	tentar.x = largura - 2
	tentar.y = altura/2 + 100
	tentar.yScale = 0.3
	tentar.xScale = 0.3
	sceneGroup:insert(tentar)

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


--destroy()
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
