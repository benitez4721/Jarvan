#include<stdlib.h>
#include<string>
#include<vector>

using namespace std;

extern string nTokens[]; 
void init_tokens_definitions();

class Token {
    public:
        string token;
        string type;
        int row;
        int column;
        Token(string _token, string _type, int _row, int _column);
        string to_str();
};