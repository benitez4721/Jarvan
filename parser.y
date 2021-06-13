%error-verbose
%{
    #include<iostream>
    #include<stdlib.h>
    #include<string.h>
    #include <vector>
    #include "ast.h"
    #include "parser.tab.h"
    #include "definitions.h"

    using namespace std;

    vector<Token> tokens;
    vector<Token> errors;

    #define YYDEBUG 1

    extern int yylex();
    extern int yylineno;
    extern int yyleng;
    extern int yycolumn;
    extern FILE* yyin;
    extern char* yytext;

    bool error_sintactico = 0;

    Program * root_ast;

    void yyerror(const char *s);
%}

%union {	
    int num; 
    bool boolean;
    char * str;
    char ch;
    float flot;
    Node * node;
}


%locations
%start Program

%left AND OR
%left LEQ GEQ LESS GREATER
%left PLUS MINUS
%left POTEN MULT DIV INTDIV REST
%right NOT

%token BS 1 BSF 2 
%token DEVALUA 3 EFECTIVO 4
%token LETRA 5 
%token BETICAS 6 
%token OBLOCK 7 CBLOCK 8 
%token LABIA 9 QLQ 10 BUS 11 BULULU 12 POINTER 13
%token LEER 14 IMPRIMIR 15
%token PLUSASIGN 16 MINUSASIGN 17 MULTASIGN 18 POTENASIGN 19 DIVASIGN 20 RESTASIGN 21 INTDIVASIGN 22 
%token SEMICOLON 23 ASIGN 24
%token PLUS 25 MINUS 26 MULT 27 POTEN 28 DIV 29 INTDIV 30 REST 31
%token LEQ 32 GEQ 33 LESS 34 GREATER 35 EQUAL 36 NQUAL 37 AND 38 OR 39 NOT 40
%token OPAR 41 CPAR 42 OBRACKET 43 CBRACKET 44
%token TAM 45 SITIO 46 METELE 47 SACALE 48 VOLTEA 49 
%token HASH 50
%token ELDA 51 COBA 52 
%token COMMA 53
%token PORSIA 54 SINO 55 NIMODO 56 TANTEA 57 CASO 58
%token VACILA 59 IN 60 ACHANTA 61 SIGUELA 62
%token PEGAO 63 CHAMBA 64 RESCATA 65 
%token ERROR 67
%token <str> ID 66
%token <str> STRING 68
%token <ch> CHAR 69
%token <num> INT 70
%token <flot> FLOAT 71
%token METRO 72 METROBUS 73
%type <node> Body DeclarationList Declaration

%%

Program             :  OBLOCK Body CBLOCK                                           {root_ast = new Program($2);}
                    |  OBLOCK CBLOCK                                                {;}
                    ;

Body                : BETICAS DeclarationList                                      {$$= new Body($2);}
                    ;

// Variables Declaration

DeclarationList     : Declaration                                          {$$ = new DeclarationList(NULL, $1);}
                    | DeclarationList SEMICOLON Declaration                {$$ = new DeclarationList($1, $3);} 
                    ;

Declaration         : Type ID Init                                           {$$ = new Declaration($2);}
                    | BUS ID OBLOCK DeclarationList CBLOCK                   {$$ = new Declaration($2);}
                    ;

Type                : BS                                                    {;}
                    | BSF                                                   {;}
                    | LABIA                                                 {;}
                    | LETRA                                                 {;}
                    | BULULU                                                {;}
                    | QLQ                                                   {;}
                    | ArrayType LESS Type OBRACKET ArrayInitSize CBRACKET GREATER         {;}
                    ;

ArrayType           : METRO                                                 {;}
                    | METROBUS                                              {;}
                    ;

ArrayInitSize       : INT                                                   {;}
                    | 
                    ;

// Variables initialization

Init                : ASIGN Literal
                    | ASIGN Array
                    |
                    ;

// Literals

Literal             : INT
                    | FLOAT
                    | CHAR
                    | STRING
                    | ELDA
                    | COBA
                    ;

LiteralList         : Literal
                    | LiteralList COMMA Literal

Array               : OBRACKET LiteralList CBRACKET
                    | OBRACKET CBRACKET
%%

void yyerror (char const *s) {
    cout << s << " line: " << yylineno << endl;
    // fprintf (stderr, "%s%s\n", s);
}

void run_lexer(){
    cout << "executing lexer" << endl;
    int ntoken;
    ntoken = yylex();
    int column = 1;
    int row = yylineno;
    bool isComment = false;
    
    while(ntoken) {
        if(row != yylineno){
            row = yylineno;
            column = 1;
            yycolumn = 2;
            isComment = false;
        }
        else{
            column = yycolumn - yyleng;  
        }
        if(nTokens[ntoken] != "ws" && !isComment){

            if(ntoken == ERROR){
                errors.push_back(Token(yytext, nTokens[ntoken], yylineno, column));
            }
            else{
                tokens.push_back(Token(yytext, nTokens[ntoken], yylineno, column ));
            }
        }

        if(ntoken == HASH){
            isComment = true;
        }
        


        ntoken = yylex();

    }
    if(errors.size() > 0){
        for(int i = 0; i < errors.size(); i++){
            cout << errors[i].to_str();
        }
    }else {
        for(int i = 0; i < tokens.size(); i++){
            cout << tokens[i].to_str();
        }
    }
}

void run_parser(){
	cout << "Ejecutando parser" << endl << endl;
    
    try {
		yyparse();
	}
	catch(const char* const errorMessage){
		cout << "Error: " << endl;
			cout << errorMessage << endl;
	}
	
    cout << root_ast->to_s() << endl;
	// Si hay errores del lexer, imprimirlos
}

int main(int argc, char *argv[]){
    init_tokens_definitions();
    string filePath = argv[1];
    yyin = fopen(argv[1], "r");
    run_parser();
    return 0;
}
