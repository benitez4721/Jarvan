default: scanner.o definitions.o 
	flex lexer.l && \
	g++ -c definitions.cpp && \
	g++ -c scanner.cpp definitions.cpp && \
	g++ scanner.o definitions.o lex.yy.c -o jarvan



