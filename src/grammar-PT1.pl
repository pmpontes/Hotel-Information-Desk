
% Gramatica
s --> sn,  {write(ok), nl}, sv.
s --> sv.
s --> sn, sv, sp, {write(t1)}.
s --> sp, sn, sv.
s --> sv, sp.
s --> sp, sv.
s --> copu, sp.

sn --> det, mod, n, mod.
sn --> copu, pro_int, n, {write(pergunta)}.
sn --> copu, pro_int, {write(pergunta)}. % [e] quanto custa ...
sn --> pro.

copu --> [e].
copu --> [].

det --> quant, ident, num.
mod --> sa.
mod --> sp.
mod --> [].

sp --> prep, sn.
sp --> prep, sn.
sp --> prep, sv.
sp --> adv.

sa --> ac.
sa --> adv, ac.
sa --> ac, sp.

sv --> v.
sv --> v,sn.
sv --> v, sn, sp.
sv --> v,sp.
sv --> v, sp, sp.
sv --> sn, v.
sv --> sn, v, sp.
sv --> cop, sa.
sv --> cop, sn.
sv --> cop, sp.


% Lexico
ident --> [o].
ident --> [a].
ident --> [os].
ident --> [as].
ident --> [um].
ident --> [uma].
ident --> [uns].
ident --> [umas].
ident --> [].

pro_int --> [qual].
pro_int --> [quais].
pro_int --> [que].
pro_int --> [quanto].
pro_int --> [quantos].
pro_int --> [quantas].
pro_int --> [onde].

quant --> [todos].
quant --> [algum].
quant --> [alguns].
quant --> [nenhum].
quant --> [].

num -->   [1].
num -->   [2].
num -->   [3].
num -->   [4].
num -->   [5].
num -->   [dois].
num -->   [duas].
num -->   [tres].
num -->   [].

pro -->   [se].
pro -->   [o].
pro -->   [a].
pro -->   [os].
pro -->   [as].

prep -->  [a].
prep -->  [de].
prep -->  [do].
prep -->  [para].
prep -->  [com].
prep -->  [em].
prep -->  [no].
prep -->  [na].

adv  -->  [bem].
adv  -->  [mais].

n   -->   [babysitting].
n   -->   [estrela].
n   -->   [estrelas].
n   -->   [porto].
n   -->   [aveiro].
n   -->   [viana].
n   -->   [hotel].
n   -->   [hoteis].
n   -->   [quarto].
n   -->   [quartos].
n   -->   [suite].
n   -->   [suites].
n   -->   ['hotel moliceiro'].
n   -->   [servico].
n   -->   [servicos].
n   -->   [categoria].

ac   -->   [superior, a].
ac   -->   [inferior, a].
ac   -->   [igual, a].

v   -->   [custa].
v   -->   [dormir].
v   -->   [encontrar].
v   -->   [encontro].
v   -->   [encontramos].
v   -->   [comer].
v   -->   [fica].
v   -->   [ficam].
v   -->   [oferecer].
v   -->   [oferecem].
v   -->   [oferece].
v   -->   [disponibiliza].
v   -->   [disponibilizam].
v   -->   [tem].
v   -->   [ha].

cop   -->   [ser].
cop   -->   [sou].
cop   -->   [e].
cop   -->   [somos].
cop   -->   [sao].
cop   -->   [estar].
cop   -->   [estou].
cop   -->   ['está'].
cop   -->   [estamos].
cop   -->   ['estão'].
cop   -->   ['pareço'].
cop   -->   [parecer].
cop   -->   [parece].
cop   -->   [parecemos].
cop   -->   [parecem].
cop   -->   [].



test:-
  s([quantos, sao, os, hoteis, do, porto],[]),
  write('1ok'), nl, !,
  s([quais, sao, os, hoteis, de, categoria, superior, a, 3, estrelas, em, viana],[]),
  write('2ok'), nl, !,
  s([e, em, aveiro],[]),
  write('3ok'), nl, !,
  s([que, servicos, disponibiliza, o, 'hotel moliceiro'],[]),
  write('4ok'), nl, !,
  s([quais, os, hoteis, portuenses, que, possuem, servico, de, babysitting],[]),
  write('5ok'), nl, !,
  s([quais, os, hoteis, de, lisboa, que, possuem, categoria, inferior, a, 4, e, quartos, com, vista, de, mar], []),
  write('6ok'), nl, !,
  s([o, 'hotel moliceiro', fica, em, aveiro, e, possui, 4, estrelas],[]),
  write('7ok'), nl, !,
  s([quanto, custa, um, quarto, no, 'hotel moliceiro'],[]),
  write('8ok'), nl, !,
  s([qual, a, localizacao, do, 'hotel moliceiro'],[]),
  write('9ok').
