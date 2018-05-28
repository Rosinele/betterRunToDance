	local composer = require( "composer" )
	local scene = composer.newScene()

	local largura = display.contentWidth
	local altura = display.contentHeight

	--physics.setGravity(0, 1) -- definindo o valor da gravidade para 0

	math.randomseed( os.time() )

	local score = 0 -- Scores iniciados com valor o
	local died = false -- Inicia com o jogador vivo
	local adicionar = 50
	local remover = 5

	-- As tabelas servem para rastrear tipos similares de informação
	local bailar5Table = {} -- Tabela para armazenar os bailar5s
	local maxbailar5 = 30 -- Quantidade máxima de bailar5s criados no jogo
	local bailar4Table = {} -- Tabela para armazenar os bailar4s
	local maxbailar4 = 30 -- Quantidade máxima de bailar4s criados no jogo
	local bailar6Table = {} 
	local maxbailar6 = 30 
	local bailar3Table = {} 
	local maxbailar3 = 30 
	local bailar2Table = {} 
	local maxbailar2 = 30 
	local bailar7Table = {} 
	local maxbailar7 = 30 
	local bailar1Table = {} 
	local maxbailar1 = 30 
	local bailar8Table = {} 
	local maxbailar8 = 30 
	local bailar9Table = {} 
	local maxbailar9 = 30 

	local bailarina -- Variavél reservada para a personagem do jogo
	local gameLoopTimer -- Implementação de um timer
	local scoreText -- Exibir pontuação

	local baseline = 280

	--Sons
	local diminuiu = audio.loadSound( "sons/diminuiu.mp3" )
	local somou = audio.loadSound( "sons/somou.mp3" )
	local nivel = audio.loadSound( "sons/novonivel.mp3" )

	-- A ordem que os grupos foram criados define a ordem que são exibidos

	local backGroup = display.newGroup()  -- Grupo para as imgens de fundo (cidade, nuvem, postes e chão)
	local mainGroup = display.newGroup()  -- Guarda o personagem e os objetos flutuantes.
	local uiGroup = display.newGroup()    -- Exibir pontuação
	local jumpLimit = 0 

	local modelo = {}

	function scene:create( event )
	local physics = require( "physics" )
	physics.start()
	physics.setGravity(0, 9.6)
	
	
	local sceneGroup = self.view
	--physics.pause()

	sceneGroup:insert(mainGroup)
