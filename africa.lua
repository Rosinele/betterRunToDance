
local composer = require( "composer" )
local scene = composer.newScene()

local largura = display.contentWidth
local altura = display.contentHeight

--physics.setGravity(0, 1) -- definindo o valor da gravidade para 0

math.randomseed( os.time() )

local score = 0 -- Scores iniciados com valor o
local died = false -- Inicia com o jogador vivo
local adicionar = 5
local remover = 5
local holding

local injecaoTable = {}
local sapatilhaTable = {} 
local lacoTable = {}
local remedioTable = {}

local bailarina -- Variavél reservada para a personagem do jogo
local gameLoopTimer -- Implementação de um timer
local scoreText -- Exibir pontuação

local baseline = 280

--Sons
local diminuiu = audio.loadSound( "sons/diminuiu.mp3" )
local somou = audio.loadSound( "sons/somou.wav" )
local nivel = audio.loadSound( "sons/novonivel.wav" )
local backgroundMusic = audio.loadStream( "sons/africa.mp3" )
local gameover = audio.loadSound( "sons/gameover.wav" )

-- A ordem que os grupos foram criados define a ordem que são exibidos

local backGroup = display.newGroup()  -- Grupo para as imgens de fundo (parede, nuvem, postes e chão)
local mainGroup = display.newGroup()  -- Guarda o personagem e os objetos flutuantes.
local uiGroup = display.newGroup()    -- Exibir pontuação
local jumpLimit = 0 


function scene:create( event )
	local physics = require( "physics" )
	physics.start()
	physics.setGravity(0, 9.8)
	audio.play( backgroundMusic )

	local sceneGroup = self.view
	--physics.pause()

