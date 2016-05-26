:-include('gramatica.pl').
:-use_module(library(lists)).

:- op(400,xfx,\).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% processar
processar(Frase):- frase(TipoF, TipoQ, Q, Frase, []), !,
write('Frase valida;\n'), write(TipoF-TipoQ), write(':'), write(Q), !,
responder(TipoF, TipoQ, Q).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% responder
responder(afirmacao, _, QIn):-
prepare_query(QIn, QOut),
concordar(QOut).

responder(declaracao, _, QIn):-
prepare_query(QIn, QOut),
memorizar(QOut).

responder(interrogacao, TipoQ, [At, QIn]):-
prepare_query(QIn, QOut), !, write('ATRIBUTO: '), write(At),nl,
responder(TipoQ, At, QOut).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prepare_query
prepare_query(QIn, H-L-C-S-Q):-
  flatten(QIn, QFlat), nl, write(QFlat),nl, !,
  parse(QFlat, _, H-L-C-S-Q), write('PARSED   '), write(H-L-C-S-Q), nl.

parse([], Final, Final).

parse([localizacao-Restricoes | R], H-_-C-S-Q, Final):-
  parse(Restricoes, H-L-C-S-Q, Final),
  parse(R, H-L-C-S-Q, Final).

parse([localizacao-[Local-[]] | R], H-_-C-S-Q, Final):-
  parse(R, H-Local-C-S-Q, Final).

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

parse([disponibiliza-Services | R], H-L-C-S-Q, Final):-
  parse(Services, H-L-C-S-Q, Final),
  parse(R, H-L-C-S-Q, Final).

parse([ser-Restricoes | R], H-L-C-S-Q, Final):-
  parse(Restricoes, H-L-C-S-Q, Final),
  parse(R, H-L-C-S-Q, Final).

parse([categoria-[Restricao] | R], H-L-_-S-Q, Final):-
  parse(R, H-L-Restricao-S-Q, Final).

parse([categorizado-Restricoes | R], H-L-C-S-Q, Final):-
  parse(Restricoes, H-L-C-S-Q, Final),
  parse(R, H-L-C-S-Q, Final).

parse([quarto-[Restricoes] | R], H-L-C-S-_, Final):-
  parse(R, H-L-C-S-Restricoes, Final).

parse([servico-Restricoes | R], H-L-C-_-Q, Final):-
  parse(R, H-L-C-Restricoes-Q, Final).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% responder
responder(localizar, localizacao, H-L-C-S-Q):-
  findall(H-L-C-S-Q, (hotel(H,L1,Cat,_,_), localizacao(L1, L), analisa_categoria(Cat, C), analisa_servicos(H, S), analisa_quartos(H, Q)), L),
  write('RESPOSTA : '),
  resposta(localizar, localizacao, L).

responder(TipoQ, At, H-L-C-S-Q):-
  var(At), !,
  findall(H-L-C-S-Q, (hotel(H,L1,Cat,_,_), localizacao(L1, L), analisa_categoria(Cat, C), analisa_servicos(H, S), analisa_quartos(H, Q)), L),
  write('RESPOSTA : '),
  resposta(TipoQ, At, L).

responder(TipoQ, At, H-L-C-S-Q):-
  nonvar(At), !,
  findall(H-L-C-S1-Q1, (hotel(H,L,Cat,S1,Q1), analisa_categoria(Cat, C)), L),
  write('RESPOSTA : '),
  resposta(TipoQ, At, L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% resposta
resposta(listar, At, L):-
  filtrar(L, At, [], F),
  write(F), nl.

resposta(localizar, localizacao, L):-
  filtrar(L, localizacao, [], Final), !,
  write(Final), nl.

resposta(contar, At, L):-
  filtrar(L, At, [], F),
  length(F, N),
  write(N), nl.

filtrar(F, At, _, F):- var(At).
filtrar([], _, F, F).

filtrar([H-L-C-S-Q | R], hotel, T, F):-
  filtrar(R, hotel, [H | T], F).

filtrar([H-L-C-S-Q | R], localizacao, T, F):-
  filtrar(R, localizacao, [L | T], F).

filtrar([H-L-C-S-Q | R], categoria, T, F):-
  filtrar(R, servico, [C | T], F).

filtrar([H-L-C-S-Q | R], servico, T, F):-
  filtrar(R, servico, [L | T], F).

filtrar([H-L-C-S-Q | R], quarto, T, F):-
  filtrar(R, servico, [Q | T], F).

%%%%%%%%%%%%%%TODO
resposta(avaliar, At, L):-
  filtrar(L, At, [], F),
  write(N), nl.

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

analisa_categoria(Categoria, R-V):-
  var(R), var(V), !.

igual(V, V).
maior(V1, V2):- V1 > V2.
menor(V1, V2):- V1 < V2.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% aux
flatten(S,F) :-
  flatten_dl(S,F\[]).

flatten_dl([],X\X).
flatten_dl([X|Xs],Y\Z):-
   flatten_dl(X,Y\T),
   flatten_dl(Xs,T\Z).
flatten_dl(X,[X|Z]\Z).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tests

s(L, _):- processar(L).
  test:-
    write('1ok'), nl, !,
%    s([o, hotel, moliceiro, fica, em, aveiro, e, possui, 4, estrelas],[]),
    write('2ok'), nl, !,
%    s([quantos, sao, os, hoteis, do, porto],[]),nl,
    write('3ok?'), nl, !,
    %    s([o, hotel, moliceiro, fica, no, porto],[]),
    s([onde, fica, o, hotel, moliceiro],[]),
    %s([qual, a, localizacao, do, hotel, moliceiro],[]),
    write('4ok'), nl, !,
    s([quais, os, hoteis, que, disponibilizam, o, servico, de, wireless, e, tem, 2, estrelas],[]),
    write('5ok'), nl, !,
    s([e, em, aveiro],[]),
    write('6ok'), nl,
    s([quais, os, hoteis, portuenses, que, possuem, servico, de, babysitting, e, de, wireless],[]),
    write('7ok'), nl, !,
    s([quais, os, hoteis, de, lisboa, que, possuem, categoria, inferior, a, 4, e, quartos, com, vista, de, mar], []),
    write('8ok'), nl, !.
