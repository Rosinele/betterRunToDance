
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
	composer.gotoScene("menu")
end


-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	-- O dobro da parede2 para fazer a animação--


	local background = display.newImage("img/niveis/reforma.png")
	background.x = largura/2
	background.y = altura/2
	background.yScale = 0.3
	background.xScale = 0.3
	sceneGroup:insert(background)

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
