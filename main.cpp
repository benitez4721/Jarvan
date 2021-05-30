
#include<iostream>
#include<stdlib.h>
#include<string.h>
#include<fstream>
#include<algorithm>
#include "lexer/lexer.h"
using namespace std;

string readFile(string filePath);

// Recieve file path from command args, example: .\lexer.exe test.txt
int main(int argc, char *argv[]){
    string filePath = argv[1];
    string  program = readFile(filePath);
    Lexer lexer(program);
    if(lexer.errors.size() > 0){
        for(int i = 0; i < lexer.errors.size(); i++){
            cout << lexer.errors[i].to_str("error");
        }
    }else {
        for(int i = 0; i < lexer.tokens.size(); i++){
            cout << lexer.tokens[i].to_str("type");
        }
    }
    return 0;
}

string readFile(string filePath){
    ifstream file;
    file.open(filePath, ios::in);
    string program;
    string line;

    if(file.fail()){
        cout<<"Error, file cannot be open.";
        exit(1);
    }

    // Read each line in the file
    while(!file.eof()){
        getline(file,line);
        program += line + '\n';
    }

    file.close();
    
    return program;
}