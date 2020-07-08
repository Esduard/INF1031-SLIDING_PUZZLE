function verifica_clique (x, y)
    local borda = (w - 900) / 2 -- colocar variável borda como local externa
    if (x, y) >= borda and (x, y) <= (900 + borda) then --falta conferir a escrita da condição
        local x = x - borda
        local y = y - borda
        local indice = math.ceil (x / tamanho) -- colcoar variável tamanho como local externa
        local indice = indice + (math.ceil (y / tamanho) - 1) * 3
        return indice
    end
    return false
end
