%{

#include<stdlib.h>
#include<iostream>
#include "lexer.h"
using namespace std;


int yycolumn = 1;
#define YY_USER_ACTION yycolumn += yyleng;


%}

int                      ([0-9]+)
float                     ([0-9]+.[0-9]+)
id                      ([a-zA-Z_][a-zA-Z0-9_]*)
string                   (\".*\")
char                    (\".{1}\")
%option yylineno

%%
{char}                  {return CHAR;}
{string}                {return STRING;}
{int}                   {return INT;}
{float}                 {return FLOAT;}
[\t\n]                  ; 
" "                     {return WS;}
"bs"                    {return BS;}
"bsf"                   {return BSF;}
"letra"                 {return LETRA;}
"Beticas"               {return BETICAS;}
"{"                     {return OBLOCK;}
"}"                     {return CBLOCK;}
"qlq"                   {return QLQ;}
"bus"                   {return BUS;}
"bululu"                {return BULULU;}
"@"                     {return POINTER;}
"leer"                  {return LEER;}
"imprimir"              {return IMPRIMIR;}
"+="                    {return PLUSASIGN;}
"-="                    {return MINUSASIGN;}
"*="                    {return MULTASIGN;}
"^="                    {return POTENASIGN;}
"/="                    {return DIVASIGN;}
"%="                    {return RESTASIGN;}
"//="                   {return INTDIVASIGN;}
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
"("                     {return OPAR;}
")"                     {return CPAR;}
"["                     {return OBRACKET;}
"]"                     {return CBRACKET;}
"]"                     {return CBRACKET;}
"tam"                   {return TAM;}
"sitio"                 {return SITIO;}
"metele"                {return METELE;}
"sacale"                {return SACALE;}
"voltea"                {return VOLTEA;}
"#"                     {return HASH;}
"/#"                    {return OHASH;}
"#\\"                   {return CHASH;}
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
{id}                    {return ID;}
.                       {return ERROR;}
%%

int yywrap(void){
    return 1;
}