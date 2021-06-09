default: 
	flex lexer.l && \
	g++ main.cpp lex.yy.c lexer.cpp lexer.h -o jarvan


