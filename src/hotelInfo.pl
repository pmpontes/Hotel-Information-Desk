servico(1, "bar").
servico(2, "lavandaria").
servico(3, "restaurante").
servico(4, "jardim").
servico(5, "concierge").
servico(6, "servico de quartos").
servico(7, "baby-sitting").
servico(8, "cofre").
servico(9, "ar condicionado").
servico(10, "estacionamento").
servico(11, "wireless").
servico(12, "pequeno almoço").
servico(13, "spa").
servico(14, "piscina").
servico(15, "ginasio").

hotel("Star Inn", "Porto", 3, [1, 2, 6, 10, 11, 12, 9], [55-"single"-[], 80-"quarto duplo"-["vista de jardim"]]).

hotel("Quality Inn Portus Cale", "Porto", 4, [1, 6, 8, 2, 10, 11, 13, 15, 12, 9], [85-"single"-[], 130-"quarto duplo"-["cama extra"], 180-"suite"-[], 230-"suite executiva"-[]]).

hotel("Intercontinental", "Porto", 5, [5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [95-"single"-[], 190-"quarto duplo"-["cama extra"], 250-"suite"-[], 340-"suite executiva"-["vista de praça"]]).

hotel("Corinthia", "Lisboa", 5, [3, 4, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [95-"single"-[], 160-"quarto duplo"-["cama extra"], 190-"suite"-[]]).

hotel("Rossio Garden", "Lisboa", 3, [3, 4, 6, 1, 10, 11, 12, 14, 9], [95-"single"-[], 150-"quarto duplo"-["cama extra"]]).

hotel("Eduardo VII", "Lisboa", 3, [6, 1, 10, 11, 12, 9], [60-"single"-[], 100-"quarto duplo"-["cama extra"]]).

hotel("Flor de Sal", "Viana", 4, [3, 4, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [95-"single"-["vista de mar"], 160-"quarto duplo"-["cama extra", "vista de mar"], 190-"suite"-["vista de mar"]]).

hotel("Axis", "Viana", 4, [3, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 15, 9], [85-"single"-["vista de jardim"], 110-"quarto duplo"-["cama extra", "vista de jardim"], 170-"suite"-["vista de jardim"]]).

hotel("Veneza", "Aveiro", 3, [3, 5, 6, 7, 8, 1, 2, 10, 11, 12, 13, 14, 9], [65-"single"-[], 85-"quarto duplo"-["cama extra"]]).

hotel("Moliceiro", "Aveiro", 4, [3, 5, 6, 8, 1, 2, 10, 11, 12, 9], [95-"single"-[], 110-"quarto duplo"-["cama extra"], 170-"suite"-[]]).

add_hotel(Name, Location, Stars):-
	assertz(hotel(Name, Location, Stars, [], [])).

add_service(Hotel, NewService):-
  retractall(hotel(Hotel, Location, Stars, Services, Rooms)),
	assertz(hotel(Hotel, Location, Stars, [NewService|Services], Rooms)).

add_room(Hotel, Type, Price, Commodities):-
  retractall(hotel(Hotel, Location, Stars, Services, Rooms)),
	assertz(hotel(Hotel, Location, Stars, Services, [Price-Type-Commodities|Rooms])).

hotel(Name, Location, Stars, Services, Rooms).

hotel_has_service(Hotel, Service):- hotel(Hotel, _, _, Services), member(Service, Services).
