-- definindo estados do jogo
local abertura = true
local selecionando = false
local resolvendo = false
local terminado = false

local w
local h


local tiles -- tabela de tiles
local dificuldade -- receba apena valores 3, 4 ou 5

local tInicio
local tFim

function verificaNeigbor(indice)
  
  --verifica se tile esquerda esta vazia
  if tiles[indice - 1].visivel == false and (indice - 1) % dificuldade ~= 0
    return true
  end
  
  --verifica se tile direita esta vazia
  if tiles[indice + 1].visivel == false and indice % dificuldade ~= 0
    return true
  end
  
  --verifica se tile superior esta vazia
  if tiles[indice - dificuldade].visivel == false and indice - dificuldade > 0
    return true
  end
  
  --verifica se tile inferior esta vazio
  if tiles[indice + dificuldade].visivel == false and indice + dificuldade < (dificuldade * dificuldade)
    return true
  end

end

function love.load ()
    love.window.setMode (1000,1000)
    love.window.setTitle ("Deslize")
    love.graphics.setBackgroundColor (1.0,1.0,1.0) -- quase branco
    
    --definir imagem aleatoria do repositorio
    love.graphics.newImage(" ")
    
    
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
        ...chamada da função para embaralhar
        -- if coordenada for a do botao de dificuldade atribua a dificuldade
        selecionando = false
        tiles = geraQuad(dificuldade)
        
        --randomizar tiles
        --criar funcao que embaralha tiles
        tInicio = love.timer.getTime()
        resolvendo = true
        --]]
    end
    
    if resolvendo then
    --[[ clique para deslizar tile
    -- indice pode ser obtido pelo (x - deslocamento da tabela)/ tamanho de um tile e (y - deslocamento de tabela)/ tamanho de um tile
    --gerar funcao indexToque que retorna indice de clique recebendo x e y
    
    -- com indice obtido verifica se algum dos 4 vizinhos eh falso e troca de lugar
    --funcao verificaNeigbor(dificuldade)
    --se for um movimento valido conta um contador de movimentos
    
    
    --apos isso verifica se os tiles estao ordenados encerrando o game
    --define variavel i = 1
    
    {{3,Q3},{2,Q2},{1,Q1}}
    
    {{1,Q1},{2,Q2},{3,Q3}}
    
    if true then
      resolvendo = false
      tFim = love.timer.getTime()
      terminado = true
    end
    ]]--
    end
  
    if terminado then
    --[[
      exibe resultados
      pontuação por tempo e qtd de movimentos
      
      botao para fechar a tela
    
    ]]--
      
    end
    
end

function love.draw()

  if selecionando then
  --desenha botoes
  
  
  
  
  end


  if resolvendo then
  --[[
  -- exibe tiles
  -- exibe qtd de movimentos
  ]]--
  
  
  
  end
  
  if terminado then
    --[[
      mostra pontuacao  e tempo
      quer reiniciar o jogo?
    ]]--
      
    end


end


function love.update (dt)
    
end
