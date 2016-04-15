%%%
% gramatica
%%%
conjuncao(_) --> [e].

determinante(s-m) --> [o].
determinante(p-m) --> [os].
determinante(s-f) --> [a].
determinante(p-f) --> [as].

preposicao(_) --> [de].
preposicao(s-f) --> [da].
preposicao(s-m) --> [do].
preposicao(p-f) --> [das].
preposicao(p-m) --> [dos].

pron_inter(_-_) --> [quem].
pron_inter(p-_) --> [quais].
pron_inter(p-_) --> [que].
pron_inter(p-m) --> [quantos].
pron_inter(p-f) --> [quantas].

pronome(_) --> [que].

nome(s-f) --> [viana].
nome(s-f) --> [estrela].
nome(p-f) --> [estrelas].
nome(s-m) --> [porto].
nome(s-m) --> [aveiro].
nome(s-m) --> [viana].
nome(s-m) --> [hotel].
nome(p-m) --> [hoteis].
nome(s-m) --> [servico].
nome(p-m) --> [servicos].

verbo(s) --> [fica].
verbo(s) --> [disponibiliza].
verbo(p) --> [disponibilizam].
verbo(s) --> [possui].
verbo(p) --> [possuem].
verbo(p) --> [sao].

adjetivo(_) --> [superior].
adjetivo(_) --> [inferior].
adjetivo(_) --> [igual].

adjetivo(s) --> [portuense].
adjetivo(p) --> [portuenses].
adjetivo(s) --> [aveirense].
adjetivo(p) --> [aveirenses].
adjetivo(s) --> [vianense].
adjetivo(p) --> [vianenses].


frase --> sn(N, G), sv(N, G), {write(true)}.
frase --> sv(N, G), {write(true)}.

sn(N, G) --> determinante(N-G), nome(N-G).
sn(N, G) --> nome(N-G).

sv(N, G) --> verbo(N), sn(_, G), [e], frase.
sv(N, G) --> verbo(N).


/*

Quantos (são) os hotéis do Porto?
Quais (são) os hotéis de categoria superior a 3 estrelas em Lisboa?
E em Coimbra?
Que/Quais serviços disponibiliza o Hotel X?
Quais os hotéis parisienses que possuem serviço de babysitting?
Quais os hotéis de Faro que possuem categoria inferior a 4 e quartos com vista de mar?
O Hotel X fica em Faro e possui 4 estrelas.
Qual a localizacao do Hotel X?

frase --> sn_1(N), sv(_,N,N1,V), {write(true)}. %a eva mora no paraíso
frase --> frase_int(PI), frase_perg(PI). % Quantos (são) os hotéis do Porto?

sn_1([N1]) --> frase_n_1(N1).
sn_1([N1|R]) --> frase_n_1(N1), [e], sn_1(R).

frase_n_1(N)--> artigo(N,A), nome_adj(N). % a  eva linda
frase_n_1(N)--> artigo(N,A), nome_adj(N), relativo, sv([N],[N1],V),
{analisa_af([N],[N1],V)}. % a eva que conhece o adão

nome_adj(N)-->nome(N). %categoria
nome_adj(N)--> nome(N), adj(N,Adj). %mulher bonita


frase-_int(que)-> [que].
Aplicação
frase-_int(que)-> [o,que,é,que].
frase-_int(quais)-> [quais].
frase-_int(quantos)-> [quantos].
frase_int(quem)-> [quem].
frase_perg(PI)-->  sv(…).
{analisa_int(V,N,L), resposta(L,PI)}. %quem mora no paraíso
sv(L,N,N1,V)--> frase_verbo(L,N,N1,V). % ex:N=eva, N1=adão, V=conhece ou mora
sv(L,N,N1,V)--> frase_verbo(L1,N,N1,V), [e],     % Quem  mora e
sv(L2,N,N2,V1), %trabalha no porto
{intersecta(L1,L2,L)}.
frase_verbo(L,N,N1,V)-->v_adv(L,N,N1,Adv,V), sn_2(N1),
{analisa_af(N,N1,V) ; write(“não concordo”)}.
frase_verbo(L,N,N1,V)-->….

vmora([],_,L).
resposta(L,PI):- PI = = quantos,!, contar(L,0,Q), write(Q).
contar([],Q,Q).      contar([P|R],S,Q):-nonvar(P), NS is S+1, contar(R,NS,Q),!.
analisa_af(N,N1,_-_-mora):-vmora(N,N1,L). % verificação de afirmação de morar
vmora([_-_-X|R], _-_-Y, Z):- mora(X,Y),vmora(R,_-_-Y,[X|Z]).
mora(X,Y):- humano(X), local(Y), l_mora(X,Y).
l_mora(eva,paraíso).        l_mora(adão,paraíso).
analisa_int(_-_-V,_-_-X, L):- verifica_todos(V,X,L).
verifica_todos(sao,X,L):- setof(X1,ser(X1,X),L). % ser(rui,aluno).
verifica_todos(mora,X,L):- setof(X1,l_mora(X1,X),L).
*/
