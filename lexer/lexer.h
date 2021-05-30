
#include<stdlib.h>
#include<string>
#include<vector>

using namespace std;

class Token {
    public:
        string token;
        string type;
        int row;
        int column;
        Token(string _token, string _type, int _row, int _column);
        string to_str(string mode);
};

class Lexer {
    public:
        vector<Token> tokens;   
        vector<Token> errors;
        Lexer(string program);
        void run(string program);
        void createToken(string lexema, int fila, int columna);
};