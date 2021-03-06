math.randomseed (os.time())

-- definindo estados do jogo
local abertura = true
local selecionando = false
local resolvendo = false
local terminado = false

-- número para escolher fotos aleatória entre um total de imagens
local i_foto = math.random(4)
local imagem = love.graphics.newImage("Fotos/" .. i_foto .. ".jpg")

-- tamanho da tela
local w
local h

-- definindo elementos visuais do jogo
local tiles -- tabela de tiles
local dificuldade -- receba apenas valores 3, 4 ou 5
local tamanho_tile
local qnt_tiles

-- calculando placar de acordo com tempo e número de movimentos
local tInicio
local tFim
local duracao
local movimentos = 0
local pontuacao

-- elementos para escolha da dificuldade
local aviso_dificuldade
local botao_dificuldade
local roman = love.graphics.newFont("timesbd.ttf",25)
local descricao_dificuldade = love.graphics.newText(roman, "Escolha uma dificuldade")
local nivel_dificuldade = love.graphics.newText(roman, " ")

-- definindo escala para elementos visuais centralizados na tela
local molde_tabela_w = 559
local molde_tabela_h = 558
local escala = 0.621

local tela_inicial
local tela_final


function love.load ()
    
    love.window.setMode (1280,720)
    love.window.setTitle ("Deslize!")
    love.graphics.setBackgroundColor (1.0,1.0,1.0)
    
    w, h = love.graphics.getDimensions ()
    
    aviso_dificuldade = love.graphics.newImage("Assets/Escolha.png")
    botao_dificuldade = love.graphics.newImage("Assets/Botao_Dificuldade.png")
    molde_tabela = love.graphics.newImage("Assets/4.png") -- deixamos de usar?
    tela_inicial = love.graphics.newImage("Assets/Abertura.jpg")
    tela_final = love.graphics.newImage("Assets/Final.jpg")
    
    stencil = love.graphics.newFont("Assets/STENCIL.TTF", 30)

end


function troca_vizinho(indice)

    -- verifica se tile esquerda está vazia
    if (indice - 1) % dificuldade ~= 0 then
        if tiles[indice - 1].visivel == false then
            tiles[indice], tiles[indice - 1] = tiles[indice - 1], tiles[indice]
            movimentos = movimentos + 1
        end
    end

    -- verifica se tile direita está vazia
    if indice % dificuldade ~= 0 then
        if tiles[indice + 1].visivel == false then
            tiles[indice], tiles[indice + 1] = tiles[indice + 1], tiles[indice]
            movimentos = movimentos + 1
        end
    end

    -- verifica se tile superior está vazia
    if indice - dificuldade > 0 then
        if tiles[indice - dificuldade].visivel == false then
            tiles[indice], tiles[indice - dificuldade] = tiles[indice - dificuldade], tiles[indice]
            movimentos = movimentos + 1
        end
    end

    -- verifica se tile inferior está vazia
    if indice + dificuldade <= (dificuldade * dificuldade) then
        if tiles[indice + dificuldade].visivel == false then
            tiles[indice], tiles[indice + dificuldade] = tiles[indice + dificuldade], tiles[indice]
            movimentos = movimentos + 1
        end
    end

end

function embaralha_tabela(t)
    
    local j
 
    for i = #t, 2, -1 do
        j = math.random (i)
        t[i], t[j] = t[j], t[i]
    end
    
    -- confere se é solúvel
    local inversoes = 0
    
    for i = 1, #t-1 do              -- para cada peça da tabela, exceto a última
        if t[i].index ~= #t then    -- se o index dessa peça for diferente da quantidade de tiles
            for contador = i, #t do      -- para essa peça, repetindo um número de vezes igual à quantidade total de tiles
                if t[i].index > t[contador].index then
                    inversoes = inversoes + 1
                end
            end
        end
    end
    
    -- o algoritmo explicando a solução está citado nas referências da apresentação
    if dificuldade % 2 == 0 then
      for i = 1, #t do
        if t[i].visivel == false then
          if(math.ceil(i/ dificuldade) % 2 == 1 and inversoes % 2 == 1) then
            return t
          elseif (math.ceil(i/ dificuldade) % 2 == 0 and inversoes % 2 == 0) then
            return t
          else
            t = embaralha_tabela(t)
            return t
          end
        end
      end
    
    else -- If the grid width is odd, then the number of inversions in a solvable situation is even.
      if inversoes % 2 == 0 then
          return t
      else
          t = embaralha_tabela(t)
          return t
      end
    end
    
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
    
    if key == 'k' then -- modo teste
        if selecionando then
            dificuldade = 2
            tiles = gera_quads(dificuldade)
            tiles = embaralha_tabela(tiles)
            tInicio = love.timer.getTime()
            selecionando = false
            resolvendo = true
      end        
    end
    
    if key == 'y' then -- resolve direto
      if resolvendo then
        resolvendo = false
        tFim = love.timer.getTime()
        duracao = tFim - tInicio
        terminado = true
        pontuacao = 0
      end
    end
    
end

function verifica_clique_dificuldade (x,y)

    local offset = 450
    local button_w = 2388 * 0.125
    local button_h = 578 * 0.125
    for dificuldade = 3, 5, 1 do
      -- verifica se coordenadas do mouse tocaram em algum botao
        if x > (w/2) - offset and x < (w/2) - offset + button_w and y > h/2 and y < h/2 + button_h then
            return dificuldade
        end
    offset = offset - 300
    end

    -- se nao achar retorna -1
    return -1
end

