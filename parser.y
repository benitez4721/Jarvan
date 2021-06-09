%error-verbose
%{
    #include <iostream>

    using namespace std;

    #define YYDEBUG 1

    extern int yylex();
    extern int yycolumn;
    extern int yylineno;
    extern char * yytext;

    bool error_sintactico = 0;

    void yyerror(const char *s);
%}

%union {	
    int num; 
    bool boolean;
    char * str;
    char ch;
    float flot;
}


%locations
%start Start

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
%token ID 66 ERROR 67
%token <str> STRING 68
%token <ch> CHAR 69
%token <num> INT 70
%token <flot> FLOAT 71
%token WS 72


%%

Start       :  OBLOCK Cuerpo CBLOCK                                         {cout << "Start      \n";}
            |  OBLOCK CBLOCK                                                {cout << "\n";}
            ;

Cuerpo      : BETICAS Declaration_List                                      {cout << "Cuerpo \n";}
            ;

Declaration_List    : Declaration                                           {cout << "Declaration \n"}
                    | Declaration_List SEMICOLON Declaration                {cout << "DeclarationList \n"} 
                    ;

Declaration         : Type Id                                               {cout << "ID" ;}
                    ;

Type                : BS                                                    {;}
                    | BSF                                                   {;}
                    | LABIA                                                 {;}
                    | LETRA                                                 {;}
                    | BUS                                                   {;}
                    | BULULU                                                {;}
                    ;

Id                  : ID                                                    {;}
                    ;

%%

void yyerror (char const *s) {
    fprintf (stderr, "%s\n", s);
}