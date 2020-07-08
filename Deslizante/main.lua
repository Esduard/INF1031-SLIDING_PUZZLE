-- definindo estados do jogo
local abertura = true
local selecionando = false
local resolvendo = false
local terminado = false

function love.load ()
    love.window.setMode (1000,1000)
    love.window.setTitle ("Deslize")
    love.graphics.setBackgroundColor (0.95, 0.95, 0.95) -- quase branco
    w, h = love.graphics.getDimensions ()
    math.randomseed (os.time())
end

function love.keypressed (key)
    if key == 'enter' then
        if abertura then
            abertura = false
            selecionando = true
        end
    end
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'r' then
        love.event.quit('restart')
    end
end

function love.mousepressed (x, y, bt)
    if bt ~= 1 then return -- verifica se é botão esquerdo
  end
  
    if selecionando then
        --[[
        ...clique para escolha da dificuldade
        selecionando = false
        ...chamada da função para embaralhar
        resolvendo = true
        --]]
    end
end

function love.draw()

  if selecionando then
  --desenha botoes
  
  
  
  
  end


end


function love.update (dt)
    if resolvendo then
        --[[
        ...função para verificar se jogo terminou, retorna resolvendo = false e terminado = true
        --]]
    end
end