-- Background da parede de tijolos do backGroup com largura e altura (o primeiro parametro define em qual grupo a imagem deve ser carregada)
	local background = display.newImageRect( backGroup, "img/africa/fundo.png", 1920, 1080) 
	background.x = largura/2
	background.y = altura/2
	background.yScale = 0.3
	background.xScale = 0.3


	-- Chão que vai se mover por cima do outro faz parte do backGroup com largura e altura (o primeiro parametro define em qual grupo a imagem deve ser carregada)
	local chao = display.newImageRect( backGroup, "img/africa/chao.png", 1917, 125) --https://pixabay.com/
	chao.x = 0
	chao.y = altura + 10
	chao.yScale = 0.7
	physics.addBody( chao, "static", {bounce=0} )
	-- Chão que vai ficar fixo do backGroup com largura e altura (o primeiro parametro define em qual grupo a imagem deve ser carregada)
	
	local chao1 = display.newImageRect( backGroup, "img/africa/chao.png", 1917, 125) --https://pixabay.com/
	chao1.x = 1910
	chao1.y = altura + 10
	chao1.yScale = 0.7
	physics.addBody( chao1, "static", {bounce=0} )

	local ceu = display.newImageRect( backGroup, "img/base/ceu.png", 2117, 142) --https://pixabay.com/
	ceu.x = 0
	ceu.y = 0
	ceu.yScale = 0.7
	ceu.alpha = 0
	physics.addBody( ceu, "static" )

	--physics.addBody( grade1, "static" )
	local elefante = display.newImageRect( "img/africa/ele.png", 109, 77)
	elefante.x = 100
	elefante.y = altura - 70
	elefante.yScale = 0.5
	elefante.xScale = 0.5
	backGroup:insert(elefante)
	
	local jacare = display.newImageRect( "img/africa/jac.png", 109, 77)
	jacare.x = 300
	jacare.y = altura - 70
	jacare.yScale = 0.5
	jacare.xScale = 0.5
	backGroup:insert(jacare)

	local girafa = display.newImageRect( "img/africa/gir.png", 109, 77)
	girafa.x = 500
	girafa.y = altura - 70
	girafa.yScale = 0.5
	girafa.xScale = 0.5
	backGroup:insert(girafa)

	local hipopotamo = display.newImageRect( "img/africa/hip.png", 109, 77)
	hipopotamo.x = 700
	hipopotamo.y = altura - 70
	hipopotamo.yScale = 0.5
	hipopotamo.xScale = 0.5
	backGroup:insert(hipopotamo)
	
	local leao = display.newImageRect( "img/africa/lea.png", 109, 77)
	leao.x = 900
	leao.y = altura - 70
	leao.yScale = 0.5
	leao.xScale = 0.5
	backGroup:insert(leao)

	local onca = display.newImageRect( "img/africa/onc.png", 109, 77)
	onca.x = 1100
	onca.y = altura - 70
	onca.yScale = 0.5
	onca.xScale = 0.5
	backGroup:insert(onca)

	
	local pause = display.newImage("img/base/pause.png")
	pause.x = largura - 2
    pause.y = 40
    pause.yScale = 0.3
	pause.xScale = 0.3
	uiGroup:insert(pause)
	--pause:addEventListener( "tap", gotoMenu )

	local grade = display.newImageRect( backGroup, "img/africa/grade.png", 1920, 152)  
	grade.x = 0
	grade.y = altura - 74
	grade.yScale = 0.5
	grade.xScale = 0.5
	backGroup:insert(grade)
	--physics.addBody( grade, "static" )

	local grade1 = display.newImageRect( backGroup, "img/africa/grade.png", 1920, 152)  
	grade1.x = 960
	grade1.y = altura - 74
	grade1.yScale = 0.5
	grade1.xScale = 0.5
	backGroup:insert(grade1)

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
	local running = display.newSprite(mainGroup, sheet, sequences )
	--physics.addBody( running,  "dynamic", { bounce=0} )
	physics.addBody(running, "dynamic", {radius=15, bounce=0})
	running.myName = "running"
	running.x = display.contentWidth / 4 + 40
	running.y = altura -90 --distância da bailarina ao chão

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

	scoreText = display.newText( uiGroup, "Experiência: " .. score, 0, 0, native.systemFont, 26 ) --Concatena o texto com a variável score
	scoreText.x = largura/9
	scoreText.y = altura/9
	scoreText:setFillColor(0, 0, 1) -- Define a cor do texto
	
	local function updateScores() -- Atualiza valor dos scores
			scoreText.text = "Experiência: " .. score
	end
	
	local function createSapatilha()
		local newSapatilha = display.newImageRect(uiGroup, "img/base/sapatilha.png", 66, 84)
		newSapatilha.yScale = 0.5
		newSapatilha.xScale =  0.5
		newSapatilha.myName = "sapatilha"
		table.insert(sapatilhaTable, newSapatilha) --Adiciona o objeto sapatinha na tabela
		physics.addBody( newSapatilha, "kinematic", { isSensor = true, radius=10, bounce=0, density = 0.0015 } )

		local whereFromSapatilha = math.random(2)
			if ( whereFromSapatilha == 1 ) then
				newSapatilha.x = largura + 10
				newSapatilha.y = display.contentCenterY + 20
				newSapatilha:setLinearVelocity(-200, 0 )

			elseif ( whereFromSapatilha == 2 ) then
				newSapatilha.x = largura + 210
				newSapatilha.y = 250
				newSapatilha:setLinearVelocity(-200, 0 )
			end
			--x,y
	end

	local function createInjecao()
		local newInjecao = display.newImageRect(uiGroup, "img/base/injecao.png", 66, 84)
		newInjecao.yScale = 0.5
		newInjecao.xScale =  0.5
		newInjecao.myName = "injecao"
		table.insert(injecaoTable, newInjecao)
		physics.addBody( newInjecao, "kinematic", { isSensor = true, radius=10, bounce=0, density = 0.0015 } )

		local whereFromInjecao = math.random(2)
			if ( whereFromInjecao == 1 ) then
				newInjecao.x = largura + 110
				newInjecao.y = display.contentCenterY + 20
				newInjecao:setLinearVelocity(-200, 0 )

			elseif ( whereFromInjecao == 2 ) then
				newInjecao.x = largura + 310
				newInjecao.y = 250
				newInjecao:setLinearVelocity(-200, 0 )
			end
			--x,y
	end

	local function createLaco()
		local newLaco = display.newImageRect(uiGroup, "img/base/laco.png", 66, 84)
		newLaco.yScale = 0.5
		newLaco.xScale =  0.5
		newLaco.myName = "laco"
		table.insert(lacoTable, newLaco)
		physics.addBody( newLaco, "kinematic", { isSensor = true, radius=10, bounce=0, density = 0.0015 } )

		local whereFromLaco = math.random(2)
			if ( whereFromLaco == 1 ) then
				newLaco.x = largura + 410
				newLaco.y = display.contentCenterY + 20
				newLaco:setLinearVelocity(-200, 0 )

			elseif ( whereFromLaco == 2 ) then
				newLaco.x = largura + 610
				newLaco.y = 250
				newLaco:setLinearVelocity(-200, 0 )
			end
			--x,y
	end

	local function createRemedio()
		local newRemedio = display.newImageRect(uiGroup, "img/base/remedio.png", 66, 84)
		newRemedio.yScale = 0.5
		newRemedio.xScale =  0.5
		newRemedio.myName = "remedio"
		table.insert(remedioTable, newRemedio)
		physics.addBody( newRemedio, "kinematic", { isSensor = true, radius=10, bounce=0, density = 0.0015 } )

		local whereFromRemedio = math.random(2)
			if ( whereFromRemedio == 1 ) then
				newRemedio.x = largura + 510
				newRemedio.y = display.contentCenterY + 20
				newRemedio:setLinearVelocity(-200, 0 )

			elseif ( whereFromRemedio == 2 ) then
				newRemedio.x = largura + 710
				newRemedio.y = 250
				newRemedio:setLinearVelocity(-200, 0 )
			end
			--x,y
	end



	local function gameLoop()

		createSapatilha()
		createInjecao()
		createLaco()
		createRemedio()

		for i = #sapatilhaTable, 1, -1 do
			local thisSapatilha = sapatilhaTable[i]

			if (thisSapatilha.x < -10)
			then
				display.remove( thisSapatilha )
				table.remove( sapatilhaTable, i )
			end
		end
		for i = #injecaoTable, 1, -1 do
			local thisinjecao = injecaoTable[i]

			if (thisinjecao.x < -10)
			then
				display.remove( thisinjecao)
				table.remove( injecaoTable, i)
			end
		end
		for i = #remedioTable, 1, -1 do
			local thisremedio = remedioTable[i]

			if (thisremedio.x < -10)
			then
				display.remove( thisremedio)
				table.remove( remedioTable, i)
			end
		end
		for i = #lacoTable, 1, -1 do 
			local thislaco = lacoTable[i]

			if (thislaco.x < -10)
			then
				display.remove( thislaco)
				table.remove( lacoTable, i)
			end
		end

	end

