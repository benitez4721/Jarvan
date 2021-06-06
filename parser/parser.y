%error-verbose
%{
    #include <iostream>
    #include "definiciones.h"

    using namespace std;

    #define YYDEBUG 1

    extern int yylex(void);
    extern int yycolumn;
    extern int yylineno;
    extern char * yytext;

    bool error_sintactico = 0;

    void yyerror (char const *s) {
        error_sintactico = 1;
        cout << "Parse error:" << s << "\nFila: " << yylineno << "\n" << "Columna: " << yycolumn-1-strlen(yytext) << "\n" ; 
    }
%}

%define parse.lac full

%union {	
    int num; 
    bool boolean;
    char * str;
    char ch;
}

%locations
%start S

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
%token LEQ 32 GEQ 33 LESS 34 GREATER 35 EQUAL 36 NEQUAL 37 AND 38 OR 39 NOT 40
%token OPAR 41 CPAR 42 OBRACKET 43 CBRACKET 44
%token TAM 45 SITIO 46 METELE 47 SACALE 48 VOLTEA 49 
%token HASH 50
%token ELDA 51 COBA 52 
%token COMMA 53
%token PORSIA 54 SINO 55 NIMODO 56 TANTEA 57 CASO 58
%token VACILA 59 IN 60 ACHANTA 61 SIGUELA 62
%token PEGAO 63 CHAMBA 64 RESCATA 65 
%token ID 66 ERROR 67

%type <void> S Start Sec Inst Id Pointer Typedef Vardec Exp List Array Arrop Conversion Literals Seleccion Casos Repeticion Function Return

%%

S           : Start                                                         {cout << "Start      \n";}
            |                                                               {cout << "\n";}
            ;

Start       : OBLOCK BETICAS Sec CBLOCK Start                               {cout << "OBLOCK BETICAS Sec CBLOCK SEMICOLON Start\n";}
            | OBLOCK BETICAS Sec CBLOCK                                     {cout << "OBLOCK BETICAS Sec CBLOCK\n";}
            | OBLOCK Sec CBLOCK Start                                       {cout << "OBLOCK Sec CBLOCK SEMICOLON Start\n";}
            | OBLOCK Sec CBLOCK                                             {cout << "OBLOCK Sec CBLOCK\n";}
            ;

Sec 		: Inst SEMICOLON Sec  					                        {cout << "Inst SEMICOLON Sec  \n";}
			| Inst SEMICOLON							                    {cout << "Inst SEMICOLON\n";}
			;

Inst        : Id ASIGN Exp                                                  {cout << "Ids ASIGN Exp\n";}
            | Vardec ASIGN Exp                                              {cout << "Vardec ASIGN Exp \n";}
            | Seleccion                                                     {cout << "Seleccion \n";}
            | Repeticion                                                    {cout << "Repeticion \n";}
            | Function                                                      {cout << "Function \n";}
            | Return                                                        {cout << "Return \n";}
            | ACHANTA                                                       {cout << "ACHANTA \n";}
            | SIGUELA                                                       {cout << "SIGUELA \n";}
            ;

Id          : ID                                                            {cout << "ID \n";}
            ;

Pointer     : POINTER Id                                                    {cout << "POINTER Id \n";}
            ;

Typedef     : QLQ                                                           {cout << "QLQ \n";}
            | BS                                                            {cout << "BS \n";}
            | BSF                                                           {cout << "BSF \n";}
            | LETRA                                                         {cout << "LETRA \n";}
            | LABIA                                                         {cout << "LCHAR \n";}
            | OBRACKET Typedef CBRACKET                                     {cout << "OBRACKET Typedef CBRACKET \n";}
            | BUS                                                           {cout << "BUS \n";}
            | BULULU                                                        {cout << "BULULU \n";}
            ;

Vardec      : Typedef Id                                                    {cout << "Typedef Ids \n";}
            | Typedef Pointer                                               {cout << "Typedef Pointer \n";}
            | Typedef Id COMMA Vardec                                       {cout << "Typedef Ids Vardec \n";}
            | Typedef Pointer COMMA Vardec                                  {cout << "Typedef Pointer Vardec \n";}
            ;

