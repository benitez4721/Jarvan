%error-verbose
%{
    #include<iostream>
    #include<stdlib.h>
    #include<string.h>
    #include <vector>
    #include "ast.h"
    #include "definitions.h"
    #include "table.h"
    #include "parser.tab.h"

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
    extern sym_table table;

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
%token DEREFERENCE 76
%type <node> Body DeclarationList Declaration Id Asignacion Literal Exp InstList Inst Lvalue Init ListAccesor ArrayIndexing List Array Seleccion Seleccion2 Casos Conversion ArrOp FuncDef ParamList FuncCall Args Repeticion
%type <program> Program 

%%
Start               : Program                                                       {root_ast = $1;}
                    | 
                    ;

Program             :  OBLOCK Body CBLOCK                                           {$$ = new Program($2);}
                    |  OBLOCK CBLOCK                                                {$$ = new Program(NULL);}
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

Declaration         : Type Init                                                     {$$ = new Declaration($2, NULL);}
                    | BUS Id OBLOCK DeclarationList CBLOCK                          {$$ = new Declaration($2, $4);}
                    | BULULU Id OBLOCK DeclarationList CBLOCK                       {$$ = new Declaration($2, $4);}
                    | Type POINTER Id                                               {$$ = new Declaration($3, NULL);}
                    | Type POINTER Init                                               {$$ = new Declaration($3, NULL);}
                    | Type Id                                                       {$$ = new Declaration($2, NULL);}
                    ;

Init                : Id ASIGN Exp                                          {$$ = new Asign($1, $3);}
                    ;

Asignacion          : Lvalue ASIGN Exp                                      {$$ = new Asign($1, $3);}
                    ;

Lvalue              : ListAccesor                                       {$$ = $1;}
                    | Id ArrayIndexing                                  {$$ = new Indexing($1, $2);}
                    ; 

ListAccesor         : ListAccesor POINT Id                              {$$ = new ListAccesor($1, $3);}
                    | Id                                                {$$ = new ListAccesor(NULL, $1);}
                    ; 
                    
Id			        : ID										        {$$ = new Id($1);}
			        ;

ArrayIndexing	    : ArrayIndexing OBRACKET Exp CBRACKET  		        {$$ = new ListIndexing($1, $3)}
                    | OBRACKET Exp CBRACKET                             {$$ = new ListIndexing(NULL, $2)}
                    ;

Type                : BS                                                    {;}
                    | BSF                                                   {;}
                    | LABIA                                                 {;}
                    | LETRA                                                 {;}                                                
                    | QLQ                                                   {;}
                    | ArrayType LESS Type OBRACKET Exp CBRACKET GREATER                 {;}
                    ;

ArrayType           : METRO                                                 {;}
                    | METROBUS                                              {;}
                    ;

// Literals

Literal             : INT                                                   {$$ = new LiteralInt($1);}                                                   
                    | FLOAT                                                 {$$ = new LiteralFloat($1);}
                    | CHAR                                                  {$$ = new LiteralChar($1);}
                    | STRING                                                {$$ = new LiteralStr($1);}                                             
                    | ELDA                                                  {$$ = new LiteralBool("elda");}
                    | COBA                                                  {$$ = new LiteralBool("coba");}
                    | Array                                                 {$$ = new Array($1)}
                    ;

Array               : OBRACKET List CBRACKET                            {$$ = $2;}
                    ;

List                : Exp                                               {$$ = new ArrayList(NULL, $1);}                                               
                    | List COMMA Exp                                    {$$ = new ArrayList($1, $3);}                                             
                    ;

Exp         : OPAR Exp CPAR                                                 {$$ = new Exp($2);}

            | Exp PLUS Exp                                                  {$$ = new BinaryExp($1, $3, "+");}
            | Exp MINUS Exp                                                 {$$ = new BinaryExp($1, $3, "-");}
            | Exp MULT Exp                                                  {$$ = new BinaryExp($1, $3, "*");}
            | Exp DIV Exp                                                   {$$ = new BinaryExp($1, $3, "/");}
            | Exp POTEN Exp                                                 {$$ = new BinaryExp($1, $3, "^");}
            | Exp INTDIV Exp                                                {$$ = new BinaryExp($1, $3, "//");}
            | Exp REST Exp                                                  {$$ = new BinaryExp($1, $3, "%");}

            | Exp AND Exp                                                   {$$ = new BinaryExp($1, $3, "&&")}
            | Exp OR Exp                                                    {$$ = new BinaryExp($1, $3, "||")}
            | NOT Exp                                                       {$$ = new Unary($2, "!")}
            | MINUS Exp                                                     {$$ = new Unary($2, "-")}
            | DEREFERENCE Id                                                {$$ = new Unary($2, "&")}

            | Exp EQUAL Exp                                                 {$$ = new BinaryExp($1, $3, "==")}
            | Exp NQUAL Exp                                                 {$$ = new BinaryExp($1, $3, "!=")}
            | Exp GEQ Exp                                                   {$$ = new BinaryExp($1, $3, ">=")}
            | Exp LEQ Exp                                                   {$$ = new BinaryExp($1, $3, "<=")}
            | Exp GREATER Exp                                               {$$ = new BinaryExp($1, $3, ">")}
            | Exp LESS Exp                                                  {$$ = new BinaryExp($1, $3, "<")}
        
            | ArrOp                                                         {$$ = $1}
            | Conversion                                                    {$$ = $1}
            | Literal                                                       {$$ = $1;}                                                          
            | FuncCall                                                      {$$ = $1}
            | Lvalue                                                        {$$ = $1}
            ;

InstList    : InstList SEMICOLON Inst                                       {$$ = new InstList($1, $3);}
            | Inst                                                          {$$ = new InstList(NULL, $1);}

Inst        : Conversion                                                        {$$ = $1;}
            | Seleccion                                                         {$$ = $1;}
            | Repeticion                                                        {$$ = $1;}
            | FuncDef                                                           {$$ = $1;}
            | FuncCall                                                          {$$ = $1;}
            | Asignacion                                                        {$$ = $1;}
            | ArrOp                                                             {$$ = $1;}
            | IMPRIMIR OPAR Exp CPAR                                            {$$ = new Io($3,"Imprimir");}
            | LEER OPAR Id CPAR                                                 {$$ = new Io($3, "Leer");}
            | RESCATA Exp                                                       {$$ = new Rescata($2)}
            | Program                                                           {$$ = $1;}
            ;

Conversion  : EFECTIVO OPAR Exp CPAR                                   {$$ = new EmbededFunc("Efectivo", $3)}
            | DEVALUA OPAR Exp CPAR                                    {$$ = new EmbededFunc("Devalua", $3)}
            ;

Seleccion   : PORSIA OPAR Exp CPAR Program Seleccion2                       {$$ = new Seleccion($3,$5,$6,"Porsia")}
            | TANTEA OPAR Id CPAR OBLOCK Casos CBLOCK                       {$$ = new Tantea($3, $6);}
            ;

Seleccion2  : SINO OPAR Exp CPAR Program  Seleccion2                          {$$ = new Seleccion( $3, $5, $6, "Sino")}
            | NIMODO Program                                                  {$$ = new Seleccion(NULL, $2, NULL, "Nimodo")}
            |                                                                 {$$ = NULL;}
            ;

Casos       : Casos CASO OPAR Exp CPAR Program                                {$$ = new Caso($1, $4, $6);}
            | CASO OPAR Exp CPAR Program                                      {$$ = new Caso(NULL, $3, $5);}
            ;

Repeticion  : VACILA OPAR Declaration SEMICOLON Exp SEMICOLON Exp CPAR Program     {$$ = new Repeticion($3, $5, $7, NULL, $9);}
            | VACILA OPAR Id IN Exp CPAR Program                                   {$$ = new Repeticion(NULL, $5, NULL, $3, $7);}  
            | PEGAO OPAR Exp CPAR Program                                          {$$ = new Repeticion2($3, $5);} 
            ;

ArrOp       : TAM OPAR Exp CPAR                                            {$$ = new EmbededFunc("Tam", $3)}
            | SITIO OPAR Exp CPAR                                          {$$ = new EmbededFunc("Sitio", $3)}
            | METELE OPAR Exp CPAR                                         {$$ = new EmbededFunc("Metele", $3)}
            | SACALE OPAR Exp CPAR                                         {$$ = new EmbededFunc("Sacale", $3)}
            | VOLTEA OPAR Exp CPAR                                         {$$ = new EmbededFunc("Voltea", $3)}
            ;

// // Sobre las funciones

FuncCall    : Id OPAR Args CPAR                                                  {$$ = new FunCall($1,$3);}
            ;

Args        : Args COMMA Exp                                                {$$ = new Params($1, $3);}
            | Exp                                                           {$$ = new Params(NULL, $1);}
            |                                                               {$$ = NULL;}
            ;
            

FuncDef     : CHAMBA Type Id OPAR ParamList CPAR Program                        {$$ = new Chamba($3, $5, $7)}
            | CHAMBA NADA Id OPAR ParamList CPAR Program                        {$$ = new Chamba($3, $5, $7)}
            ;

ParamList   : ParamList COMMA Declaration                                   {$$ = new Params($1, $3);}
            | Declaration                                                   {$$ = new Params(NULL, $1)}
            |                                                               {$$ = NULL}
            ;

%%

// void imprimir_tabla(){
// 	if (!error_sintactico){
// 		table.print();
// 	}
// }

void yyerror (char const *s) {
    cout << "Sintax Error, unexpected: " << yytext << " in row " << yylineno << ", column " << yycolumn-strlen(yytext) << "\n"; 
    // fprintf (stderr, "%s%s\n", s);
}

void run_lexer(){
    cout << "executing lexer" << endl << endl;
    int ntoken;
    ntoken = yylex();
    int column = 1;
    int row = yylineno;
    bool isComment = false;
    
    while(ntoken) {
        if(row != yylineno){
            row = yylineno;
            isComment = false;
        }

        if(nTokens[ntoken] != "ws" && !isComment){
            if(ntoken == ERROR){
                errors.push_back(Token(yytext, nTokens[ntoken], yylineno, yylloc.first_column));
            }
            else{
                tokens.push_back(Token(yytext, nTokens[ntoken], yylineno, yylloc.first_column));
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
	
    cout << root_ast->to_s(0,0) << endl;
	// Si hay errores del lexer, imprimirlos
    
    // imprimir_tabla();
}

int main(int argc, char *argv[]){
    init_tokens_definitions();
    string filePath = argv[1];
    yyin = fopen(argv[1], "r");
    if (yyin == false){
    	cout << "Error de lectura, revise el archivo " << argv[1] << endl;
    	return 0;
    }

    if (argc > 2){
		for (int i = 2; i < argc; i++ ){
			string arg(argv[i]);
			if (arg == "-l"){
				run_lexer();
			}
			else if (arg == "-p"){
				run_parser();
			}
		}
	} else {
		// por defecto ejecuta el parser
		run_parser();
	}

    return 0;
}

