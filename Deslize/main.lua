--importacoes


-- definindo estados do jogo
local abertura = true
local selecionando = false
local resolvendo = false
local terminado = false

local imagem = love.graphics.newImage("Cachorro.jpg")

local w
local h


local tiles -- tabela de tiles
local dificuldade -- receba apenas valores 3, 4 ou 5
local tamanho_tile
local qnt_tiles

local tInicio
local tFim

local aviso_dificuldade
local botao_dificuldade


local roman = love.graphics.newFont("timesbd.ttf",25)
local descricao_dificuldade = love.graphics.newText(roman, "Escolha uma dificuldade")
local nivel_dificuldade = love.graphics.newText(roman, " ")

local molde_tabela_w = 559
local molde_tabela_h = 558
local escala = 0.621

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

function embaralha_tabela(t)
    --[[
    if (type(t) ~= "table") then
        print ("ERRO: função shuffle_table() precisa receber uma tabela")
        return false
    end
    ]]--
    local j
 
    for i = #t, 2, -1 do
        j = math.random (i)
        t[i], t[j] = t[j], t[i]
    end
    return t
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

function geraQuad() --dificuldade pode ser 3, 4 ou 5
  
  
  --define quantidade de tiles
  qnt_tiles = dificuldade * dificuldade
  
  tamanho_tile = 900/dificuldade
  
  local x = 0
  local y = 0
  
  -- loop para definir os quads em referencia a resolução
  tiles = {}
  for i=1, qnt_tiles do
    tile_atual = love.graphics.newQuad(x ,y,tamanho_tile,tamanho_tile ,900 ,900)
    
    tiles[#tiles+1] = { index = i, quad = tile_atual, visivel = true}
    
    if(x == 900 - tamanho_tile) then --passar para proxima linha
      x = 0
      y = tamanho_tile + y
    else --siga pela linha
      x = tamanho_tile + x
    end
    
    
  end

  --deixa o ultimo invisivel
  tiles[#tiles].visivel = false

  return tiles
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
        
      dificuldade = verificaCliqueDificuldade (x,y)
      
      if dificuldade == -1 then return 
      end
    
      tiles = geraQuad(dificuldade)
      
      tiles = embaralha_tabela(tiles)
      
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
    verifica_cliquePainel(x,y)
    
    end
  
    if terminado then
    --[[
      exibe resultados
      pontuação por tempo e qtd de movimentos
      
      botao para fechar a tela
    
    ]]--
      
    end
    
end

function verifica_cliquePainel(x, y)
    local borda_x = (w/2 - (molde_tabela_w/2)) -- colocar variável borda como local externa
    local borda_y = (h/2 - (molde_tabela_h/2)) -- colocar variável borda como local externa
    if x > borda_x and x < borda_x + molde_tabela_w and y > borda_y and y < borda_y + molde_tabela_h then --clicamos dentro do painel
        local x = x - borda_x
        local y = y - borda_y
        local indice = math.ceil (x / (tamanho_tile * escala)) -- colcoar variável tamanho como local externa
        indice = indice + (math.ceil (y / (tamanho_tile * escala)) - 1) * dificuldade
        if indice > 0 and indice <= (dificuldade * dificuldade) then
          return indice
        end
    end
    return false
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
    --[[
    -- exibe tiles
        x = 0 , y =0
        --realiza um loop´pela lista de tiles
        
        {{3,Q3,true},{2,Q2,true},{1,Q1,true},{1,Q1,true},{1,Q1,true},{1,Q1,true},{1,Q1,true},{9,Q1,false},{1,Q1,true},}
    
    -- exibe qtd de movimentos
    ]]--
  
    love.graphics.setColor(1, 1, 1, 95)
    love.graphics.draw(molde_tabela ,(w/2) - molde_tabela_w/2 ,h/2 - molde_tabela_h/2,0)
    love.graphics.setColor(1, 1, 1, 1)
  
    local tile_index
  
    local x_exibe = w/2 - molde_tabela_w/2
    local y_exibe = h/2 - molde_tabela_h/2
    for tile_index = 1, qnt_tiles do
      print('cehguei')
      if tiles[tile_index].visivel then
        love.graphics.draw(imagem,tiles[tile_index].quad ,x_exibe ,y_exibe,0,escala,escala)
      end
        if tile_index % dificuldade == 0 then --passar para proxima linha
          x_exibe = w/2 - molde_tabela_w/2
          y_exibe = tamanho_tile * escala + y_exibe
        else --siga pela linha
          x_exibe = tamanho_tile * escala + x_exibe
        end
      
    end
  
  end
  
  if terminado then
    --[[
      mostra pontuacao  e tempo
    ]]--
      
  end


end


function love.update (dt)
    
end