Exp         : OPAR Exp CPAR                                                 {cout << "OPAR PLUS CPAR \n";}

            | Exp PLUS Exp                                                  {cout << "Exp PLUS Exp \n";}
            | Exp MINUS Exp                                                 {cout << "Exp MINUS Exp \n";}
            | Exp MULT Exp                                                  {cout << "Exp MULT Exp \n";}
            | Exp DIV Exp                                                   {cout << "Exp DIV Exp \n";}
            | Exp POTEN Exp                                                 {cout << "Exp POTEN Exp \n";}
            | Exp INTDIV Exp                                                {cout << "Exp INTDIV Exp \n";}
            | Exp REST Exp                                                  {cout << "Exp REST Exp \n";}

            | Exp AND Exp                                                   {cout << "Exp AND Exp \n";}
            | Exp OR Exp                                                    {cout << "Exp OR Exp \n";}
            | NOT Exp                                                       {cout << "NOT Exp \n";}

            | Exp EQUAL Exp                                                 {cout << "Exp EQUAL Exp \n";}
            | Exp NEQUAL Exp                                                {cout << "Exp NEQUAL Exp \n";}
            | Exp GEQ Exp                                                   {cout << "Exp GEQ Exp \n";}
            | Exp LEQ Exp                                                   {cout << "Exp LEQ Exp \n";}
            | Exp GREATER Exp                                               {cout << "Exp GREATER Exp \n";}
            | Exp LESS Exp                                                  {cout << "Exp LESS Exp \n";}

            | Exp PLUSASIGN Exp                                             {cout << "Exp PLUSASIGN Exp \n";}
            | Exp MINUSASIGN Exp                                            {cout << "Exp MINUSASIGN Exp \n";}
            | Exp MULTASIGN Exp                                             {cout << "Exp MULTASIGN Exp \n";}
            | Exp DIVASIGN Exp                                              {cout << "Exp DIVASIGN Exp \n";}
            | Exp POTENASIGN Exp                                            {cout << "Exp POTENASIGN Exp \n";}
            | Exp INTDIVASIGN Exp                                           {cout << "Exp INTDIVASIGN Exp \n";}
            | Exp RESTASIGN Exp                                             {cout << "Exp RESTASIGN Exp \n";}        
            | Arrop                                                         {cout << "Arrop \n";}
            | Conversion                                                    {cout << "Conversion \n";}
            | Literals                                                      {cout << "Literals \n";}
            ;

List        : Exp COMMA List                                                {cout << "Exp COMMA List \n";}
            | Exp                                                           {cout << "Exp \n";}
            ;

Array       : OBRACKET List CBRACKET                                        {cout << "OBRACKET List CBRACKET \n";}
            ;

Arrop       : TAM OPAR List CPAR                                            {cout << "TAM OPAR List CPAR \n";}
            | SITIO OPAR List CPAR                                          {cout << "SITIO OPAR List CPAR \n";}
            | METELE OPAR List CPAR                                         {cout << "METELE OPAR List CPAR \n";}
            | SACALE OPAR List CPAR                                         {cout << "SACALE OPAR List CPAR \n";}
            | VOLTEA OPAR List CPAR                                         {cout << "VOLTEA OPAR List CPAR \n";}
            ;

Conversion  : EFECTIVO OPAR Literals OPAR                                   {cout << "EFECTIVO OPAR Literals CPAR \n";}
            | DEVALUA OPAR Literals OPAR                                    {cout << "DEVALUA OPAR Literals CPAR \n";}
            ;

Literals    : Id                                                            {cout << "Id \n";}
            | CHAR                                                          {cout << "CHAR \n";}
            | INT                                                           {cout << "INT \n";}
            | STRING                                                        {cout << "STRING \n";}
            | COBA                                                          {cout << "COBA \n";}
            | ELDA                                                          {cout << "ELDA \n";}
            | Array                                                         {cout << "Array \n";}
            ;

Seleccion   : PORSIA OPAR Exp CPAR Start                                    {cout << "PORSIA OPAR Exp CPAR Start \n";}
            | SINO OPAR Exp CPAR Start                                      {cout << "SINO OPAR Exp CPAR Start \n";}
            | NIMODO Start                                                  {cout << "NIMODO Start \n";}
            | TANTEA OPAR Id CPAR OBLOCK Casos CBLOCK                       {cout << "TANTEA OPAR Id CPAR OBLOCK Casos CBLOCK \n";}
            ;

Casos       : CASO OPAR Exp CPAR Start Casos                                {cout << "CASO OPAR Exp CPAR Start Casos \n";}
            | CASO OPAR Exp CPAR Start                                      {cout << "CASO OPAR Exp CPAR Start \n";}
            ;

Repeticion  : VACILA OPAR Vardec SEMICOLON Exp SEMICOLON Exp CPAR Start     {cout << "VACILA OPAR Vardec SEMICOLON Exp SEMICOLON Exp CPAR Start \n";}
            | VACILA OPAR Id IN Exp CPAR Start                              {cout << "VACILA OPAR Id IN Exp CPAR Start \n";}  
            | PEGAO OPAR Exp CPAR Start                                     {cout << "PEGAO OPAR Exp CPAR Start \n";} 
            ;

Function    : CHAMBA Id OPAR Vardec CPAR Start                              {cout << "CHAMBA Id OPAR Vardec CPAR Start \n";}
            ;

Return      : RESCATA Exp                                                   {cout << "RESCATA Exp \n";}
            ;