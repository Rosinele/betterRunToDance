
local composer = require( "composer" )

local scene = composer.newScene()

local largura = display.contentWidth
local altura = display.contentHeight

local baseline = 280

local physics = require( "physics" )
physics.start()

-- O dobro da parede2 para fazer a animação--
local parede2 = display.newImage( "img/paredeBackground.png" ) --https://pixabay.com/
parede2.x = largura/2-- Quando uma das parede2 termina, aparece a outra
parede2.y = altura/6
parede2.yScale = 0.8

local chao = display.newImage( "img/background.png" ) --https://pixabay.com/
chao.x = largura/2-- Quando uma das parede2 termina, aparece a outra
chao.y = altura/6
chao.yScale = 0.8

-- Background Cima
local background = display.newImage("img/paredeBackground.png")
background.x = largura/2
background.y = altura/4
background.yScale = 0.5
background.xScale = 0.7

local janela3 = display.newImage("img/janela.png")
janela3.x = 410
janela3.y = baseline - 180
janela3.yScale = 0.4
janela3.xScale = 0.4

local coluna = display.newImage("img/coluna.png")
coluna.x = largura/2
coluna.y = baseline - 200
coluna.yScale = 0.5
coluna.xScale = 0.5

--configuramos largura e altura dos sprites, bem como o nro. deles
local sheetOptions = { width = 53, height = 73, numFrames = 3 }
--carregamos a spritesheet com as opções
local sheet = graphics.newImageSheet( "img/bailar.png", sheetOptions )

--bailarina pulando
local sheetOptions2 = { width = 66, height = 74, numFrames = 3 }
local sheet2 = graphics.newImageSheet( "img/pulo.png", sheetOptions2 )
 
--definimos uma animação (sequence)
local sequences = {
    {
        name = "normalRun",
        start = 1,
        count = 3,
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
local running = display.newSprite( sheet, sequences )
 
--posicionamos o objeto na tela
running.x = display.contentWidth / 4 + 40
running.y = 225--distância da bailarina ao chão
running.xScale = 1.2
running.yScale = 1.2

local jumping = display.newSprite( sheet2, sequences2 )
jumping.x = display.contentWidth / 4 + 40
jumping.y = 225--distância da bailarina ao chão
jumping.xScale = 1.2
jumping.yScale = 1.2
jumping.isVisible = false;

--manda rodar
running:play()
running.isVisible = false;
--bailarina parada
local waiting = display.newImage( "img/frente.png" )
waiting.x = display.contentWidth / 4
waiting.y = 225--distância do cavalo ao chão
waiting.xScale = 1.2
waiting.yScale = 1.2

--função de início
local function start(event)
	waiting.isVisible = false;
	running.isVisible = true;
	running:setSequence("normalRun")
	running:play()
end	
	
waiting:addEventListener("tap", start);


local function pulo(event)
	if (event.isShake == true) then
	waiting.isVisible = false;
	running.isVisible = false;
	jumping.isVisible = true;
	jumping:setSequence("jump")
	jumping:play()
	end
   end
	
local function fimPulo(event)
	if (event.phase == "ended") then
	waiting.isVisible = false;
	running.isVisible = true;
	running:setSequence("normalRun")
	running:play()
	jumping:pause()
	jumping.isVisible = false;
	end
   end
	
Runtime:addEventListener("accelerometer", pulo);
jumping:addEventListener("sprite", fimPulo);

-- Função para parar
local function stop(event)
waiting.isVisible = true;
running.isVisible = false;
running:pause()
end

--Função para pular
local function stop(event)
waiting.isVisible = true;
running.isVisible = false;
running:pause()
end
 
running:addEventListener("tap", stop);

-- movendo os elementos
local tPrevious = system.getTimer()
local function move(event)
	 if(running.isVisible) then
		 local tDelta = event.time - tPrevious
		 tPrevious = event.time
		
		--Mover janela
		local xOffset = ( 0.2 * tDelta )
		janela3.x = janela3.x - xOffset
		janela3.x = janela3.x - xOffset
		 
		if (janela3.x + janela3.contentWidth) < 0 then
		janela3:translate( 410 * 2, 0)
		end
		if (janela3.x + janela3.contentWidth) < 0 then
		janela3:translate( 410 * 2, 0)
		end	

		 --Mover Colunas
		 local xOffset = ( 0.2 * tDelta )
		 coluna.x = coluna.x - xOffset
		 coluna.x = coluna.x - xOffset
		 
		 if (coluna.x + coluna.contentWidth) < 0 then
		 coluna:translate( 420 * 2, 0)
		 end
		 if (coluna.x + coluna.contentWidth) < 0 then
		 coluna:translate( 4 * 2, 0)
		 end
 
		--Mover Colunas
		local xOffset = ( 0.2 * tDelta )
		chao.x = chao.x - xOffset
		chao.x = chao.x - xOffset
		  
		if (chao.x + chao.contentWidth) < 0 then
		chao:translate( 415 * 2, 0)
		end
		if (chao.x + chao.contentWidth) < 0 then
		paredchaoe2:translate( 415 * 2, 0)
		end
 
		
	 end
end
 
-- faz tudo acontecer
Runtime:addEventListener( "enterFrame", move );