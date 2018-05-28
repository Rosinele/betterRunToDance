--================================================================================
--===========================    Brasil   ========================================
--================================================================================


local composer = require( "composer" )
local scene = composer.newScene()

local largura = display.contentWidth
local altura = display.contentHeight

--physics.setGravity(0, 1) -- definindo o valor da gravidade para 0

math.randomseed( os.time() )

local score = 0 -- Scores iniciados com valor o
local died = false -- Inicia com o jogador vivo
local adicionar = 25
local remover = 25
local holding

-- As tabelas servem para rastrear tipos similares de informação
local tutuTable = {} -- Tabela para armazenar os tutus
local maxtutu = 30 -- Quantidade máxima de tutus criados no jogo
local sapatilhaTable = {} -- Tabela para armazenar os sapatilhas
local maxSapatilha = 30 -- Quantidade máxima de sapatilhas criados no jogo

local bailarina -- Variavél reservada para a personagem do jogo
local gameLoopTimer -- Implementação de um timer
local scoreText -- Exibir pontuação

local baseline = 280

--Sons
local diminuiu = audio.loadSound( "sons/diminuiu.mp3" )
local somou = audio.loadSound( "sons/somou.wav" )
local nivel = audio.loadSound( "sons/novonivel.wav" )
local backgroundMusic = audio.loadStream( "sons/menu.mp3" )
local gameover = audio.loadSound( "sons/gameover.mp3" )

-- A ordem que os grupos foram criados define a ordem que são exibidos

local backGroup = display.newGroup()  -- Grupo para as imgens de fundo (parede, nuvem, postes e chão)
local mainGroup = display.newGroup()  -- Guarda o personagem e os objetos flutuantes.
local uiGroup = display.newGroup()    -- Exibir pontuação
local jumpLimit = 0 

function scene:create( event )
	local physics = require( "physics" )
	physics.start()
	physics.setGravity(0, 9.6)
	audio.play( backgroundMusic )
	
	
	local sceneGroup = self.view
	--physics.pause()

	sceneGroup:insert(mainGroup)
