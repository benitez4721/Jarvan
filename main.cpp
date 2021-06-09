
#include<iostream>
#include<stdlib.h>
#include<string.h>
#include<fstream>
#include<algorithm>
#include "lexer.h"
using namespace std;

extern FILE* yyin;
extern int yyparse();

// Recieve file path from command args, example: .\lexer.exe test.txt
int main(int argc, char *argv[]){
    string filePath = argv[1];
    yyin = fopen(argv[1], "r");
    Lexer lexer;
    yyparse();
    // lexer.init_tokens_definitions();
    // lexer.run();
    // if(lexer.errors.size() > 0){
    //     for(int i = 0; i < lexer.errors.size(); i++){
    //         cout << lexer.errors[i].to_str();
    //     }
    // }else {
    //     try {
    //     }
    //     catch(const char* const errorMessage){
    //         cout << "Error: " << endl;
    //             cout << errorMessage << endl;
    //     }
    // }
    return 0;
}