-- Background da cidade do backGroup com largura e altura (o primeiro parametro define em qual grupo a imagem deve ser carregada)
	local background = display.newImageRect( backGroup, "img/brasil/fundo.png", 1920, 1080) 
	background.x = largura/2
	background.y = display.contentCenterY
	background.yScale = 0.3
	background.xScale = 0.3
	backGroup:insert(background)

	-- nuvem do backGroup com largura e altura (o primeiro parametro define em qual grupo a imagem deve ser carregada)
	local nuvem = display.newImageRect( "img/brasil/nuvem.png", 1920, 1080)
	nuvem.x = 0
	nuvem.y = display.contentCenterY
	nuvem.yScale = 0.3
	nuvem.xScale = 0.3
	uiGroup:insert(nuvem)

	local nuvem1 = display.newImageRect( "img/brasil/nuvem.png", 1920, 1080)
	nuvem1.x = 600
	nuvem1.y = display.contentCenterY
	nuvem1.yScale = 0.3
	nuvem1.xScale = 0.3
	uiGroup:insert(nuvem1)

	-- Chão que vai se mover por cima do outro faz parte do backGroup com largura e altura (o primeiro parametro define em qual grupo a imagem deve ser carregada)
	local chao = display.newImageRect( backGroup, "img/brasil/chao.png", 2117, 142) --https://pixabay.com/
	chao.x = 0
	chao.y = altura + 10
	chao.yScale = 0.7
	backGroup:insert(chao)
	physics.addBody( chao, "static" )
	-- Chão que vai ficar fixo do backGroup com largura e altura (o primeiro parametro define em qual grupo a imagem deve ser carregada)
	
	local chao1 = display.newImageRect( backGroup, "img/brasil/chao.png", 2117, 142) --https://pixabay.com/
	chao1.x = 2110
	chao1.y = altura + 10
	chao1.yScale = 0.7
	backGroup:insert(chao1)
	physics.addBody( chao1, "static" )
	
	-- posted do backGroup com largura e altura (o primeiro parametro define em qual grupo a imagem deve ser carregada)
	local posted = display.newImageRect( "img/brasil/posted.png", 118, 304)
	posted.x = largura/5
	posted.y = altura - 97
	posted.yScale = 0.4
	posted.xScale = 0.4
	backGroup:insert(posted)

	local postee = display.newImageRect( "img/brasil/postee.png", 118, 304)
	postee.x = largura/3
	postee.y = altura - 97
	postee.yScale = 0.4
	postee.xScale = 0.4
	backGroup:insert(postee)


	local function comparar1( event ) 
		if ( event.name == modelo[1].myName ) then
			modelo[1].alpha = 0
			score = score + 1
		end
	end
	local function comparar2( event ) 
		if ( event.name == modelo[2].myName ) then
			modelo[2].alpha = 0
			score = score + 1
		end
	end
	local function comparar3( event ) 
		if ( event.name == modelo[3].myName ) then
			modelo[3].alpha = 0
			score = score + 1
		end
	end
	local function comparar4( event ) 
		if ( event.name == modelo[4].myName ) then
			modelo[4].alpha = 0
			score = score + 1
		end
	end
	local function comparar5( event ) 
		if ( event.name == modelo[5].myName ) then
			modelo[5].alpha = 0
			score = score + 1
		end
	end
	local function comparar6( event ) 
		if ( event.name == modelo[6].myName ) then
			modelo[6].alpha = 0
			score = score + 1
		end
	end

	local newbailar1 = display.newImageRect(uiGroup, "img/base/bailar1.png", 47, 73)
	newbailar1.myName = "bailar1"
	physics.addBody( newbailar1, "static")--, { isSensor = true, radius=40, bounce=0.3, density = 0.0015 } )
	newbailar1.x = 0
	newbailar1.y = 250 --display.contentCenterY
	newbailar1:addEventListener( "tap", comparar1 )

	local newbailar2 = display.newImageRect(uiGroup, "img/base/bailar2.png", 49, 73)
	newbailar2.myName = "bailar2"
	physics.addBody( newbailar2, "static")--, { isSensor = true, radius=40, bounce=0, density = 0.0015 } )
	newbailar2.x = 100
	newbailar2.y = 250 --display.contentCenterY
	newbailar2:addEventListener( "tap", comparar2 )
	
	local newbailar3 = display.newImageRect(uiGroup, "img/base/bailar3.png", 48, 71)
	newbailar3.myName = "bailar3"
	physics.addBody( newbailar3, "static")--, { isSensor = true, radius=40, bounce=0, density = 0.0015 } )
	newbailar3.x = 200
	newbailar3.y = 250 --display.contentCenterY
	newbailar3:addEventListener( "tap", comparar3 )

	local newbailar4 = display.newImageRect(uiGroup, "img/base/bailar4.png", 46, 73)
	newbailar4.myName = "bailar4"
	physics.addBody( newbailar4, "static")--, { isSensor = true, radius=50, bounce=0, density = 0.0015 } )
	newbailar4.x = 300
	newbailar4.y = 250 --display.contentCenterY
	newbailar4:addEventListener( "tap", comparar4 )

	local newbailar5 = display.newImageRect(uiGroup, "img/base/bailar5.png", 49, 73)
	newbailar5.myName = "bailar5"
	physics.addBody( newbailar5, "static")--, { isSensor = true, radius=40, bounce=0, density = 0.0015 } )
	newbailar5.x = 400
	newbailar5.y = 250 --display.contentCenterY
	newbailar5:addEventListener( "tap", comparar5 )

	local newbailar6 = display.newImageRect(uiGroup, "img/base/bailar6.png", 47, 73)
	newbailar6.myName = "bailar6"
	physics.addBody( newbailar6, "static")--, { isSensor = true, radius=50, bounce=0, density = 0.0015 } )
	newbailar6.x = 500
	newbailar6.y = 250 --display.contentCenterY
	newbailar6:addEventListener( "tap", comparar6 )

	--[[local newbailar7 = display.newImageRect(uiGroup, "img/base/bailar7.png", 60, 74)
	newbailar7.myName = "bailar7"
	physics.addBody( newbailar7, "kinematic", { isSensor = true, radius=50, bounce=0, density = 0.0015 } )
	newbailar7.x = 600
	newbailar7.y = 250 --display.contentCenterY

	local newbailar8 = display.newImageRect(uiGroup, "img/base/bailar8.png", 61, 74)
	newbailar8.myName = "bailar8"
	physics.addBody( newbailar8, "kinematic", { isSensor = true, radius=50, bounce=0.3, density = 0.0015 } )
	newbailar8.x = 700
	newbailar8.y = 250 --display.contentCenterY

	local newbailar9 = display.newImageRect(uiGroup, "img/base/bailar9.png", 56, 78)
	newbailar9.myName = "bailar9"
	physics.addBody( newbailar9, "kinematic", { isSensor = true, radius=50, bounce=0.3, density = 0.0015 } )
	newbailar9.x = 800
	newbailar9.y = 250 --display.contentCenterY]]

	--criamos um objeto de display com todas as configs anteriores

	scoreText = display.newText( uiGroup, "Score: " .. score, 200, 80, native.systemFont, 36 ) --Concatena o texto com a variável score
	scoreText.x = largura/9
	scoreText.y = altura/9
	scoreText:setFillColor(0, 0, 1) -- Define a cor do texto
	
	local function updateScores() -- Atualiza valor dos scores
			scoreText.text = "Score: " .. score
	end
	
	local function createModelo()
		--for i = 9, 1, -1 do		
			local modeloAtual = math.random(4)
			local thisModelo = modelo[modeloAtual]
				--thismodelo.alpha = 1
			if (modeloAtual == 1) then
				modelo[1] = display.newImage("img/base/bailar1.png")
				--physics.addBody( modelo[1], { radius=15, isSensor=true } )
				modelo[1].myName = "bailar1"
				modelo[1].x = largura/2
				modelo[1].y = altura/3
				modelo[1].yScale = 1.5
				modelo[1].xScale = 1.5
				--timer.performWithDelay( 500, restoreModelo)

			elseif (modeloAtual == 2) then
				modelo[2] = display.newImage("img/base/bailar2.png")
				--physics.addBody( modelo[2], { radius=15, isSensor=true } )
				modelo[2].myName = "bailar1"
				modelo[2].x = largura/2
				modelo[2].y = altura/3
				modelo[2].yScale = 1.5
				modelo[2].xScale = 1.5
				--timer.performWithDelay( 500, restoreModelo)

			elseif (modeloAtual == 3) then
				modelo[3] = display.newImage("img/base/bailar3.png")
				--physics.addBody( modelo[3], { radius=15, isSensor=true } )
				modelo[3].myName = "bailar1"
				modelo[3].x = largura/2
				modelo[3].y = altura/3
				modelo[3].yScale = 1.5
				modelo[3].xScale = 1.5
				--timer.performWithDelay( 500, restoreModelo)

			elseif (modeloAtual == 4) then
				modelo[4] = display.newImage("img/base/bailar4.png")
				--physics.addBody( modelo[4], { radius=15, isSensor=true } )
				modelo[4].myName = "bailar1"
				modelo[4].x = largura/2
				modelo[4].y = altura/3
				modelo[4].yScale = 1.5
				modelo[4].xScale = 1.5
				--timer.performWithDelay( 500, restoreModelo)

			elseif (modeloAtual == 5) then
				modelo[5] = display.newImage("img/base/bailar5.png")
				physics.addBody( modelo[5], { radius=15, isSensor=true } )
				modelo[5].myName = "bailar1"
				modelo[5].x = largura/2
				modelo[5].y = altura/2
				--timer.performWithDelay( 1000, restoreModelo)

			elseif (modeloAtual == 6) then
				modelo[6] = display.newImage("img/base/bailar6.png")
				physics.addBody( modelo[6], { radius=15, isSensor=true } )
				modelo[6].myName = "bailar1"
				modelo[6].x = largura/2
				modelo[6].y = altura/2
				--timer.performWithDelay( 1000, restoreModelo)

			--[[elseif (modeloAtual == 7) then
				modelo[7] = display.newImage("img/base/bailar7.png")
				physics.addBody( modelo[7], { radius=15, isSensor=true } )
				modelo[7].myName = "bailar1"
				modelo[7].x = largura/2
				modelo[7].y = altura/2
				timer.performWithDelay( 1000, restoreModelo)

			elseif (modeloAtual == 8) then
				modelo[8] = display.newImage("img/base/bailar8.png")
				physics.addBody( modelo[8], { radius=15, isSensor=true } )
				modelo[8].myName = "bailar1"
				modelo[8].x = largura/2
				modelo[8].y = altura/2
				timer.performWithDelay( 1000, restoreModelo)

			elseif (modeloAtual == 9) then
				modelo[9] = display.newImage("img/base/bailar9.png")
				physics.addBody( modelo[9], { radius=15, isSensor=true } )
				modelo[9].myName = "bailar1"
				modelo[9].x = largura/2
				modelo[9].y = altura/2
				timer.performWithDelay( 1000, restoreModelo)]]
			end
			
			--timer.performWithDelay( 1000, restoreModelo)
		--end
	end

	

	local function gameLoop()
		createModelo()
		
		local musicadeFundo = audio.loadStream( "sons/brasil.mp3" )
		for i = #bailar4Table, 1, -1 do -- Começa da qunatidade que tem na bailar4Table ate 1, sempre decrementando -1
			local thisbailar4 = bailar4Table[i]

			if (thisbailar4.x < -10)
			then
				display.remove( thisbailar4 )
				table.remove( bailar4Table, i )
			end
		end
		for i = #bailar5Table, 1, -1 do -- Começa da quantidade que tem na bailar5Table ate 1, sempre decrementando -1
			local thisbailar5 = bailar5Table[i]

			if (thisbailar5.x < -10)
			then
				display.remove( thisbailar5)
				table.remove( bailar5Table, i)
			end
		end
		for i = #bailar6Table, 1, -1 do -- Começa da qunatidade que tem na bailar6Table ate 1, sempre decrementando -1
			local thisbailar6 = bailar6Table[i]

			if (thisbailar6.x < -10)
			then
				display.remove( thisbailar6 )
				table.remove( bailar6Table, i )
			end
		end
		for i = #bailar3Table, 1, -1 do -- Começa da quantidade que tem na bailar3Table ate 1, sempre decrementando -1
			local thisbailar3 = bailar3Table[i]

			if (thisbailar3.x < -10)
			then
				display.remove( thisbailar3)
				table.remove( bailar3Table, i)
			end
		end
		for i = #bailar7Table, 1, -1 do -- Começa da qunatidade que tem na bailar7Table ate 1, sempre decrementando -1
			local thisbailar7 = bailar7Table[i]

			if (thisbailar7.x < -10)
			then
				display.remove( thisbailar7 )
				table.remove( bailar7Table, i )
			end
		end
		for i = #bailar2Table, 1, -1 do -- Começa da quantidade que tem na bailar2Table ate 1, sempre decrementando -1
			local thisbailar2 = bailar2Table[i]

			if (thisbailar2.x < -10)
			then
				display.remove( thisbailar2)
				table.remove( bailar2Table, i)
			end
		end
		for i = #bailar9Table, 1, -1 do -- Começa da qunatidade que tem na bailar9Table ate 1, sempre decrementando -1
			local thisbailar9 = bailar9Table[i]

			if (thisbailar9.x < -10)
			then
				display.remove( thisbailar9 )
				table.remove( bailar9Table, i )
			end
		end
		for i = #bailar1Table, 1, -1 do -- Começa da quantidade que tem na bailar1Table ate 1, sempre decrementando -1
			local thisbailar1 = bailar1Table[i]

			if (thisbailar1.x < -10)
			then
				display.remove( thisbailar1)
				table.remove( bailar1Table, i)
			end
		end
		for i = #bailar8Table, 1, -1 do -- Começa da qunatidade que tem na bailar8Table ate 1, sempre decrementando -1
			local thisbailar8 = bailar8Table[i]

			if (thisbailar8.x < -10)
			then
				display.remove( thisbailar8 )
				table.remove( bailar8Table, i )
			end
		end


	end

