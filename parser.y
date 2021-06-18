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
    Program * program;
}


%locations
%start Start

%left AND OR
%left LEQ GEQ LESS GREATER
%left EQUAL NQUAL
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
%token SEMICOLON 23 ASIGN 24
%token PLUS 25 MINUS 26 MULT 27 POTEN 28 DIV 29 INTDIV 30 REST 31
%token LEQ 32 GEQ 33 LESS 34 GREATER 35 EQUAL 36 NQUAL 37 AND 38 OR 39 NOT 40
%token OPAR 41 CPAR 42 OBRACKET 43 CBRACKET 44
%token TAM 45 SITIO 46 METELE 47 SACALE 48 VOLTEA 49 
%token HASH 50
%token <boolean> ELDA 51 
%token <boolean> COBA 52 
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
%token NADA 74
%token POINT 75
%type <node> Body DeclarationList Declaration Id Asignacion Literal Exp InstList Inst 
%type <program> Program 

%%
Start               : Program                                                       {root_ast = $1;}
                    | 
                    ;

Program             :  OBLOCK Body CBLOCK                                           {$$ = new Program($2);}
                    |  OBLOCK CBLOCK                                                {;}
                    ;

Body                : BETICAS DeclarationList InstList                                    {$$ = new Body($2, $3);}
                    | BETICAS DeclarationList                                             {$$ = new Body($2, NULL);}
                    | InstList                                                            {$$ = new Body(NULL, $1);}
                    ;
                    ;

// Variables Declaration

DeclarationList     : DeclarationList SEMICOLON Declaration                         {$$ = new DeclarationList($1, $3);}
                    | Declaration                                                   {$$ = new DeclarationList(NULL, $1);} 
                    ;

Declaration         : Type Asignacion                                               {$$ = new Declaration($2, NULL);}
                    | BUS Id OBLOCK DeclarationList CBLOCK                          {$$ = new Declaration($2, $4);}
                    | BULULU Id OBLOCK DeclarationList CBLOCK                       {$$ = new Declaration($2, $4);}
                    | Type Id                                                       {$$ = new Declaration($2, NULL);}
                    ;

Asignacion          : Id ASIGN Exp                                      {$$ = new Asign($1, $3);}
                    ;

Id           		: Id POINT ID										{cout << " Id POINT ID \n";}
			        | ID Corchetes 								        {cout << "ID Corchetes \n";}
			        | ID										        {$$ = new Id($1)}
			        ;

Corchetes	        : Corchetes OBRACKET Exp CBRACKET  		        {cout << "Corchetes OBRACKET Exp CBRACKET \n";}
                    | OBRACKET Exp CBRACKET                         {cout << "OBRACKET Exp CBRACKET \n";}
                    | OBRACKET CBRACKET                         {cout << "OBRACKET CBRACKET \n";}
                    ;

Type                : BS                                                    {;}
                    | BSF                                                   {;}
                    | LABIA                                                 {;}
                    | LETRA                                                 {;}                                                
                    | QLQ                                                   {;}
                    | ArrayType LESS Type Corchetes GREATER                 {;}
                    ;

ArrayType           : METRO                                                 {cout << "METRO \n";}
                    | METROBUS                                              {cout << "METROBUS \n";}
                    ;

// Literals

Literal             : INT                                                   {$$ = new LiteralInt($1);}                                                   
                    | FLOAT                                                 {$$ = new LiteralFloat($1);}
                    | CHAR                                                  {$$ = new LiteralChar($1);}
                    | STRING                                                {$$ = new LiteralStr($1);}                                             
                    | ELDA                                                  {$$ = new LiteralBool(true);}
                    | COBA                                                  {$$ = new LiteralBool(false);}
                    ;

Array               : OBRACKET List CBRACKET                            {cout << "OBRACKET List CBRACKET \n";}
                    ;

List                : Exp                                               {cout << "Exp \n";}                                               
                    | List COMMA Exp                                    {cout << "List COMMA Exp \n";}                                             
                    ;

Exp         : OPAR Exp CPAR                                                 {$$ = new Exp($2);}

            | Exp PLUS Exp                                                  {$$ = new BinaryExp($1, $3, "+");}
            | Exp MINUS Exp                                                 {$$ = new BinaryExp($1, $3, "-");}
            | Exp MULT Exp                                                  {$$ = new BinaryExp($1, $3, "*");}
            | Exp DIV Exp                                                   {$$ = new BinaryExp($1, $3, "/");}
            | Exp POTEN Exp                                                 {$$ = new BinaryExp($1, $3, "^");}
            | Exp INTDIV Exp                                                {$$ = new BinaryExp($1, $3, "//");}
            | Exp REST Exp                                                  {$$ = new BinaryExp($1, $3, "%");}

            | Exp AND Exp                                                   {cout << "Exp AND Exp \n";}
            | Exp OR Exp                                                    {cout << "Exp OR Exp \n";}
            | NOT Exp                                                       {cout << "NOT Exp \n";}

            | Exp EQUAL Exp                                                 {cout << "Exp EQUAL Exp \n";}
            | Exp NQUAL Exp                                                 {cout << "Exp NQUAL Exp \n";}
            | Exp GEQ Exp                                                   {cout << "Exp GEQ Exp \n";}
            | Exp LEQ Exp                                                   {cout << "Exp LEQ Exp \n";}
            | Exp GREATER Exp                                               {cout << "Exp GREATER Exp \n";}
            | Exp LESS Exp                                                  {cout << "Exp LESS Exp \n";}
        
            | ArrOp                                                         {cout << "ArrOp \n";}
            | Conversion                                                    {cout << "Conversion \n";}
            | Literal                                                       {$$ = $1;}                                                          
            | FuncCall                                                      {cout << "FuncCall \n";}
            | Id                                                    {cout << "Id \n";}
            | Array                                                    {cout << "Id \n";}
            | POINTER ID                                                    {cout << "POINTER ID \n";}
            ;

