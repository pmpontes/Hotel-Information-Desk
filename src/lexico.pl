% determinantes
determinante(s-m) --> [o].
determinante(s-f) --> [a].
determinante(p-m) --> [os].
determinante(p-f) --> [as].
determinante(s-m) --> [um].
determinante(s-f) --> [uma].
determinante(p-m) --> [uns].
determinante(p-f) --> [umas].

% pronome
pronome(_) --> [que].

% pronomes interrogativos
pron_int(s-_, listar, qual) --> [qual].
pron_int(p-_, listar, quais) --> [quais].
pron_int(_, listar, que) --> [que].
pron_int(s-m, somar, quanto) --> [quanto].
pron_int(p-m, contar, quantos) --> [quantos].
pron_int(p-f, contar, quantas) --> [quantas].
pron_int(_, localizar, onde) --> [onde].

% numeros
num(_, 1) -->   [1].
num(_, 2) -->   [2].
num(_, 3) -->   [3].
num(_, 4) -->   [4].
num(_, 5) -->   [5].
num(_-m, 1) -->   [um].
num(_-m, 2) -->   [dois].
num(_-f, 2) -->   [duas].
num(_, 3) -->   [tres].

% preposições
prep(_-f) -->  [a].
prep(_) -->  [de].
prep(_-m) -->  [do].
prep(_-f) -->  [da].
prep(_) -->  [com].
prep(_) -->  [em].
prep(s-m) -->  [no].
prep(s-f) -->  [na].

% nomes (serviços)
nome(s-m, babysitting)   -->   [babysitting].
nome(s-f, vista)   -->   [vista].
nome(s-f, mar)   -->   [mar].
nome(s-m, jardim)   -->   [jardim].
nome(s-_, wireless)   -->   [wireless].
nome(s-m, servico)   -->   [servico].
nome(p-m, servico)   -->   [servicos].

% nomes (localização)
nome(s-f, localizacao)   -->   [localizacao].
nome(s-G, porto)   --> [porto], {nonvar(G), G=m}.
nome(s-G, lisboa)   -->  [lisboa], {var(G)}.
nome(s-G, aveiro)   -->  [aveiro], {var(G)}.
nome(s-G, viana)   -->  [viana], {var(G)}.

% nomes (área vocabular de hotel)
nome(s-m, hotel)   -->   [hotel].
nome(p-m, hotel)   -->   [hoteis].
nome(s-m, quarto)   -->   [quarto].
nome(p-m, quarto)   -->   [quartos].
nome(s-f, estrela)   -->   [estrela].
nome(p-f, estrela)   -->   [estrelas].
nome(s-f, suite)   -->   [suite].
nome(p-f, suite)   -->   [suites].
nome(s-f, categoria)   -->   [categoria].
nome(s-m, preco)   -->   [preco].
nome(p-m, preco)   -->   [precos].

% nomes (hoteis)
nome(s-m, moliceiro)   -->   [moliceiro].

% adjetivos
adj(s-m, tipo, duplo) --> [duplo].
adj(p-m, tipo, duplo) --> [duplos].
adj(_, tipo, single) --> [single].
adj(s-_, localizacao, porto) --> [portuense].
adj(p-_, localizacao, porto) --> [portuenses].
adj(s-_, localizacao, viana) --> [vianense].
adj(p-_, localizacao, aveiro) --> [vianenses].
adj(s-_, localizacao, aveiro) --> [aveirense].
adj(p-_, localizacao, aveiro) --> [aveirenses].

% adjetivos comparativos
adj_comp(maior)   -->   [superior], [a].
adj_comp(menor)   -->   [inferior], [a].
adj_comp(igual)   -->   [igual], [a].

% verbos
verbo(s, custa)   -->   [custa].
verbo(p, disponibiliza)   -->   [oferecem].
verbo(s, disponibiliza)   -->   [oferece].
verbo(s, disponibiliza)   -->   [disponibiliza].
verbo(p, disponibiliza)   -->   [disponibilizam].
verbo(s, disponibiliza)   -->   [possui].
verbo(p, disponibiliza)   -->   [possuem].
verbo(s, categoria)   -->   [possui].
verbo(p, categoria)   -->   [possuem].
verbo(_, categoria)   -->   [tem].
verbo(_, disponibiliza)   -->   [tem].
verbo(_, disponibiliza)   -->   [ha].
verbo(s, localizacao)   -->   [fica].
verbo(p, localizacao)   -->   [ficam].
verbo(_, localizacao)   -->   [ha].
verbo(s, localizacao)   -->   [encontra-se].
verbo(s, ser)   -->   [e_].   % TODO correct
verbo(p, ser)   -->   [sao].
verbo(s, localizacao)   -->   [esta].
verbo(p, localizacao)   -->   [estao].
