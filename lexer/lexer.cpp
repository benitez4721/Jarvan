#include<stdlib.h>
#include<iostream>
#include<string>
#include "lexer.h"
#include <map>
#include <regex>
using namespace std;

regex labia("\".*\"");
regex id("[a-zA-Z_][a-z0-9-A-Z_]*");
regex bs("[0-9]+");
regex bsf("[0-9]+.[0-9]+");
map<string, string> tokensDict = {
    {"Beticas", "TkBeticas"},
    {"{", "TkOblock"},
    {"}", "TkCblock"},
    {"bs", "TkBs"},
    {"bsf", "TkBs"},
    {"qlq", "TkQlq"},
    {"letra", "TkLetra"},
    {"labia", "TkLabia"},
    {"bus", "TkBus"},
    {"bululu", "TkBululu"},
    {"@", "TkPointer"},
    {"leer", "TkLeer"},
    {"imprimir", "TkImprimir"},
    {";", "TkSemiColon"},
    {"=", "TkAsign"},
    {"+", "TkPlus"},
    {"-", "TkMinus"},
    {"*", "TkMult"},
    {"^", "TkPoten"},
    {"/", "TkDiv"},
    {"//", "TkIntDiv"},
    {"%", "TkRest"},
    {"+=", "TkPlusAsign"},
    {"-=", "TkMinusAsign"},
    {"*=", "TkMultAsign"},
    {"^=", "TkMultAsign"},
    {"/=", "TkDivAsign"},
    {"//=", "TkIntDivAsign"},
    {"%=", "TkRestAsign"},
    {"<", "TkLess"},
    {"<=", "TkLeq"},
    {">", "TkGreater"},
    {">=", "TkGeq"},
    {"==", "TkEqual"},
    {"!=", "TkNEqual"},
    {"&&", "TkAnd"},
    {"||", "TkOr"},
    {"!", "TkNot"},
    {"(", "TkOPar"},
    {")", "TkCPar"},
    {"[", "TkOBracket"},
    {"]", "TkCBracket"},
    {"tam","TkTam"},
    {"sitio","TkSitio"},
    {"metele","TkMetele"},
    {"sacale","TkSacale"},
    {"voltea","TkVoltea"},
    {"#","TkHash"},
    {"/#","TkOHash"},
    {"#/", "TkCHash"},
    {"elda", "TkElda"},
    {"coba", "TkCoba"},
    {",", "TkComma"},
    {"porsia", "TkPorsia"},
    {"sino", "TkSino"},
    {"nimodo", "TkNimodo"},
    {"tantea", "TKTantea"},
    {"caso", "TkCaso"},
    {"vacila", "TkVacila"},
    {"in", "TkIn"},
    {"achanta", "TkAchanta"},
    {"siguela", "TkSiguela"},
    {"pegao", "TkPegao"},
    {"Chamba", "TkChamba"},
    {"rescata", "TkRescata"},
};

Token::Token(string _token, string _type, int _row, int _column) {
            token = _token;
            type = _type;
            row = _row;
            column = _column;
        };

string Token::to_str(){
    if(type == "TkError"){
        token.erase(remove(token.begin(), token.end(), '\n'), token.end());
        return "Error: Unexpected character: " + token  + " in row: " + to_string(row) + ", column: " + to_string(column) + '\n';
    }
    else if(type == "TkId" || type == "TkBs" || type == "TkBsf" || type == "TkLabia"){
        string token_display;
        if(type == "TkLabia"){
            token_display = '(' + token + ')';
        }
        else{
            token_display = "(\"" + token + "\")";
        }
        return type + token_display + " " + to_string(row) + " " + to_string(column) + '\n';
    }
    else{
        // Remove line end from token
        return type + " " + to_string(row) + " " + to_string(column) + '\n';
    }
}

Lexer::Lexer(string program){
    run(program);
};

void Lexer::run(string program){
    string lexema = "";
    int row = 1;
    int column = 1;
    char c;
    
    for(int i = 0; i < program.size(); i++) {

        //Comments
        c = program[i];
        if (c == '#'){
            while(c != '\n'){
                i++;
                column++;
                c = program[i];
            }
            row++;
            column = 1;
        }

        //Labias
        else if (c == '"') {
            bool  closeStringFound = true;
            lexema += c;
            i++;
            c = program[i];

            while (c != '"'){
                if (c == '\\'){
                    lexema += c;
                    i++;
                    c = program[i];
                }
                lexema += c;
                i++;
                if(i >= program.size()){
                    closeStringFound = false;
                    break;
                }
                else{
                    c = program[i];
                }
            }

            if(closeStringFound){
                lexema += c;
            }
            else{
                lexema = "\"";
            }

            createToken(lexema, row, column);
            column += lexema.size();
            lexema = "";
        }

        else if(c == ' ') {
            if(lexema.size()){
                createToken(lexema, row, column);
                lexema = "";
            }
            i++;
            column++;
        }

        else if(c == '\n') {
            row++;
            column = 1;
        }

        else {
            lexema += c;
        }    

    }

    if(lexema.size()){
        createToken(lexema, row, column);
    }
};

void Lexer::createToken(string lexema, int row, int column){
    string type = tokensDict[lexema];
    if (type == ""){
       if (regex_match(lexema, labia)){
           type = "TkLabia";
       } 
       else if (regex_match(lexema, bs)){
           type = "TkBs";
       }
       else if (regex_match(lexema, bsf)){
           type = "TkBsf";
       }
       else if (regex_match(lexema, id)){
           type = "TkId";
       }
       else {
           type = "TkError";
       }
    }

    Token token(lexema, type, row, column);
    if (token.type == "TkError"){
        errors.push_back(token);
    }
    else {
        tokens.push_back(token);
    }
}
