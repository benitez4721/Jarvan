
#include<stdlib.h>
#include<iostream>
#include<string>
#include "definitions.h"
#include <map>
#include <regex>
using namespace std;

string nTokens[100]; 

Token::Token(string _token, string _type, int _row, int _column) {
            token = _token;
            type = _type;
            row = _row;
            column = _column;
        };


string Token::to_str(){
    if(type == "TkError"){
        return "Error: Unexpected character: " + token  + " in row: " + to_string(row) + ", column: " + to_string(column) + '\n';
    }
    else if(type == "TkChar" || type == "TkId" || type == "TkInt" || type == "TkFloat" || type == "TkString"){
        string token_display;
        if(type == "TkString" || type == "TkChar"){
            token_display = '(' + token + ')';
        }
        else{
            token_display = "(\"" + token + "\")";
        }
        return type + token_display + " " + to_string(row) + " " + to_string(column) + '\n';
    }
    else{
        return type + " " + to_string(row) + " " + to_string(column) + '\n';
    }
}

void init_tokens_definitions(){
    nTokens[ID] = "TkId";
    nTokens[LABIA] = "TkLabia";
    nTokens[BS] = "TkBs";
    nTokens[BSF] = "TkBsf";
    nTokens[ERROR] = "TkError";
    nTokens[BETICAS] = "TkBeticas";
    nTokens[OBLOCK] = "TkOblock";
    nTokens[CBLOCK] = "TkCblock";
    nTokens[QLQ] = "TkQlq";
    nTokens[LETRA] = "TkLetra";
    nTokens[BUS] = "TkBus";
    nTokens[BULULU] = "TkBululu";
    nTokens[POINTER] = "TkPointer";
    nTokens[LEER] = "TkLeer";
    nTokens[IMPRIMIR] = "TkImprimir";
    nTokens[SEMICOLON] = "TkSemicolon";
    nTokens[ASIGN] = "TkAsign";
    nTokens[PLUS] = "TkPlus";
    nTokens[MINUS] = "TkMinus";
    nTokens[MULT] = "TkMult";
    nTokens[POTEN] = "TkPoten";
    nTokens[DIV] = "TkDiv";
    nTokens[INTDIV] = "TkIntDiv";
    nTokens[REST] = "TkRest";
    nTokens[PLUSASIGN] = "TkPlusAsign";
    nTokens[MINUSASIGN] = "TkMinusAsign";
    nTokens[MULTASIGN] = "TkMultAsing";
    nTokens[POTENASIGN] = "TkPotenAsign";
    nTokens[DIVASIGN] = "TkDivAsign";
    nTokens[INTDIVASIGN] = "TkIntDivAsign";
    nTokens[RESTASIGN] = "TkRestAsign";
    nTokens[LESS] = "TkLess";
    nTokens[LEQ] = "TkLeq";
    nTokens[GREATER] = "TkGreater";
    nTokens[GEQ] = "TkGeq";
    nTokens[EQUAL] = "TkEqual";
    nTokens[NQUAL] = "TkNQual";
    nTokens[AND] = "TkAnd";
    nTokens[OR] = "TkOr";
    nTokens[NOT] = "TkNot";
    nTokens[OPAR] = "TkOpar";
    nTokens[CPAR] = "TkCpar";
    nTokens[OBRACKET] = "TkObacket";
    nTokens[CBRACKET] = "TkCbacket";
    nTokens[TAM] = "TkTam";
    nTokens[SITIO] = "TkSitio";
    nTokens[METELE] = "TkMetele";
    nTokens[SACALE] = "TkSacale";
    nTokens[VOLTEA] = "TkVoltea";
    nTokens[HASH] = "ws";
    nTokens[ELDA] = "TkElda";
    nTokens[COBA] = "TkCoba";
    nTokens[COMMA] = "TkComma";
    nTokens[PORSIA] = "TkPorsia";
    nTokens[SINO] = "TkSino";
    nTokens[NIMODO] = "TkNimodo";
    nTokens[TANTEA] = "TkTantea";
    nTokens[CASO] = "TkCaso";
    nTokens[VACILA] = "TkVacila";
    nTokens[IN] = "TkIn";
    nTokens[ACHANTA] = "TkAchanta";
    nTokens[SIGUELA] = "TkSiguela";
    nTokens[PEGAO] = "TkPegao";
    nTokens[CHAMBA] = "TkChamba";
    nTokens[RESCATA] = "TkRescata";
    nTokens[INT] = "TkInt";
    nTokens[FLOAT] = "TkFloat";
    nTokens[STRING] = "TkString";
    nTokens[CHAR] = "TkChar";
    nTokens[WS] = "ws";
    nTokens[DEVALUA] = "TkDevalua";
    nTokens[EFECTIVO] = "TkEfectivo";

}