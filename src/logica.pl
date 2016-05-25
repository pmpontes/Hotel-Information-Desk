:-include('gramatica.pl').
:-use_module(library(lists)).

% process
processar(Frase):- frase(TipoF, TipoQ, Q, Frase, []), !,
write('Frase valida;\n'), write(TipoF-TipoQ), write(':'), write(Q).
responder(TipoF, TipoQ, Q).

% Logica
responder(afirmacao, _, QIn):-
prepare_query(QIn, QOut).

prepare_query(QIn, H-L-C-S-Q):-
    parse(QIn, _, H-L-C-S-Q), write('PARSED   '), write(H-L-C-S-Q).

    parse([], Final, Final).

    parse([localizacao-[Local-[]] | R], H-_-C-S-Q, Final):-
      parse(R, H-Local-C-S-Q, Final).

    parse([localizacao-[Local] | R], H-_-C-S-Q, Final):-
      parse(R, H-Local-C-S-Q, Final).

    parse([classificacao-[Comparacao-Valor] | R], H-L-_-S-Q, Final):-
      parse(R, H-L-[Comparacao-Valor]-S-Q, Final).

    parse([hotel-HotelInfo | R], H-L-C-S-Q, Final):-
      parse(HotelInfo, H-L-C-S-Q, Final),
      parse(R, H-L-C-S-Q, Final).

    parse([nome-Hotel | R], _-L-C-S-Q, Final):-
      parse(R, Hotel-L-C-S-Q, Final).

    parse([disponibiliza-Services | R], H-L-C-S-Q, Final):-
      parse(Services, H-L-C-S-Q, Final),
      parse(R, H-L-C-S-Q, Final).

    parse([categoria-[Restricao] | R], H-L-_-S-Q, Final):-
      parse(R, H-L-Restricao-S-Q, Final).

    parse([quarto-[Restricoes] | R], H-L-C-S-_, Final):-
      parse(R, H-L-C-S-Restricoes, Final).

avalia(avaliar,A,S,O):- P =.. [A, S, O], (P, !, write(verdadeiro); write(falso)).
%avalia(contar,A,S,O):- P =.. [A, S, O], findall(H, P, Hs), length(Hs, N), !, write(N).
%avalia(encontrar,A,S,O):- P =.. [A, S, O], findall(H, P, Hs), !, write(Hs). %% TODO considerar conjunção de características

responde(Q, A, At, O):-
  var(At), !,
  P =.. [A, S, O],
  findall(S, P, L),
  (Q=ql, !,
  write(L);
  length(L, N),
  write(N)).

responde(Q, A, At, O):-
  nonvar(At),
  P =.. [A, S, O],
  findall(S, (P, ser(S,At)), L),
  (Q=ql, !,
  write(L);
  length(L, N),
  write(N)).

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % grammar tests
  s(L, _):- processar(L).
  test:-
    s([o, hotel, moliceiro, fica, no, porto],[]),
    write('1ok'), nl, !,
    s([o, hotel, moliceiro, fica, em, aveiro, e, possui, 4, estrelas],[]),
    write('2ok'), nl, !,
    s([quantos, sao, os, hoteis, do, porto],[]),nl,
    write('3ok?'), nl, !,
    s([qual, a, localizacao, do, hotel, moliceiro],[]),
    write('4ok'), nl, !,
    s([quais, os, hoteis, que, disponibilizam, o, servico, de, wireless, e, tem, 2, estrelas],[]),
    write('5ok'), nl, !,
    s([e, em, aveiro],[]),
    write('6ok'), nl,
    s([quais, os, hoteis, portuenses, que, possuem, servico, de, babysitting, e, de, wireless],[]),
    write('7ok'), nl, !,
    s([quais, os, hoteis, de, lisboa, que, possuem, categoria, inferior, a, 4, e, quartos, com, vista, de, mar], []),
    write('8ok'), nl, !.
