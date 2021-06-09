default: 
	bison -vd parser.y && \
	flex lexer.l && \
	g++ main.cpp parser.tab.c lex.yy.c lexer.cpp lexer.h -o jarvan


