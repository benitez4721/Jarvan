%option yylineno
%option noyywrap
%{

#include<stdlib.h>
#include <string.h>
#include<iostream>
#include "ast.h"
#include <vector>
#include "symtable.h"
#include "parser.tab.h"
using namespace std;



int yycolumn = 1;
#define YY_USER_ACTION \
    yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; yylloc.last_column = yycolumn + yyleng - 1; \
    yycolumn += yyleng; \
    yylval.str = strdup(yytext);

vector<string> lex_errors;

%}

int                      ([0-9]+)
float                     ([0-9]+\.[0-9]+)
char                    '(.|\\n|\\t)'
id                      [a-zA-Z][a-zA-Z0-9_]*
string                   (\".*\")

%%
{char}                  {return CHAR;}
{string}                {return STRING;}
{int}                   {yylval.num = atoi(yytext);return INT;}
{float}                 {yylval.flot = stof(yytext); return FLOAT;}
[ ]                  ; 
\t								{yycolumn+= 3;}
\n								{yycolumn = 1;}
"bs"                    {return BS;}
"bsf"                   {return BSF;}
"letra"                 {return LETRA;}
"nada"                  {return NADA;}
"Beticas"               {return BETICAS;}
"{"                     {return OBLOCK;}
"}"                     {return CBLOCK;}
"qlq"                   {return QLQ;}
"Labia"                 {return LABIA;}
"Bus"                   {return BUS;}
"Bululu"                {return BULULU;}
"Metro"                 {return METRO;}
"Metrobus"              {return METROBUS;}
"~"                     {return POINTER;}
"leer"                  {return LEER;}
"imprimir"              {return IMPRIMIR;}
";"                     {return SEMICOLON;}
"="                     {return ASIGN;}
"+"                     {return PLUS;}
"-"                     {return MINUS;}
"*"                     {return MULT;}
"^"                     {return POTEN;}
"/"                     {return DIV;}
"//"                   {return INTDIV;}
"%"                     {return REST;}
"<="                    {return LEQ;}
">="                    {return GEQ;}
"<"                     {return LESS;}
">"                     {return GREATER;}
"=="                    {return EQUAL;}
"!="                    {return NQUAL;}
"&&"                    {return AND;}
"||"                    {return OR;}
"!"                     {return NOT;}
"&"                     {return DEREFERENCE;}
"("                     {return OPAR;}
")"                     {return CPAR;}
"["                     {return OBRACKET;}
"]"                     {return CBRACKET;}
(#)(.*?)              {yycolumn = 1;}
"elda"                  {return ELDA;}
"coba"                  {return COBA;}
","                     {return COMMA;}
"porsia"                {return PORSIA;}
"sino"                  {return SINO;}
"nimodo"                {return NIMODO;}
"tantea"                {return TANTEA;}
"caso"                  {return CASO;}
"vacila"                {return VACILA;}
"in"                    {return IN;}
"achanta"               {return ACHANTA;}
"siguela"               {return SIGUELA;}
"pegao"                 {return PEGAO;}
"Chamba"                {return CHAMBA;}
"rescata"               {return RESCATA;}
"."                     {return POINT;}
{id}                    {return ID;}
.                       {string temp = strdup(yytext);lex_errors.push_back("Error: Unexpected character " + temp + " at line " + to_string(yylineno) + ", column " + to_string(yycolumn) + "\n");}
%%