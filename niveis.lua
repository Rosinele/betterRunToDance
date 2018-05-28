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
local function brasil()
	composer.gotoScene("brasil")
end

local function russia()
	composer.gotoScene("russia")
end

local function africa()
	composer.gotoScene("africa")
end

local function alemanha()
	composer.gotoScene("reforma")
end

local function japao()
	composer.gotoScene("reforma")
end

local function franca()
	composer.gotoScene("reforma")
end

local function gotoMenu()
composer.gotoScene("menu")
end

-- create()
function scene:create( event )


	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	-- O dobro da parede2 para fazer a animação--

	--physics.pause()
	--Background Cima
	local background = display.newImage("img/base/background.png")
	background.x = largura/2
	background.y = altura/3
	background.yScale = 0.5
	background.xScale = 0.5
	sceneGroup:insert(background)

	local nivel1 = display.newImage("img/niveis/nivel1.png") -- Russia
	nivel1.x = largura/7
	nivel1.y = altura/3
	nivel1.yScale = 0.4
	nivel1.xScale = 0.4
	sceneGroup:insert(nivel1)
	nivel1:addEventListener("tap", russia)

	local nivel2 = display.newImage("img/niveis/nivel2.png") -- Brasil
	nivel2.x = largura/2
	nivel2.y = altura/3
	nivel2.yScale = 0.4
	nivel2.xScale = 0.4
	sceneGroup:insert(nivel2)
	nivel2:addEventListener("tap", brasil)


	local nivel3 = display.newImage("img/niveis/nivel3.png") -- Africa do Sul
	nivel3.x = largura/2 + 150
	nivel3.y = altura/3
	nivel3.yScale = 0.4
	nivel3.xScale = 0.4
	sceneGroup:insert(nivel3)
	nivel3:addEventListener("tap", africa)

	local nivel4 = display.newImage("img/niveis/nivel4.png") -- Alemanha
	nivel4.x = largura/7
	nivel4.y = altura/1.3
	nivel4.yScale = 0.4
	nivel4.xScale = 0.4
	sceneGroup:insert(nivel4)
	nivel4:addEventListener("tap", alemanha)


	local nivel5 = display.newImage("img/niveis/nivel5.png") -- Coreia do sul/Japao
	nivel5.x = largura/2
	nivel5.y = altura/1.3
	nivel5.yScale = 0.4
	nivel5.xScale = 0.4
	sceneGroup:insert(nivel5)
	nivel5:addEventListener("tap", japao)


	local nivel6 = display.newImage("img/niveis/nivel6.png") -- Franca
	nivel6.x = largura/2 + 150
	nivel6.y = altura/1.3
	nivel6.yScale = 0.4
	nivel6.xScale = 0.4
	sceneGroup:insert(nivel6)
	nivel6:addEventListener("tap", franca)

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
