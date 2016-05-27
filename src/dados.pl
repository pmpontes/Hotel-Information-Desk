%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% serviços
servico(1, 'bar').
servico(2, 'lavandaria').
servico(3, 'restaurante').
servico(4, 'jardim').
servico(5, 'concierge').
servico(6, 'servico-de-quartos').
servico(7, 'babysitting').
servico(8, 'cofre').
servico(9, 'ar-condicionado').
servico(10, 'estacionamento').
servico(11, 'wi-fi').
servico(12, 'pequeno-almoco').
servico(13, 'spa').
servico(14, 'piscina').
servico(15, 'ginasio').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% localizacoes
localizacao(1, 'porto').
localizacao(2, 'lisboa').
localizacao(3, 'viana').
localizacao(4, 'aveiro').
localizacao(5, 'funchal').
localizacao(6, 'portimao').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hoteis (Hotel, Localizacao, Categoria, Serviços, Quartos)
:-dynamic(hotel/5).

hotel('star inn', 1, 3, [1, 2, 6, 10, 11, 12, 9], [55-'single'-[], 80-'duplo'-['vista jardim'], 80-'duplo'-['vista praca']]).

hotel('quality inn portus cale', 1, 4, [1, 6, 8, 2, 10, 11, 13, 15, 12, 9], [85-'single'-[], 130-'duplo'-['cama extra'], 180-'suite'-[], 230-'executivo'-[]]).

hotel('intercontinental', 1, 5, [5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [95-'single'-[], 190-'duplo'-['cama extra'], 250-'suite'-[], 340-'executivo'-['vista praca']]).

hotel('corinthia', 2, 5, [3, 4, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [95-'single'-[], 160-'duplo'-['cama extra'], 190-'executivo'-[]]).

hotel('rossio garden', 2, 3, [3, 4, 6, 1, 10, 11, 12, 14, 9], [95-'single'-[], 150-'duplo'-['cama extra'],  200-'executivo'-['cama extra']]).

hotel('eduardo vii', 2, 3, [6, 1, 10, 11, 12, 9], [60-'single'-[], 100-'duplo'-['cama extra']]).

hotel('flor-de-Sal', 3, 4, [3, 4, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [95-'single'-['vista mar'], 160-'duplo'-['cama extra', 'vista mar'], 190-'executivo'-['vista mar']]).

hotel('axis', 3, 4, [3, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [85-'single'-['vista jardim'], 110-'duplo'-['cama extra', 'vista jardim'], 170-'executivo'-['vista jardim']]).

hotel('veneza', 4, 3, [3, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 9], [65-'single'-[], 85-'duplo'-['cama extra']]).

hotel('moliceiro', 4, 4, [3, 5, 6, 8, 1, 2, 10, 11, 12, 9], [95-'single'-[], 110-'duplo'-['cama extra'], 170-'executivo'-[]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adicionar hotel
adicionar_hotel(Nome, Localizacao, Estrelas):-
	localizacao(LocalizacaoId, Localizacao),
	\+ hotel(Nome, LocalizacaoId, _, _, _),
	assertz(hotel(Nome, LocalizacaoId, Estrelas, [], [])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% classificar hotel
classificar_hotel(Nome, Estrelas):-
	retractall(hotel(Nome, Localizacao, _, Servicos, Quartos)),
	assertz(hotel(Nome, Localizacao, Estrelas, Servicos, Quartos)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adicionar os servicos na lista dada ao hotel
adicionar_servicos_hotel(_, []).
adicionar_servicos_hotel(Hotel, [NovoServico |Outros]):-
  retractall(hotel(Hotel, Localizacao, Categoria, Servicos, Quartos)),
	servico(NovoServicoId, NovoServico),
	assertz(hotel(Hotel, Localizacao, Categoria, [NovoServicoId|Servicos], Quartos)),
	adicionar_servicos_hotel(Hotel, Outros).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adicionar os quartos ao hotel
adicionar_quartos(_, []).
adicionar_quartos(Hotel, [Preco-Tipo-Caracteristicas |Outros]):-
  retractall(hotel(Hotel, Location, Stars, Services, Rooms)),
	assertz(hotel(Hotel, Location, Stars, Services, [Preco-Tipo-Caracteristicas|Rooms])),
	adicionar_quarto(Hotel, Outros).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% verificar se hotel disponibiliza os servicos na lista dada
obter_servicos([], S, S).
obter_servicos([ServicoId|Outros], S, Servicos):-
	servico(ServicoId, Servico),
	obter_servicos(Outros, [Servico|S], Servicos).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% verificar se hotel disponibiliza os servicos na lista dada
disponibiliza(_, []).
disponibiliza(Hotel, [Servico|Outros]):-
	hotel(Hotel, _, _, Servicos, _),
	servico(ServicoId, Servico),
	member(ServicoId, Servicos), !,
	disponibiliza(Hotel, Outros).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% verificar se hotel tem quartos com as caracteristicas na lista dada
quarto(_, []).
quarto(Hotel, [Preco-Tipo-Caracteristicas|Outros]):-
	var(Caracteristicas),
	hotel(Hotel, _, _, _, Quartos),
	append(_,[Preco-Tipo-Caracteristicas|_], Quartos),
	quarto(Hotel, Outros).

quarto(Hotel, [Preco-Tipo-Caracteristicas|Outros]):-
	nonvar(Caracteristicas),
	hotel(Hotel, _, _, _, Quartos),
	append(_,[Preco-Tipo-Caracteristicas1|_], Quartos),
	quarto_caractertisticas(Caracteristicas, Caracteristicas1),
	quarto(Hotel, Outros).

quarto_caractertisticas([], _).
quarto_caractertisticas([Caracteristica | Outras], Caracteristicas):-
	member(Caracteristica, Caracteristicas),
	quarto_caractertisticas(Outras, Caracteristicas).