function gera_quads() -- dificuldade pode ser 3, 4 ou 5
  
    -- define quantidade de tiles
    qnt_tiles = dificuldade * dificuldade
  
    tamanho_tile = 900/dificuldade
  
    local x = 0
    local y = 0
  
    -- loop para definir os quads em referencia a resolução
    tiles = {}
    for i=1, qnt_tiles do
        local tile_atual = love.graphics.newQuad(x, y, tamanho_tile, tamanho_tile, 900, 900)
    
        tiles[#tiles+1] = {index = i, quad = tile_atual, visivel = true}
    
        if x == (900 - tamanho_tile) then -- passar para próxima linha
            x = 0
            y = tamanho_tile + y
        else -- siga pela linha
            x = tamanho_tile + x
        end
    end

    -- deixa o ultimo invisível
    tiles[#tiles].visivel = false

    return tiles
end

function verifica_vitoria()
      
    for i=1, qnt_tiles do
        if tiles[i].index ~= i then
            return false
        end
    end

    return true
end

function love.mousepressed (x, y, bt)
    
    if bt ~= 1 then return -- verifica se é botão esquerdo
    end
  
    if selecionando then
        
        dificuldade = verifica_clique_dificuldade (x,y)
      
        if dificuldade == -1 then return 
        end
    
        tiles = gera_quads(dificuldade)
      
        tiles = embaralha_tabela(tiles)
      
        tInicio = love.timer.getTime()
        selecionando = false
        resolvendo = true
    end
    
    if resolvendo then
     
        local movimentar = verifica_clique_painel(x,y)
        if movimentar == -1 then return
        end
    
        troca_vizinho(movimentar)
    
        if verifica_vitoria() then
            resolvendo = false
            tFim = love.timer.getTime()
            duracao = tFim - tInicio
            pontuacao = 300 * dificuldade - movimentos - math.ceil(duracao)
            if pontuacao < 0 then
                pontuacao = 0
            end
            terminado = true
        end
    
    end
    
end

function verifica_clique_painel(x, y)
    local borda_x = (w/2 - (molde_tabela_w/2))
    local borda_y = (h/2 - (molde_tabela_h/2))
    -- confere se o clique foi dentro do painel
    if x > borda_x and x < borda_x + molde_tabela_w and y > borda_y and y < borda_y + molde_tabela_h then
        local x = x - borda_x
        local y = y - borda_y
        local indice = math.ceil (x / (tamanho_tile * escala))
        indice = indice + (math.ceil (y / (tamanho_tile * escala)) - 1) * dificuldade
        if indice > 0 and indice <= (dificuldade * dificuldade) then
          return indice
        end
    end
    return -1
end

function love.draw() -- tirei o parâmetro daqui
    
    if abertura then
        love.graphics.draw(tela_inicial, 0, 0, 0, 1, 1)
    end
    

    if selecionando then
        -- tela de fundo
        love.graphics.draw(tela_final, 0, 0, 0, 1, 1)
        
        -- desenha aviso
        love.graphics.draw(aviso_dificuldade, (w/2) - 150, h/2 - 300, 0, 0.125, 0.125)
        love.graphics.setColor (0.0 , 0.0 , 0.0)
        love.graphics.draw(descricao_dificuldade, (w/2) - 137, h/2 - 280, 0)
        love.graphics.setColor (1.0 , 1.0 , 1.0)
      
        -- desenha botoes
        local dificuldade
        local offset = 450
        for dificuldade = 3, 5 do
            love.graphics.draw(botao_dificuldade, (w/2) - offset, h/2, 0, 0.125, 0.125)
            local s = string.format("%d", (dificuldade))
            nivel_dificuldade:set(s)
            love.graphics.setColor (0.0, 0.0, 0.0)
            love.graphics.draw(nivel_dificuldade,(w/2) - offset + 140, h/2 + 20, 0)
            love.graphics.setColor (1.0, 1.0, 1.0)
            offset = offset - 300
        end
    end

    if resolvendo then
        
        -- tela de fundo
        love.graphics.draw(tela_final, 0, 0, 0, 1, 1)
        love.graphics.setColor (1, 1, 1, 1)
        -- base branca para transparência
        love.graphics.rectangle('fill', (w/2) - molde_tabela_w/2, h/2 - molde_tabela_h/2, 900 * escala, 900 * escala)
        -- transparência da tile vazia
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.draw(imagem, (w/2) - molde_tabela_w/2, h/2 - molde_tabela_h/2, 0, escala)
        love.graphics.setColor(1, 1, 1, 1)
        
        local tile_index
  
        local x_exibe = w/2 - molde_tabela_w/2
        local y_exibe = h/2 - molde_tabela_h/2
    
        for tile_index = 1, qnt_tiles do
            if tiles[tile_index].visivel then
                love.graphics.draw(imagem, tiles[tile_index].quad, x_exibe, y_exibe, 0, escala, escala)
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
        
        -- tela de fundo
        love.graphics.setColor(1,1,1)
        love.graphics.draw(tela_final, 0, 0, 0, 1, 1)
   
        -- imagem concluída
        love.graphics.draw(imagem, (w/2) - molde_tabela_w/2, h/2 - molde_tabela_h/2, 0, escala)
   
        -- textos da tela final
        local texto_terminou = love.graphics.newText(stencil, "Terminou usando \n"..math.ceil(duracao).. " segundos \ne "..movimentos.. " movimentos \n\n\nSua pontuação foi "..pontuacao)
        love.graphics.draw(texto_terminou, w/2 - 600, h/2 + 155)
        local texto_pontuacao = love.graphics.newText(stencil, "Sua pontuação foi "..pontuacao)
        --love.graphics.draw(texto_pontuacao, w/2 - 550, h/2 + 200)
        local texto_rejogar = love.graphics.newText(stencil, "\n\n\nPressione 'r' para reiniciar")
        love.graphics.draw(texto_rejogar, w/2 + 160, h/2 + 215)
    end
  
end
