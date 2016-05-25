%---------------------------------------------------------%
%                          INCLUDES                       %
%---------------------------------------------------------%

:- use_module(library(sockets)).
:- use_module(library(lists)).
:- use_module(library(codesio)).

?- ensure_loaded('bibliogenie.pl').
?- ensure_loaded('gramatica.pl').
?- ensure_loaded('query.pl').

%---------------------------------------------------------%
%                         PREDICADOS                      %
%---------------------------------------------------------%

port(8081).

% Server Entry Point
server:-
	port(Port),
	write('Opened Server'),
	nl,
	socket_server_open(Port, Socket),
	server_loop(Socket),
	socket_server_close(Socket),
	write('Closed Server'),
	nl.

% Server Loop
% Uncomment writes for more information on incomming connections
server_loop(Socket):-
	repeat,
	socket_server_accept(Socket, _Client, Stream, [type(text)]),
	catch((
		read_request(Stream, Request),
		read_header(Stream)
	),_Exception,(
		close_stream(Stream),
		fail
	)),
	handle_request(Request, MyReply, Status),
	format('Request: ~q~n',[Request]),
	format('Reply: ~q~n', [MyReply]),
	format(Stream, 'HTTP/1.0 ~p~n', [Status]),
	format(Stream, 'Access-Control-Allow-Origin: *~n', []),
	format(Stream, 'Content-Type: text/plain~n~n', []),
	format(Stream, '~p', [MyReply]),
	close_stream(Stream),
	(Request = quit), !.

close_stream(Stream):-
	flush_output(Stream),
	close(Stream).

handle_request(Request, MyReply, '200 OK'):- catch(parse_input(Request, MyReply), error(_,_), fail), !.
handle_request(syntax_error, 'no', '400 Bad Request'):- !.
handle_request(_, 'no', '200 OK').

read_request(Stream, Request) :-
	read_line(Stream, LineCodes),
	atom_codes('GET /',Get),
	append(Get,RL,LineCodes),
	read_request_aux(RL,RL2),
	catch(read_from_codes(RL2, Request), error(syntax_error(_),_), fail), !.
read_request(_,syntax_error).

read_request_aux([32|_], [46]):- !.
read_request_aux([C|Cs], [C|RCs]):-
	read_request_aux(Cs, RCs).

read_header(Stream) :-
	repeat,
	read_line(Stream, Line),
	(Line = []; Line = end_of_file), !.

check_end_of_header([]):- !, fail.
check_end_of_header(end_of_file):- !, fail.
check_end_of_header(_).

%---------------------------------------------------------%
%                          PROTOCOLO                      %
%---------------------------------------------------------%

:- include('bibliogenie.pl').

parse_input(hello, ready).
parse_input(quit, goodbye).
parse_input(query(Sentence), yes):- serverQuery(Sentence, Result).