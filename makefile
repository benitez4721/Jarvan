default:
	bison -d parser.y && \
	flex lexer.l && \
	g++ -c definitions.cpp && \
	g++ -g definitions.o lex.yy.c  parser.tab.c ast.cpp -o jarvan

clean:
	rm lex.yy.c parser.tab.* definitions.o jarvan.exe