gameLoopTimer = timer.performWithDelay( 4000, gameLoop, 0 )


function pauseGame()
	gamePaused = true
	running:pause()
	physics.pause()
	timer.pause(gameLoop)
	timer.pause(gameLoopTimer)
	local pauseGroup = display.newGroup()

	local pauserect = display.newRect(0, 0, display.contentWidth+450, 640)
	pauserect.x = display.contentWidth/2 + 180
	pauserect:setFillColor(0)
	pauserect.alpha = 0.75
	pauserect:addEventListener("tap", function() return true end)
	pauseGroup:insert(pauserect)

	local resumebox = display.newImageRect("img/paredeBackground.png", display.contentWidth/2+200, display.contentHeight/2+100 )
		resumebox.x = display.contentWidth/2
		resumebox.y = display.contentHeight/2
		pauseGroup:insert(resumebox)

	local resumebtn = display.newImageRect("img/voltar.png", 60, 60)
		resumebtn.x = 100
		resumebtn.y = 100
		resumebtn:addEventListener("tap", resumeGame)
		pauseGroup:insert(resumebtn)
end

function buildPause(player)
	local pausebtn = display.newImageRect("img/voltar.png", 60, 60)
	pausebtn.x = display.contentWidth
	pausebtn.y = 280
	pausebtn:addEventListener("tap", pauseGame)
	playerT = player
	print(playerT)
	headerGroup:insert(pausebtn)
end