gameLoopTimer = timer.performWithDelay( 3000, gameLoop, 0 )


--[[local function restoreModelo()

	display.remove( thisModelo )
	display.remove( modelo, modeloAtual )
    thismodelo.isBodyActive = false
    thismodelo.x = largura/2
	thismodelo.y = altura/2
 
    -- Fade in the Bailarina
    transition.to( modelo, { alpha=1, time=50,
        onComplete = function()
            modelo.isBodyActive = true
            died = false
        end
    } )
end]]


local function gameOver()
	composer.gotoScene("gameover")
end

local function novoNivel()
	composer.gotoScene("niveis")
end


local function start(event)
	modelo.isVisible = true;
	modelo:setSequence("normalRun")
	modelo:play() 
end	
		
	--waiting:addEventListener("tap", start);


	-- Função para parar
	local function stop(event)
	--waiting.isVisible = true;
	modelo.isVisible = false;
	modelo:pause()
	end


	local tPrevious = system.getTimer()
	function move(event)
		 if(modelo.isVisible) then
			 local tDelta = event.time - tPrevious
			 tPrevious = event.time
			
			--Mover nuvens
			local xOffset = ( 0.2 * tDelta )
			nuvem.x = nuvem.x - xOffset
			nuvem1.x = nuvem1.x - xOffset
			 
			if (nuvem.x + nuvem.contentWidth) < 0 then
			nuvem:translate( 700 * 2, 0)
			end
			if (nuvem1.x + nuvem1.contentWidth) < 0 then
			nuvem1:translate( 700 * 2, 0)
			end	

			--Mover postes
			local xOffset = ( 0.1 * tDelta )
			posted.x = posted.x - xOffset
			postee.x = postee.x - xOffset
			
			if (posted.x + posted.contentWidth) < 0 then
				posted:translate( 400 * 2, 0)
			end
			if (postee.x + postee.contentWidth) < 0 then
				postee:translate( 400 * 2, 0)
			end
	 
			--Mover Chão
			local xOffset = ( 0.1 * tDelta )
			chao.x = chao.x - xOffset
			chao1.x = chao1.x - xOffset
			  
			if (chao.x + chao.contentWidth) < 0 then
				chao:translate( 2100 * 2, 0)
			end
			if (chao1.x + chao1.contentWidth) < 0 then
				chao1:translate( 2100 * 2, 0)
			end			
		 end
	end
	 
	-- faz tudo acontecer
	Runtime:addEventListener( "enterFrame", move );
	-- -----------------------------------------------------------------------------------
	-- Code outside of the scene event functions below will only be executed ONCE unless
	-- the scene is removed entirely (not recycled) via "composer.removeScene()"
	-- -----------------------------------------------------------------------------------


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
	backGroup:remove(background)
	mainGroup:remove()
    uiGroup:remove(backToActivities)

	-- Code here runs prior to the removal of scene's view

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
