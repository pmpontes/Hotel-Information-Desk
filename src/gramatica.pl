:-include('lexico.pl').
:-include('dados.pl').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frase
frase(interrogacao, TipoQ, Q) --> frase_int(TipoQ, Q), ([?]; []).
frase(afirmacao, _, Q) --> frase_afir([], Q), ([.]; [?]; []).
frase(declaracao, _, Q) --> frase_afir([], Q), [;].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interrogações
frase_int(contexto, [_, ROut]) --> [e], modificador_nominal_ext(_, [], ROut).
frase_int(TipoQ, [At, ROut]) --> sint_inter(_, At, [], R1, TipoQ, que), sint_verbal_ext(_, At, R1, ROut).
frase_int(TipoQ, [At, ROut]) --> sint_inter(_, At, [], R1, TipoQ, qual), sint_verbal_ext(_, At, R1, ROut).
frase_int(TipoQ, [At, ROut]) --> sint_inter(N, At, [], R1, TipoQ, Pi), {Pi \= que, Pi\= qual}, sint_verbal_ext(N, At, R1, ROut).

sint_inter(N, At, RIn, ROut, TipoQ, Pi) --> pron_int(N-G, TipoQ, Pi), sint_nominal_inter(N-G, At, RIn, ROut).
sint_inter(N, _, R, R, TipoQ, Pi) --> pron_int(N-_, TipoQ, Pi).

sint_nominal_inter(N-G, At, RIn, [At-ROut | RIn]) --> (verbo(N, ser) ; []), determinante(N-G), nome(N-G, At), modificador_nominal_ext(N-G, [], ROut), (pronome(N-G); []). % Quais [são] os hotéis [do porto] que, Qual [é] o hotel que é, Qual a localização do hotel moliceiro  ...
sint_nominal_inter(N-_, At, RIn, [At-ROut | RIn]) --> nome(N-_, At), modificador_nominal_ext(N-_, [], ROut). % Quanto custa, Que serviços disponibiliza,...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% afirmações
frase_afir(RIn, ROut) --> sint_nominal(N, RIn, R1), sint_verbal_ext(N, _,R1, ROut).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sintagma verbal
sint_verbal_ext(N, At, RIn, ROut) --> sint_verbal(N, At, RIn, R1), sint_verbal_ext(N, At, R1, ROut).
sint_verbal_ext(N, At, RIn, ROut) --> [e], sint_verbal_ext(N, At, RIn, ROut).
sint_verbal_ext(_, _, R, R) --> [].

sint_verbal(N, _, RIn, [ROut | RIn]) --> (verbo(N, ser); []), sint_nominal(N, [], ROut).
sint_verbal(_, _, RIn, [ROut | RIn]) --> prep(N), sint_nominal(N, [], ROut).
sint_verbal(N, _, RIn, [A-ROut | RIn]) --> verbo(N, A), sint_nominal(_, [], ROut), {A\=ser, verificacao_semantica(A, ROut)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sintagma nominal
sint_nominal(N, RIn, [S-ROut | RIn]) --> det(N-G), nome(N-G, S), modificador_nominal_ext(N-G, [], ROut).
sint_nominal(N, RIn, [categoria-[igual-Valor]|RIn]) --> (prep(_); []), num(N-G, Valor), nome(N-G, estrela). % hoteis de/com 3 estrelas, hotel possui 2 estrelas..

det(N-G)--> determinante(N-G).
det(N-G)--> prep(N-G).
det(_)--> [].

modificador_nominal_ext(N-G, RIn,ROut) --> modificador_nominal(N-G, RIn, R1), modificador_nominal_ext(N-G, R1, ROut).
modificador_nominal_ext(N-G, RIn,ROut) --> [e], modificador_nominal(N-G, RIn, ROut).
modificador_nominal_ext(_, R,R) --> [].

modificador_nominal(N-G, RIn, [Restricao-Valor|RIn]) --> adj(N-G, Restricao, Valor). % hoteis portuenses...
modificador_nominal(_, RIn, [Restricao-Valor|RIn]) --> adj_comp(Restricao), num(N-G, Valor), (nome(N-G, estrela); []). % hotel de/com categoria inferior a 4 estrelas

modificador_nominal(_, RIn, [categoria-[igual-Valor]|RIn]) --> (prep(_); []), num(N-G, Valor), nome(N-G, estrela). % hoteis de/com 3 estrelas, hotel possui 2 estrelas..
modificador_nominal(_, RIn, [categoria-[Restricao-Valor]|RIn]) --> prep(N-G), nome(N-G, categoria), adj_comp(Restricao), num(N1-G1, Valor), (nome(N1-G1, estrela); []). % hotel de/com categoria inferior a 4 estrelas

modificador_nominal(_, RIn, [vista-Valor|RIn]) --> prep(N-G), nome(N-G, vista), det(N1-G1), nome(N1-G1, Valor). % hoteis com vista de mar/rio/jardim

modificador_nominal(_, RIn, [localizacao-Valor|RIn]) --> prep(N-G), nome(N-G, Valor), {localizacao(_, Valor)}. % hoteis do/no porto...

modificador_nominal(_, RIn, [nome-Valor|RIn]) --> prep(N-G), nome(N-G, hotel), nome(_, Valor). % hotel moliceiro...
modificador_nominal(_, RIn, [nome-Valor|RIn]) --> nome(_, Valor). % hotel moliceiro...

modificador_nominal(_, RIn, [Valor|RIn]) --> prep(N-G), nome(N-G, Valor), { \+ localizacao(_, Valor)}.


verificacao_semantica(disponibiliza, [S-_]):- !, (S = servico; S=hotel).
verificacao_semantica(categoria, [S-_]):- !, S = categoria.
verificacao_semantica(_, _).
