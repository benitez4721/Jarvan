
#include<iostream>
#include<stdlib.h>
#include<string.h>
#include<fstream>
#include<algorithm>
#include "lexer/lexer.h"
using namespace std;

extern FILE* yyin;

// Recieve file path from command args, example: .\lexer.exe test.txt
int main(int argc, char *argv[]){
    string filePath = argv[1];
    yyin = fopen(argv[1], "r");
    Lexer lexer;
    lexer.init_tokens_definitions();
    lexer.run();
    if(lexer.errors.size() > 0){
        for(int i = 0; i < lexer.errors.size(); i++){
            cout << lexer.errors[i].to_str();
        }
    }else {
        for(int i = 0; i < lexer.tokens.size(); i++){
            cout << lexer.tokens[i].to_str();
        }
    }
    return 0;
}

// string readFile(string filePath){
//     ifstream file;
//     file.open(filePath, ios::in);
//     string program;
//     string line;

//     if(file.fail()){
//         cout<<"Error, file cannot be open.";
//         exit(1);
//     }

//     // Read each line in the file
//     while(!file.eof()){
//         getline(file,line);
//         program += line + '\n';
//     }

//     file.close();
    
//     return program;
// }