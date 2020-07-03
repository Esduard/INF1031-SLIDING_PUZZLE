--recebe nivel de dificulade e retorna uma tabela de elementos [quad,index] onde quad é um fragmento da imagem e index é a sua ordem da imagem

function geraQuad(dificuldade) --dificuldade pode ser 3, 4 ou 5

  --pega jpeg aleatorio de resolução 900x900
  imagem = love.graphics.newImage("Cachorro.png")
  
  
  --define quantidade de tiles
  tiles = dificuldade * dificuldade
  
  tamanho = 900/dificuldade
  
  local x = 0
  local y = 0
  
  -- loop para definir os quads em referencia a resolução
  quadros = {}
  for i=1, tiles do
    tile_atu = love.graphics.newQuad(x,y,tamanho,tamanho,900,900)
    
    quadros[#quadros+1] = { index = i, quad = tile_atu}
    
    if(x == 900 - tamanho) then --passar para proxima linha
      x=0
      y = tamanho + y
    else --siga pela linha
      x = tamanho + x
    end
    
    
  end

  return quadros
end