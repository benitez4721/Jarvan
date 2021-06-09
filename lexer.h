
#include<stdlib.h>
#include<string>
#include<vector>

using namespace std;

#define BETICAS 1
#define OBLOCK 2
#define CBLOCK 3
#define BS 4
#define BSF 5
#define QLQ 6
#define LETRA 7
#define LABIA 8
#define BUS 9
#define BULULU 10
#define POINTER 11
#define LEER 12
#define IMPRIMIR 13
#define SEMICOLON 14
#define ASIGN 15
#define PLUS 16
#define MINUS 17
#define MULT 18
#define POTEN 19
#define DIV 20
#define INTDIV 21
#define REST 22
#define PLUSASIGN 23
#define MINUSASIGN 24
#define MULTASIGN 25
#define POTENASIGN 26
#define DIVASIGN 27
#define INTDIVASIGN 28
#define RESTASIGN 29
#define LESS 30
#define LEQ 31
#define GREATER 32
#define GEQ 33
#define EQUAL 34
#define NQUAL 35
#define AND 36
#define OR 37
#define NOT 38
#define OPAR 39
#define CPAR 40
#define OBRACKET 41
#define CBRACKET 42
#define TAM 43
#define SITIO 44
#define ID 45
#define ERROR 46
#define METELE 47
#define SACALE 48
#define VOLTEA 49
#define HASH 50
#define OHASH 51
#define CHASH 52
#define ELDA 53
#define COBA 54
#define COMMA 55
#define PORSIA 56
#define SINO 57
#define NIMODO 58
#define TANTEA 59
#define CASO 60
#define VACILA 61
#define IN 62
#define ACHANTA 63
#define SIGUELA 64
#define PEGAO 65
#define CHAMBA 66
#define RESCATA 67
#define INT 68
#define FLOAT 69
#define STRING 70
#define CHAR 71
#define WS 72
#define DEVALUA 73
#define EFECTIVO 74



class Token {
    public:
        string token;
        string type;
        int row;
        int column;
        Token(string _token, string _type, int _row, int _column);
        string to_str();
};

class Lexer {
    public:
        vector<Token> tokens;   
        vector<Token> errors;
        void run();
        void createToken(string lexema, int fila, int columna);
        void init_tokens_definitions();
};