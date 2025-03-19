-- title:   Treumax Algorithm
-- author:  Angelo M Pavan (Papa)
-- script:  lua

-- OBS: arrays comecam em 1 em lua

-- *** ETAPAS DO PROJETO ***:
-- desenhar o mapa OK
-- desenhar o robo OK
-- movimentar o robo com setas do keyboard (inicialmente) OK
-- pintar as casas por onde o robo passa OK
-- implementar sistema de deteccao dos blocos ao redor OK
-- elaborar uma estrutura que relacione as medidas com a tomada de decisao OK
-- trocar o controle pelo keyboard pelo algoritmo treumax 
-- ajustes finos

-- sprites:
spr_chao = 0
spr_mark = 1
spr_robo = 32
spr_parede = 16
spr_inicio = 17
spr_fim = 18
spr_double_mark = 2

-- tabela do robo
robo = {
    id = spr_robo,
    passo = 8, -- trocar o passo para 8 para movimentar de bloco em bloco
    x = 24, -- posicao x inicial
    y = 120 -- posicao y inicial
}

acabou = 0

function olha_ao_redor()
    frente_x, frente_y = game2mapXY(robo.x, robo.y-robo.passo)
    direita_x, direita_y = game2mapXY(robo.x+robo.passo, robo.y)
    tras_x, tras_y = game2mapXY(robo.x, robo.y+robo.passo)
    esquerda_x, esquerda_y = game2mapXY(robo.x-robo.passo, robo.y)

    id_frente = mget(frente_x, frente_y)
    id_direita = mget(direita_x, direita_y)
    id_tras = mget(tras_x, tras_y)
    id_esquerda = mget(esquerda_x, esquerda_y)

    return {id_frente, id_direita, id_tras, id_esquerda}
end

function decide_caminho()
    redor = olha_ao_redor()
    for f=1,4 do
        if redor[f]==spr_fim then
            acabou=1
            andar(f)
        end
    end
    if acabou == 0 then
        ha_marcado = 0
        andei = 0
        for i=1,4 do
            if redor[i]==spr_chao then
                andar(i)
                andei = 1
                break
            elseif redor[i]==spr_mark then ha_marcado=1
            end
        end
        if ha_marcado==1 and andei==0 then
            for j=1,4 do
                if redor[j]==spr_mark then
                    andar(j)
                    andei = 1
                    break
                end
            end
        end
    end
    
end

function andar(i)
    paint()
    if i==1 then robo.y=robo.y-robo.passo end
    if i==3 then robo.y=robo.y+robo.passo end
    if i==4 then robo.x=robo.x-robo.passo end
    if i==2 then robo.x=robo.x+robo.passo end
end

function game2mapXY(x,y)
    return math.floor(x/8), math.floor(y/8)
end

function paint()
    x,y = game2mapXY(robo.x, robo.y)
    id2Bpainted=mget(x,y)
    if id2Bpainted==spr_mark then mset(x,y,spr_double_mark) end
    r = olha_ao_redor()
    contador = 0
    for i=1,4 do
        if r[i]==spr_parede or r[i]==spr_double_mark then contador=contador+1 end
    end
    if id2Bpainted==spr_chao then 
        if contador<3 then mset(x,y,spr_mark)
        else mset(x,y,spr_double_mark) end
    end

end

t=0
function TIC()
    t=t+1
    if(t%5 == 0) then
        map(0,0)
        spr(robo.id, robo.x, robo.y)
        decide_caminho()
    end
end
