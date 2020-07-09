--importacoes


-- definindo estados do jogo
local abertura = true
local selecionando = false
local resolvendo = false
local terminado = false

local w
local h


local tiles -- tabela de tiles
local dificuldade -- receba apenas valores 3, 4 ou 5

local tInicio
local tFim

local aviso_dificuldade
local botao_dificuldade


local roman = love.graphics.newFont("timesbd.ttf",25)
local descricao_dificuldade = love.graphics.newText(roman, "Escolha uma dificuldade")
local nivel_dificuldade = love.graphics.newText(roman, " ")

function verifica_vizinho(indice)
  
  --verifica se tile esquerda esta vazia
  if tiles[indice - 1].visivel == false and (indice - 1) % dificuldade ~= 0 then
    return true
  end
  
  --verifica se tile direita esta vazia
  if tiles[indice + 1].visivel == false and indice % dificuldade ~= 0 then
    return true
  end
  
  --verifica se tile superior esta vazia
  if tiles[indice - dificuldade].visivel == false and indice - dificuldade > 0 then
    return true
  end
  
  --verifica se tile inferior esta vazio
  if tiles[indice + dificuldade].visivel == false and indice + dificuldade <= (dificuldade * dificuldade) then
    return true
  end

end

function love.load ()
    love.window.setMode (1280,720)
    love.window.setTitle ("Deslize")
    love.graphics.setBackgroundColor (1.0,1.0,1.0)
    
    
    w, h = love.graphics.getDimensions ()
    math.randomseed (os.time())
end

function love.keypressed (key)
    if key == 'return' then
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

function verificaCliqueDificuldade (x,y)

  local offset = 450
  local button_w = 2388 * 0.125
  local button_h = 578 * 0.125
    for dificuldade = 3, 5, 1 do
      --verifica se coordenadas do mouse tocaram em algum botao
      if x > (w/2) - offset and x < (w/2) - offset + button_w and y > h/2 and y < h/2 + button_h then
        return dificuldade
      end
      offset = offset - 300
    end

    --se nao achar retorna -1
    return -1
end

function geraQuad(dificuldade) --dificuldade pode ser 3, 4 ou 5
  
  
  --define quantidade de tiles
  qnt_tiles = dificuldade * dificuldade
  
  tamanho = 900/dificuldade
  
  local x = 0
  local y = 0
  
  -- loop para definir os quads em referencia a resolução
  tiles = {}
  for i=1, qnt_tiles do
    tile_atual = love.graphics.newQuad(x,y,tamanho,tamanho,900,900)
    
    tiles[#tiles+1] = { index = i, quad = tile_atual, visivel = true}
    
    if(x == 900 - tamanho) then --passar para proxima linha
      x = 0
      y = tamanho + y
    else --siga pela linha
      x = tamanho + x
    end
    
    
  end

  --deixa o ultimo invisivel
  tiles[#tiles].visivel = false

  return
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
        tInicio = love.timer.getTime()
        resolvendo = true
        --]]
        
      local dificuldade = verificaCliqueDificuldade (x,y)
      
      if dificuldade == -1 then return 
      end
    
      tiles = geraQuad(dificuldade)
      
      tInicio = love.timer.getTime()
      selecionando = false
      resolvendo = true
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

function love.draw(aviso_dificuldade)

  aviso_dificuldade = love.graphics.newImage("7.png")
  botao_dificuldade = love.graphics.newImage("5.png")
  molde_tabela = love.graphics.newImage("4.png")

  if selecionando then
    --desenha aviso
    love.graphics.draw(aviso_dificuldade,(w/2) - 150 ,h/2 - 300,0,0.125,0.125)
    love.graphics.setColor (0.0 , 0.0 , 0.0)
    love.graphics.draw(descricao_dificuldade,(w/2) - 140 ,h/2 - 290,0)
    love.graphics.setColor (1.0 , 1.0 , 1.0)
  
    --desenha botoes
    local dificuldade
    local offset = 450
    for dificuldade = 3, 5, 1 do
      love.graphics.draw(botao_dificuldade,(w/2) - offset,h/2 ,0,0.125,0.125)
      local s = string.format("%d", (dificuldade))
      nivel_dificuldade:set(s)
      love.graphics.setColor (0.0 , 0.0 , 0.0)
      love.graphics.draw(nivel_dificuldade,(w/2) - offset + 150,h/2 + 10 ,0)
      love.graphics.setColor (1.0 , 1.0 , 1.0)
      offset = offset - 300
    end
  
  end


  if resolvendo then
    local molde_tabela_w = 559
    local molde_tabela_h = 558
  --[[
  -- exibe tiles
  -- exibe qtd de movimentos
  ]]--
  love.graphics.draw(molde_tabela ,(w/2) - molde_tabela_w/2 ,h/2 - molde_tabela_h/2,0)
  
  
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