local function restoreBailarina()
    running.isBodyActive = false
    transition.to( running, { alpha=1, time=30,
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
	composer.gotoScene("parabensBrasil")
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
			
				for i = #sapatilhaTable, 1, -1 do 
					if ( sapatilhaTable[i] == obj1 or sapatilhaTable[i] == obj2 ) then
						-- Acrescenta score
						sapatilhaTable[i].alpha = 0
						score = score + adicionar
						scoreText.text = "Experiência: " .. score
						audio.play( somou )
						timer.performWithDelay( 500, restoreBailarina)
						break	
					end
				end

				if ( score > 49 ) then
					display.remove(mainGroup)
					display.remove(uiGroup)
					display.remove(backGroup)
					display.remove( running )
					display.remove( newinjecao )
                    display.remove( newSapatilha )
					novoNivel()		
				end	
			end
			

			--Finge que é algo que mata 
		elseif( (obj1.myName == "running" and obj2.myName == "injecao") or 
				(obj1.myName == "injecao" and obj2.myName == "running"))
			then
				if ( died == false ) then
					died = true

					for i = #injecaoTable, 1, -1 do
						if ( injecaoTable[i] == obj1 or injecaoTable[i] == obj2 ) then
							injecaoTable[i].alpha = 0
							score = score - remover
							scoreText.text = "Experiência: " .. score
							died = true
							audio.play( diminuiu )
							timer.performWithDelay( 500, restoreBailarina)
							break
						end
					end

					-- Verificar se atingiu a pontuação minima de scores
					if ( score < -9 ) then
						display.remove(mainGroup)
						display.remove(uiGroup)
						display.remove(backGroup)	
						gameOver()
						--local myText = display.newText( "GAME OVER!", 100, 200, native.systemFont, 16 )
					else
						timer.performWithDelay( 500, restoreBailarina)
					end
				end

			elseif (  (obj1.myName == "running" and obj2.myName == "remedio") or  
				(obj1.myName == "remedio" and obj2.myName == "running"))
			then
				if ( died == false ) then
						died = true
				
					for i = #remedioTable, 1, -1 do
						if ( remedioTable[i] == obj1 or remedioTable[i] == obj2 ) then
							-- Acrescenta score
							remedioTable[i].alpha = 0
							score = score - remover
							scoreText.text = "Experiência: " .. score
							audio.play( diminuiu )
							timer.performWithDelay( 500, restoreBailarina)
							break	
						end
					end
	
					if ( score > 49 ) then
						display.remove(mainGroup)
						display.remove(uiGroup)
						display.remove(backGroup)
						display.remove( running )
						display.remove( newinjecao )
						display.remove( newSapatilha )
						novoNivel()		
					end	
				end
				
	
				--Finge que é algo que mata 
			elseif( (obj1.myName == "running" and obj2.myName == "laco") or 
					(obj1.myName == "laco" and obj2.myName == "running"))
				then
					if ( died == false ) then
						died = true
	
						for i = #lacoTable, 1, -1 do
							if ( lacoTable[i] == obj1 or lacoTable[i] == obj2 ) then
								lacoTable[i].alpha = 0
								score = score + adicionar
								scoreText.text = "Experiência: " .. score
								died = true
								audio.play( somou )
								timer.performWithDelay( 500, restoreBailarina)
								break
							end
						end
	
						-- Verificar se atingiu a pontuação minima de scores
						if ( score < -9 ) then
							display.remove(mainGroup)
							display.remove(uiGroup)
							display.remove(backGroup)	
							gameOver()
							--local myText = display.newText( "GAME OVER!", 100, 200, native.systemFont, 16 )
						else
							timer.performWithDelay( 500, restoreBailarina)
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

			--Mover animais
			local xOffset = ( 0.1 * tDelta )
			jacare.x = jacare.x - xOffset
			elefante.x = elefante.x - xOffset
			girafa.x = girafa.x - xOffset
			hipopotamo.x = hipopotamo.x - xOffset
			leao.x = leao.x - xOffset
			onca.x = onca.x - xOffset

			if (jacare.x + jacare.contentWidth) < 0 then
				jacare:translate( 100 * 2, 0)
			end
			if (elefante.x + elefante.contentWidth) < 0 then
				elefante:translate( 300 * 2, 0)
			end
			if (girafa.x + girafa.contentWidth) < 0 then
				girafa:translate( 500 * 2, 0)
			end
			if (hipopotamo.x + hipopotamo.contentWidth) < 0 then
				hipopotamo:translate( 700 * 2, 0)
			end
			if (leao.x + leao.contentWidth) < 0 then
				leao:translate( 900 * 2, 0)
			end
			if (onca.x + onca.contentWidth) < 0 then
				onca:translate( 1100 * 2, 0)
			end
	 
			--Mover Chão
			local xOffset = ( 0.1 * tDelta )
			chao.x = chao.x - xOffset
			chao1.x = chao1.x - xOffset
			  
			if (chao.x + chao.contentWidth) < 0 then
				chao:translate( 1915 * 2, 0)
			end
			if (chao1.x + chao1.contentWidth) < 0 then
				chao1:translate( 1915 * 2, 0)
			end			

			--Mover grades
			local xOffset = ( 0.2 * tDelta )
			grade.x = grade.x - xOffset
			grade1.x = grade1.x - xOffset
			  
			if (grade.x + grade.contentWidth) < 0 then
				grade:translate( 960 * 2, 0)
			end
			if (grade1.x + grade1.contentWidth) < 0 then
				grade1:translate( 960 * 2, 0)
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
