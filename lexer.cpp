
#include<iostream>
#include<stdlib.h>
#include<string.h>
#include<fstream>
#include<algorithm>
using namespace std;

string readFile(string filePath);

// Recieve file path from command args, example: .\lexer.exe test.txt
int main(int argc, char *argv[]){
    string filePath = argv[1];
    string  program = readFile(filePath);
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
        program += line;
    }

    file.close();
    
    // Remove whitespaces
    std::string::iterator end_pos = remove(program.begin(), program.end(), ' ');
    program.erase(end_pos, program.end());
    return program;
}