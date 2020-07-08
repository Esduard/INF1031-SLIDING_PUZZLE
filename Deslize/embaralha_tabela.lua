function embaralha_tabela(t)
 
    if (type(t) ~= "table") then
        print ("ERRO: função shuffle_table() precisa receber uma tabela")
        return false
    end
 
    local j
 
    for i = #t, 2, -1 do
        j = math.random (i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

math.randomseed (os.time()) --conferir se está no load
