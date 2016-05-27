:-include('gramatica.pl').
:-use_module(library(lists)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% processar
processar(Frase, Resposta):-
  (frase(TipoF, TipoQ, Q, Frase, []), !,
  write('Frase valida;\n'), write(TipoF-TipoQ), write(':'), write(Q), !,
  analisar(TipoF, TipoQ, Q, Resposta);
  Resposta='Erro gramatical.'), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% contexto
:-dynamic(context/4).

novo_contexto(TipoQ, At, NewContext):-
  retractall(contexto(_, _, _)),
  assertz(contexto(TipoQ, At, NewContext)).
novo_contexto(_, _).

retomar_contexto(H1-L1-C1-S1-Q1, TipoQ, At, H2-L2-C2-S2-Q2):-
  contexto(TipoQ, At, H-L-C-S-Q),
  (var(H1), !, H2=H; H2=H1),
  (var(L1), !, L2=L; L2=L1),
  (var(C1), !, C2=C; C2=C1),
  (var(S1), !, S2=S; S2=S1),
  (var(Q1), !, Q2=Q; Q2=Q1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% responder
analisar(afirmacao, _, QIn, Resposta):-
prepare_query(QIn, QOut), !,
concordar(QOut, Resposta).

analisar(declaracao, _, QIn, Resposta):-
prepare_query(QIn, QOut),!,
memorizar(QOut, Resposta).

analisar(interrogacao, TipoQ, [At, QIn], Resposta):-
nl, write('BEFORE QUERY: '), write(QIn),nl,
prepare_query(QIn, QOut), !,
write('ATRIBUTO: '), write(At),nl,
(TipoQ=contexto, !,
  ( write('Contexto? '), retomar_contexto(QOut, TipoQ2, At, Q), nl, write('Contexto: '), write(Q));
  novo_contexto(TipoQ, At, QOut), Q=QOut, TipoQ2=TipoQ),
responder(TipoQ2, At, Q, Resposta).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prepare_query
prepare_query(QIn, H-L-C-S-Q):-
  flatten(QIn, QFlat), nl, write(QFlat),nl, !,
  parse(QFlat, _, H-L-C-S-Q), write('PARSED   '), write(H-L-C-S-Q), nl.

parse([], Final, Final).

parse([localizacao-[Local-[]] | R], H-_-C-S-Q, Final):-
  parse(R, H-Local-C-S-Q, Final).

parse([localizacao-Restricoes | R], H-_-C-S-Q, Final):-
  (atom(Restricoes), !,
    L=Restricoes ;
    parse(Restricoes, H-L-C-S-Q, Final)),
  parse(R, H-L-C-S-Q, Final).

parse([localizacao-[Local] | R], H-_-C-S-Q, Final):-
  parse(R, H-Local-C-S-Q, Final).

parse([localizacao-Local | R], H-_-C-S-Q, Final):-
  parse(R, H-Local-C-S-Q, Final).

parse([classificacao-[Comparacao-Valor] | R], H-L-_-S-Q, Final):-
  parse(R, H-L-[Comparacao-Valor]-S-Q, Final).

parse([hotel-HotelInfo | R], H-L-C-S-Q, Final):-
  parse(HotelInfo, H-L-C-S-Q, Final),
  parse(R, H-L-C-S-Q, Final).

parse([hotel | R], H-L-C-S-Q, Final):-
  parse(R, H-L-C-S-Q, Final).

parse([nome-Hotel | R], _-L-C-S-Q, Final):-
  parse(R, Hotel-L-C-S-Q, Final).

parse([disponibiliza-Servicos | R], H-L-C-S-Q, Final):-
  parse(Servicos, H-L-C-S-Q, Final),
  parse(R, H-L-C-S-Q, Final).

parse([ser-Restricoes | R], H-L-C-S-Q, Final):-
  parse(Restricoes, H-L-C-S-Q, Final),
  parse(R, H-L-C-S-Q, Final).

parse([categoria-[Restricao] | R], H-L-_-S-Q, Final):-
  parse(R, H-L-Restricao-S-Q, Final).

parse([categorizado-Restricoes | R], H-L-C-S-Q, Final):-
  parse(Restricoes, H-L-C-S-Q, Final),
  parse(R, H-L-C-S-Q, Final).

parse([quarto-Restricoes | R], H-L-C-S-Q, Final):-
  parse_quarto(Restricoes, _-_-[], Quarto),
  (var(Q), !,
  parse(R, H-L-C-S-[Quarto], Final) ;
  parse(R, H-L-C-S-[Quarto | Q], Final)).

parse([servico-Restricoes | R], H-L-C-_-Q, Final):-
  parse(R, H-L-C-Restricoes-Q, Final).

parse(R, Q, Q):- write('ERRO: Analise do pedido falhou: '), write(R).

parse_quarto([], Q, Q).
parse_quarto([vista-Restricao | R], Custo-Tipo-Car, QOut):-
  parse_quarto(R, Custo-Tipo-[Restricao | Car], QOut).

parse_quarto([tipo-Restricao | R],Custo-_-Car, QOut):-
  parse_quarto(R, Custo-Restricao-Car, QOut).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% concordar
concordar(H-L-C-S-Q, Resposta):-
  findall(H-L-C-S-Q, (hotel(H,L1,Cat,_,_), localizacao(L1, L), analisa_categoria(Cat, C), analisa_servicos(H, S), analisa_quartos(H, Q)), Resultados),
  length(Resultados, N),
  (N>=1, !,
  Resposta = 'Certo!';
  Resposta = 'Errado...').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% memorizar

memorizar(H-L-(igual-C)-S-Q, Resposta):-
  nonvar(H), nonvar(L), nonvar(C), var(S), var(Q),
  (adicionar_hotel(H, L, C), !,
    Resposta='Novo hotel criado.';
    Resposta=erro_memoria).

memorizar(H-_-(igual-C)-S-Q, Resposta):-
  nonvar(H), nonvar(C), var(S), var(Q),
  (classificar_hotel(H, C),!,
    Resposta='Categoria atualizada.';
    Resposta=erro_memoria).

memorizar(H-_-_-S-Q, Resposta):-
  nonvar(H), nonvar(S), var(Q),
  (adicionar_servicos_hotel(H, S),!,
    Resposta='Novo servico associado.';
    Resposta=erro_memoria).

memorizar(H-_-_-S-Q, Resposta):-
  nonvar(H), var(S), nonvar(Q),
  (adicionar_quartos(H, Q),!,
    Resposta='Novo quarto associado.';
    Resposta=erro_memoria).

memorizar(_, erro_memoria).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% responder
responder(localizar, localizacao, H-L-C-S-Q, Resposta):-
  encontrar(H-L-C-S-Q, Resultados),
  resposta(localizar, localizacao, Resultados, Resposta).

responder(TipoQ, At, H-L-C-S-Q, Resposta):-
  var(At), !,
  encontrar(H-L-C-S-Q, Resultados),
  resposta(TipoQ, At, Resultados, Resposta).

responder(TipoQ, At, H-L-C-S-Q, Resposta):-
  nonvar(At), !,
  encontrar(H-L-C-S-Q, Resultados),
  resposta(TipoQ, At, Resultados, Resposta).

encontrar(H-L-C-S1-Q1, Resultados):-
  findall(H-L-C-S-Q, (hotel(H,L1,Cat,S,Q), localizacao(L1, L), analisa_categoria(Cat, C), analisa_servicos(H, S1), analisa_quartos(H, Q1)), Resultados).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% resposta
resposta(listar, At, L, Resposta):-
  filtrar(L, At, [], Resposta).

resposta(localizar, localizacao, L, Resposta):-
  filtrar(L, localizacao, [], Resposta).

resposta(contar, At, L, Resposta):-
  filtrar(L, At, [], F),
  length(F, Resposta).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filtrar
% filtra os resultados obtidos para obter apenas o que foi pedido

filtrar(F, At, _, F):- var(At).

filtrar([], _, F, F).

filtrar([H-_-_-_-_ | R], hotel, T, F):-
  filtrar(R, hotel, [H | T], F).

filtrar([_-L-_-_-_ | R], localizacao, T, F):-
  filtrar(R, localizacao, [L | T], F).

filtrar([_-_-C-_-_ | R], categoria, T, F):-
  filtrar(R, categoria, [C | T], F).

filtrar([_-_-_-S-_ | R], servico, T, F):-
  obter_servicos(S, [], SOut),
  filtrar(R, servico, [SOut | T], F).

filtrar([_-_-_-_-Q | R], quarto, T, F):-
  filtrar(R, quarto, [Q | T], F).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analisa servicos
analisa_servicos(_, S):-
  var(S).
analisa_servicos(H, S):-
  nonvar(S), disponibiliza(H, S).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analisa quartos
analisa_quartos(_, Q):-
  var(Q).
analisa_quartos(H, Q):-
  nonvar(Q), quarto(H, Q).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analisa categoria
analisa_categoria(Categoria, R-V):-
  nonvar(R), nonvar(V), !,
  P =.. [R, Categoria, V],
  P.

analisa_categoria(_, R-V):-
  var(R), var(V), !.

igual(V, V).
maior(V1, V2):- V1 > V2.
menor(V1, V2):- V1 < V2.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% aux
:- op(400,xfx,\).

flatten(S,F) :-
  flatten_dl(S,F\[]).

flatten_dl([],X\X).
flatten_dl([X|Xs],Y\Z):-
   flatten_dl(X,Y\T),
   flatten_dl(Xs,T\Z).
flatten_dl(X,[X|Z]\Z).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tests

s(L, _):- processar(L, Resposta), nl, write('RESPOSTA: '), write(Resposta), nl.

test:-
  nl, write('verificacao de gramatica...'), nl, !,
  s([o, hotel, moliceiro, fica, em, porto],[]),!,
  s([o, hotel, moliceiro, fica, na, lisboa],[]),!,
  write('verificacao de gramatica concluida...'), nl, !,

  nl, write('verificacao de factos...'), nl, !,
  s([o, hotel, moliceiro, fica, em, aveiro],[]),!,
  s([o, hotel, moliceiro, fica, no, porto],[]),!,
  s([o, hotel, moliceiro, fica, em, aveiro, e, possui, 4, estrelas],[]),!,
  write('verificacao de factos concluida.'), nl, !,

  nl, write('verificacao de listagens...'), nl, !,
  s([onde, fica, o, hotel, moliceiro],[]),!,
  s([qual, a, localizacao, do, hotel, moliceiro],[]), !,
  s([quais, os, hoteis, portuenses, que, possuem, servico, de, babysitting, e, de,'wi-fi'],[]),!,
  s([quais, os, hoteis, que, disponibilizam, o, servico, de, 'wi-fi', e, tem, 5, estrelas],[]),!,
  s([quais, os, hoteis, de, lisboa, que, possuem, categoria, inferior, a, 4, e, quartos, executivos], []),!,
  write('verificacao de listagens concluida...'), nl, !,

  nl, write('verificacao de contagens...'), nl, !,
  s([quantos, sao, os, hoteis, do, porto],[]),!,
  s([quantos, hoteis, portuenses, possuem, servico, de, babysitting, e, de,'wi-fi'],[]),!,
  s([quantos, hoteis, disponibilizam, o, servico, de, 'wi-fi', e, tem, 5, estrelas],[]),!,
  s([quantos, hoteis, de, lisboa, possuem, categoria, inferior, a, 4, e, quartos, executivos], []),!,
  write('verificacao de contagens...'), nl, !,

  nl, write('verificacao de contexto...'), nl, !,
  s([quantos, sao, os, hoteis, do, porto],[]),nl,!,
  s([e, de, aveiro],[]),!,
  write('verificacao de contexto concluida.'), nl, !,

  nl, write('verificacao de memorizacao...'), nl, !,
  s([o, hotel, ferreiro, fica, em, aveiro, e, tem, 3, estrelas, ';'],[]),!,
  s([o, hotel, ferreiro, tem, 4, estrelas, ';'],[]),!,
  s([o, hotel, ferreiro, fica, em, aveiro, e, tem, 3, estrelas, '?'],[]),!,
  write('verificacao de memorizacao concluida.'), nl, !,

  nl, write('outras verificacoes...'), nl, !,
  s([quantos, sao, os, hoteis, do, porto],[]),!,
  s([quais, sao, os, hoteis, do, porto],[]),!,
  s([quais, os, hoteis, de, categoria, superior, a, 3, estrelas, em, lisboa],[]),!,
  s([e, de, aveiro],[]),!,
  s([que, servicos, disponibiliza, o, hotel, 'eduardo VII'],[]), !,
  write('outras verificacoes concluidas.'), nl, !.