InstList    : InstList SEMICOLON Inst                                       {$$ = new InstList($1, $3);}
            | Inst                                                          {$$ = new InstList(NULL, $1);}

Inst        : Conversion                                                        {cout << "Conversion \n";}
            | Seleccion                                                         {cout << "Seleccion \n";}
            | Repeticion                                                        {cout << "Repeticion \n";}
            | FuncDef                                                           {cout << "FuncDef \n";}
            | FuncCall                                                          {cout << "FuncCall \n";}
            | Asignacion                                                        {$$ = $1;}
            | ArrOp                                                             {cout << "ArrOp \n";}
            | IMPRIMIR OPAR Exp CPAR                                            {cout << "IMPRIMIR OPAR Exp CPAR \n";}
            | LEER OPAR ID CPAR                                                 {cout << "LEER OPAR ID CPAR \n";}
            ;

Conversion  : EFECTIVO OPAR Literal OPAR                                   {cout << "EFECTIVO OPAR Literal OPAR \n";}
            | DEVALUA OPAR Literal OPAR                                    {cout << "DEVALUA OPAR Literal OPAR \n";}
            ;

Seleccion   : PORSIA OPAR Exp CPAR Program Seleccion2                       {cout << "PORSIA OPAR Exp OPAR Start \n";}
            | TANTEA OPAR Id CPAR OBLOCK Casos CBLOCK                       {cout << "TANTEA OPAR Id CPAR OBLOCK Casos CBLOCK \n";}
            ;

Seleccion2  : SINO OPAR Exp CPAR Program  Seleccion2                          {cout << "SINO OPAR Exp CPAR Start \n";}
            | NIMODO Program                                                  {cout << "NIMODO Start \n";}
            |                                                                 {cout << "FIN Seleccion2 \n";}
            ;

Casos       : Casos CASO OPAR Exp CPAR Program                                {cout << "Casos CASO OPAR Exp CPAR Start \n";}
            | CASO OPAR Exp CPAR Program                                      {cout << "CASO OPAR Exp CPAR Start \n";}
            ;

Repeticion  : VACILA OPAR Declaration SEMICOLON Exp SEMICOLON Exp CPAR Program     {cout << "VACILA OPAR Declaration SEMICOLON Exp SEMICOLON Exp CPAR Start \n";}
            | VACILA OPAR Id IN Exp CPAR Program                                   {cout << "VACILA OPAR Id IN Exp CPAR Start \n";}  
            | PEGAO OPAR Exp CPAR Program                                          {cout << "PEGAO OPAR Exp CPAR Start \n";} 
            ;

ArrOp       : TAM OPAR Array CPAR                                            {cout << "TAM OPAR Array CPAR \n";}
            | SITIO OPAR Array CPAR                                          {cout << "SITIO OPAR Array CPAR \n";}
            | METELE OPAR Array CPAR                                         {cout << "METELE OPAR Array CPAR \n";}
            | SACALE OPAR Array CPAR                                         {cout << "SACALE OPAR Array CPAR \n";}
            | VOLTEA OPAR Array CPAR                                         {cout << "VOLTEA OPAR Array CPAR \n";}
            | TAM OPAR ID CPAR                                               {cout << "TAM OPAR ID CPAR \n";}
            | SITIO OPAR ID CPAR                                             {cout << "SITIO OPAR ID CPAR \n";}
            | METELE OPAR ID CPAR                                            {cout << "METELE OPAR ID CPAR \n";}
            | SACALE OPAR ID CPAR                                            {cout << "SACALE OPAR ID CPAR \n";}
            | VOLTEA OPAR ID CPAR                                            {cout << "VOLTEA OPAR ID CPAR \n";}
            ;

// // Sobre las funciones

FuncCall    : ID OPAR CPAR                                                  {cout << "ID OPAR CPAR \n";}
            | ID OPAR Exp CPAR                                              {cout << "ID OPAR Exp CPAR \n";}
            ;

FuncDef     : CHAMBA Type ID OPAR ParamList CPAR Program                        {cout << "CHAMBA Type ID OPAR ParamList CPAR Start \n";}
            | CHAMBA NADA ID OPAR ParamList CPAR Program                        {cout << "CHAMBA NADA OPAR ParamList CPAR Start \n";}
            ;

ParamList   : ParamList COMMA Declaration                                   {cout << "ParamList COMMA Declaration \n";}
            | Declaration                                                   {cout << "Declaration \n";}
            |                                                               {cout << "Empty Param \n";}
            ;

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
    // run_lexer();
    return 0;
}

