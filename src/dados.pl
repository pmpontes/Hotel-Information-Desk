servico(1, 'bar').
servico(2, 'lavandaria').
servico(3, 'restaurante').
servico(4, 'jardim').
servico(5, 'concierge').
servico(6, 'servico de quartos').
servico(7, 'baby-sitting').
servico(8, 'cofre').
servico(9, 'ar condicionado').
servico(10, 'estacionamento').
servico(11, 'wi-fi').
servico(12, 'pequeno almoço').
servico(13, 'spa').
servico(14, 'piscina').
servico(15, 'ginasio').

localizacao(1, 'porto').
localizacao(2, 'lisboa').
localizacao(3, 'viana').
localizacao(4, 'aveiro').

hotel('star inn', 1, 3, [1, 2, 6, 10, 11, 12, 9], [55-'single'-[], 80-'duplo'-['vista-jardim']]).

hotel('quality inn portus cale', 1, 4, [1, 6, 8, 2, 10, 11, 13, 15, 12, 9], [85-'single'-[], 130-'duplo'-['cama extra'], 180-'suite'-[], 230-'suite executiva'-[]]).

hotel('intercontinental', 1, 5, [5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [95-'single'-[], 190-'duplo'-['cama extra'], 250-'suite'-[], 340-'suite executiva'-['vista-praça']]).

hotel('corinthia', 2, 5, [3, 4, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [95-'single'-[], 160-'duplo'-['cama extra'], 190-'suite'-[]]).

hotel('rossio garden', 2, 3, [3, 4, 6, 1, 10, 11, 12, 14, 9], [95-'single'-[], 150-'duplo'-['cama extra']]).

hotel('eduardo VII', 2, 3, [6, 1, 10, 11, 12, 9], [60-'single'-[], 100-'duplo'-['cama extra']]).

hotel('flor-de-Sal', 3, 4, [3, 4, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [95-'single'-['vista-mar'], 160-'duplo'-['cama extra', 'vista-mar'], 190-'suite'-['vista-mar']]).

hotel('axis', 3, 4, [3, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [85-'single'-['vista-jardim'], 110-'duplo'-['cama extra', 'vista-jardim'], 170-'suite'-['vista-jardim']]).

hotel('veneza', 4, 3, [3, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 9], [65-'single'-[], 85-'duplo'-['cama extra']]).

hotel('moliceiro', 4, 4, [3, 5, 6, 8, 1, 2, 10, 11, 12, 9], [95-'single'-[], 110-'duplo'-['cama extra'], 170-'suite'-[]]).

adicionar_hotel(Nome, Localizacao, Estrelas):-
	localizacao(LocalizacaoId, Localizacao),
	retractall(hotel(Nome, LocalizacaoId, _, _, _)),
	assertz(hotel(Nome, LocalizacaoId, Estrelas, [], [])).

adicionar_servico_hotel(Hotel, NovoServico):-
  retractall(hotel(Hotel, Location, Stars, Services, Rooms)),
	servico(NewServiceId, NovoServico),
	assertz(hotel(Hotel, Location, Stars, [NewServiceId|Services], Rooms)).

adicionar_quarto(Hotel, Preco-Tipo-Caracteristicas):-
  retractall(hotel(Hotel, Location, Stars, Services, Rooms)),
	assertz(hotel(Hotel, Location, Stars, Services, [Preco-Tipo-Caracteristicas|Rooms])).

disponibiliza(Hotel, Servico):-
	hotel(Hotel, _, _, Services, _),
	servico(Service, Servico),
	member(Service, Services).

localiza(Hotel, Localizacao):-
	hotel(Hotel, Localizacao, _, _, _).

classifica(Hotel, Classificacao):-
	hotel(Hotel, _, Classificacao, _, _).
