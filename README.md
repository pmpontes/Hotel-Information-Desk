#Hotel-Information-Desk

##Summary
Developed for an Artificial Intelligence course - AIAD - this application allows to define and obtain hotel information, using natural language, in Portuguese, as if it were an information desk.

##Key-words
Definite Clause Grammars, HTML, JavaScript, Natural Language, Prolog, Knowledge Representation.

##Examples of interaction supported:
###Statements

####O hotel Moliceiro fica em Espanha e possui 4 estrelas.
####-Erro gramatical.
Example of a grammar error: 'Espanha' is not in the defined lexicon.

####O hotel Moliceiro fica em Porto.
####-Erro gramatical.
Example of grammatical error: The word 'Porto' requires the preposition 'no' or 'do'.

####O hotel Veneza fica em Aveiro e possui 4 estrelas.
####-Errado…
The information is inconsistent with the knowledge base.

####O hotel Intercontinental disponibiliza o serviço de babysitting e de wi-fi.
####-Sim!
The information is consistent with the knowledge base.

###Questions

####Quantos hoteis de Lisboa possuem categoria inferior a 4 e quartos executivos?
####-1

####Quais os hotéis de categoria superior a 3 estrelas em Lisboa?
####-[Corinthia]

####E em Aveiro?
####-[Moliceiro]
Example of a question using context, introduced by the 'e' particle.

####Que serviços disponibiliza o hotel Eduardo VIII?
####-[serviço-de-quartos, bar, estacionamento, wi-fi, pequeno-almoço, ar-condicionado]

####Quais os hotéis portuenses que possuem serviço de babysitting?
####-[Intercontinental]

####Quais os hotéis de Viana que possuem categoria igual a 4 e quartos com vista de mar?
####[Flor de Sal]

###Declarations
####O Hotel Ferreiro fica em Aveiro e tem 3 estrelas;
####-Novo hotel criado.

Example of a declaration of new information.

####O Hotel Ferreiro tem 1 estrela;
####-Categoria atualizada.
Example of an information update.

In both cases, it should be noted the need to end the sentence with ';', otherwise the statement will be interpreted as a statement.

##Implementation overview

For the implementation, it was considered a division into five modules:

• a module with the knowledge representation, containing the system's information;

• a module with the lexicon recognized;

• a module responsible for sentence analysis;

• a module responsible for generating responses;

• a user interface module.

##Getting Started

In order to have the system running on your local machine for development and testing purposes see the notes below.

###Prerequisites

• SICStus Prolog - to run the program in Prolog;

• Mongoose - web server to connect; save the .exe file in the project folder.

###Installing

The program can be used exclusively from the SICStus Prolog interface or from a web interface.

1. Open SICStus console
2. Go to File->Consult
3. Navigate to the folder src/ and select the file sobre_hoteis.pl

####SICStus Prolog
4. Enter the command:
   processar(+Phrase, -Response).
where Phrase represents a list with the words of the phrase.

Warning:
For operational reasons, all the words in the lexicon are in lowercase letters without stress. In particular, the verbal form 'é' is defined as 'e_', so as to distinguish it from the conjunction 'e'. If in doubt, consult the file "lexico.pl".

####Web interface
4. Enter, without arguments, the command 'servidor.';
5. Execute mongoose and navigate to the src folder
6. Open the index.html file;