-- Background da parede de tijolos do backGroup com largura e altura (o primeiro parametro define em qual grupo a imagem deve ser carregada)
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
	physics.addBody( chao, "static", {bounce=0} )
	-- Chão que vai ficar fixo do backGroup com largura e altura (o primeiro parametro define em qual grupo a imagem deve ser carregada)
	
	local chao1 = display.newImageRect( backGroup, "img/brasil/chao.png", 2117, 142) --https://pixabay.com/
	chao1.x = 2110
	chao1.y = altura + 10
	chao1.yScale = 0.7
	backGroup:insert(chao1)
	physics.addBody( chao1, "static" )

	local ceu = display.newImageRect( backGroup, "img/base/ceu.png", 2117, 142) --https://pixabay.com/
	ceu.x = 0
	ceu.y = 0
	ceu.yScale = 0.7
	ceu.alpha = 0
	physics.addBody( ceu, "static" )
	
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

	local coqueiro1 = display.newImageRect( "img/brasil/coqueiro1.png", 118, 304)
	coqueiro1.x = largura
	coqueiro1.y = altura - 97
	coqueiro1.yScale = 0.4
	coqueiro1.xScale = 0.4
	backGroup:insert(coqueiro1)

	local coqueiro2 = display.newImageRect( "img/brasil/coqueiro2.png", 118, 304)
	coqueiro2.x = largura/6
	coqueiro2.y = altura - 97
	coqueiro2.yScale = 0.4
	coqueiro2.xScale = 0.4
	backGroup:insert(coqueiro2)

	local pause = display.newImage("img/base/pause.png")
	pause.x = largura - 2
    pause.y = 40
    pause.yScale = 0.3
	pause.xScale = 0.3
	sceneGroup:insert(pause)
	--pause:addEventListener( "tap", gotoMenu )

	local sheetOptions = { width = 67.4, height = 74, numFrames = 20 }
	--carregamos a spritesheet com as opções
	local sheet = graphics.newImageSheet( "img/base/bailar.png", sheetOptions )

	--bailarina pulando
	local sheetOptions2 = { width = 66, height = 74, numFrames = 3 }
	local sheet2 = graphics.newImageSheet( "img/base/pulo.png", sheetOptions2 )
	 
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
	local sequences2 = {
	    {
	        name = "jump",
	        start = 1,
	        count = 3,
	        time = 500,
	        loopCount = 1,
	        loopDirection = "forward"
	    }
	}
	--criamos um objeto de display com todas as configs anteriores
	local running = display.newSprite(uiGroup, sheet, sequences )
	--physics.addBody( running,  "dynamic", { bounce=0} )
	physics.addBody(running, "dynamic", {radius=15, bounce=0})
	running.myName = "running"
	running.x = display.contentWidth / 4 + 40
	running.y = 255

	--[[local jumping = display.newSprite( sheet2, sequences2 )
	jumping.x = display.contentWidth / 4 + 40
	jumping.y = display.contentHeight/1.3 --distância da bailarina ao chão
	jumping.myName = "jumping"
	jumping.xScale = 1.2
	jumping.yScale = 1.2
	jumping.isVisible = false;]]

	--manda rodar
	running:play()
	running.isVisible = true;
	--bailarina parada
	local waiting = display.newImage( "img/base/frente.png" )
	waiting.x = display.contentWidth / 4 + 40
	waiting.y = display.contentHeight/1.3--distância da bailarina ao chão
	waiting.xScale = 1.2
	waiting.yScale = 1.2
	waiting.isVisible = false;

	scoreText = display.newText( uiGroup, "Experiência: " .. score, 200, 80, native.systemFont, 26 ) --Concatena o texto com a variável score
	scoreText.x = largura/9
	scoreText.y = altura/9
	scoreText:setFillColor(0, 0, 1) -- Define a cor do texto
	
	local function updateScores() -- Atualiza valor dos scores
			scoreText.text = "Experiência: " .. score
	end
	
	local function createSapatilha()
		local newSapatilha = display.newImageRect(uiGroup, "img/base/sapatilha.png", 476, 720)
		newSapatilha.yScale = 0.05
		newSapatilha.xScale =  0.05
		newSapatilha.myName = "sapatilha"
		table.insert(sapatilhaTable, newSapatilha) --Adiciona o objeto sapatinha na tabela
		physics.addBody( newSapatilha, "kinematic", { isSensor = true, radius=10, bounce=0, density = 0.0015 } )
		--physics.addBody(newSapatilha)

		local whereFromSapatilha = math.random(2)
			if ( whereFromSapatilha == 1 ) then
				newSapatilha.x = largura + 10
				newSapatilha.y = display.contentCenterY
				newSapatilha:setLinearVelocity(-200, 0 )

			elseif ( whereFromSapatilha == 2 ) then
				newSapatilha.x = largura + 310
				newSapatilha.y = 230
				newSapatilha:setLinearVelocity(-200, 0 )
			end
			--x,y
	end


	local function createTutu()
		local newTutu = display.newImageRect(uiGroup, "img/base/tutu.png", 360, 720)
		newTutu.yScale = 0.05
		newTutu.xScale =  0.05
		newTutu.myName = "tutu"
		table.insert(tutuTable, newTutu) --Adiciona o objeto tutu na tabela
		physics.addBody( newTutu, "kinematic", { isSensor = true, radius=10, bounce=0, density = 0.0015 } )
		--physics.addBody(newTutu)
		
		local whereFromTutu = math.random(2)
			if ( whereFromTutu == 1 ) then
				newTutu.x = largura + 510
				newTutu.y = display.contentCenterY
				newTutu:setLinearVelocity(-200, 0 )

			elseif ( whereFromTutu == 2 ) then
				newTutu.x = largura + 810
				newTutu.y = 230
				newTutu:setLinearVelocity(-200, 0 )
			end
			--x,y
	end

	

	


	local function gameLoop()
		createTutu()
		createSapatilha()
		createTutu()
		local musicadeFundo = audio.loadStream( "sons/brasil.mp3" )

		for i = #sapatilhaTable, 1, -1 do -- Começa da qunatidade que tem na sapatilhaTable ate 1, sempre decrementando -1
			local thisSapatilha = sapatilhaTable[i]

			if (thisSapatilha.x < -10)
			then
				display.remove( thisSapatilha )
				table.remove( sapatilhaTable, i )
			end
		end
		for i = #tutuTable, 1, -1 do -- Começa da quantidade que tem na tutuTable ate 1, sempre decrementando -1
			local thisTutu = tutuTable[i]

			if (thisTutu.x < -10)
			then
				display.remove( thisTutu)
				table.remove( tutuTable, i)
			end
		end

	end

