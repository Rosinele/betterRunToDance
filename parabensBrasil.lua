
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

local function gotoProximo()
	composer.gotoScene("brasil")
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

	local parabens = display.newImage("img/parabens/parabens.png")
	parabens.x = largura/2
	parabens.y = altura/3
	parabens.yScale = 0.2
	parabens.xScale = 0.2
	sceneGroup:insert(parabens)

	local proximo = display.newImage("img/parabens/proximo.png")
	proximo.x = largura/2
	proximo.y = altura/2 + 100
	proximo.yScale = 0.3
	proximo.xScale = 0.3
	sceneGroup:insert(proximo)

	--[[local voltar = display.newImage("img/gameover/voltar.png")
	voltar.x = largura/5 * 4
	voltar.y = altura/2 + 100
	voltar.yScale = 0.3
	voltar.xScale = 0.3
	sceneGroup:insert(voltar)
	voltar:addEventListener( "tap", gotoMenu )]]


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
	display.remove(uiGroup)
	display.remove(background)
	display.remove(mainGroup)

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
