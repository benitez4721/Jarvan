default:
	bison -d parser.y && \
	flex lexer.l && \
	g++ -g definitions.cpp lex.yy.c parser.tab.c -o jarvan

clean:
	rm lex.yy.c parser.tab.* jarvan.exe