gameLoopTimer = timer.performWithDelay( 3000, gameLoop, 0 )

local function restoreBailarina()
 
    running.isBodyActive = false
 
    -- Fade in the Bailarina
    transition.to( running, { alpha=1, time=50,
        onComplete = function()
            running.isBodyActive = true
            died = false
        end
    } )
end

local function gameOver()
	composer.gotoScene("gameover")
end

local function novoNivel()
	composer.gotoScene("infinito3")
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
		local obj2 = event.object2

		if (  (obj1.myName == "running" and obj2.myName == "sapatilha") or  
			  (obj1.myName == "sapatilha" and obj2.myName == "running"))
        then
			if ( died == false ) then
					died = true
			
				for i = #sapatilhaTable, 1, -1 do -- Começa da quantidade que tem na tutuTsapatilhaTable ate 1, sempre decrementando -1
					if ( sapatilhaTable[i] == obj1 or sapatilhaTable[i] == obj2 ) then
						sapatilhaTable[i].alpha = 0
						score = score + adicionar
						scoreText.text = "Experiência: " .. score
						audio.play( somou )
						timer.performWithDelay( 500, restoreBailarina)
						break	
					end
				end

				if ( score > 199 ) then
					display.remove(mainGroup)
					display.remove(uiGroup)
					display.remove(backGroup)
					display.remove( running )
					display.remove( newTutu )
                    display.remove( newSapatilha )
					novoNivel()	
				end	
			end
			

			--Finge que é algo que mata 
		elseif( (obj1.myName == "running" and obj2.myName == "tutu") or 
				(obj1.myName == "tutu" and obj2.myName == "running"))
			then
				if ( died == false ) then
					died = true

					for j = #tutuTable, 1, -1 do
						if ( tutuTable[j] == obj1 or tutuTable[i] == obj2 ) then
							tutuTable[j].alpha = 0
							score = score - remover
							scoreText.text = "Experiência: " .. score
							died = true
							audio.play( diminuiu )
							timer.performWithDelay( 500, restoreBailarina)
							break
						end
					end

					-- Verificar se atingiu a pontuação minima de scores
					if ( score < -49 ) then
						running.alpha = 0
						display.remove( running )
						audio.stop(diminuiu)
						audio.stop(nivel)
						audio.stop(somou)
						gameOver()
						--local myText = display.newText( "GAME OVER!", 100, 200, native.systemFont, 16 )
					else
						timer.performWithDelay( 500, restoreBailarina)
					end
				end

		elseif( (obj1.myName == "running" and obj2.myName == "chao") or 
				(obj1.myName == "chao" and obj2.myName == "running"))
			then
					if ( died == false ) then
						died = true

						for i = #chaoTable, 1, -1 do
							if ( chao == obj1 or chao == obj2 ) then
								running:setSequence("normalRun")
							end
						end
					end

		end
	end

end

Runtime:addEventListener( "collision", onCollision )

local function start(event)
	waiting.isVisible = false;
	running.isVisible = true;
	running:setSequence("normalRun")
	running:play() 
end	
		
	waiting:addEventListener("tap", start);


	-- Função para parar
	local function stop(event)
	waiting.isVisible = true;
	running.isVisible = false;
	running:pause()
	end


	local function jumping(event)
				running:applyLinearImpulse(0, -0.06, running.x, running.y)
				--running:setSequence("jumping")
	end
	 
	background:addEventListener( "tap", jumping )
	--running:addEventListener("tap", stop);

	-- movendo os elementos da direita para a esquerda
	local tPrevious = system.getTimer()
	function move(event)
		 if(running.isVisible) then
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

			--Mover coqueiros
			local xOffset = ( 0.1 * tDelta )
			coqueiro1.x = coqueiro1.x - xOffset
			coqueiro2.x = coqueiro2.x - xOffset
			 
			if (coqueiro1.x + coqueiro1.contentWidth) < 0 then
				coqueiro1:translate( 380 * 2, 0)
			end
			if (coqueiro2.x + coqueiro2.contentWidth) < 0 then
				coqueiro2:translate( 380 * 2, 0)
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
			local xOffset = ( 0.16 * tDelta )
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
	audio.stop(diminuiu)
	audio.stop(nivel)
	audio.stop(somou)
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
