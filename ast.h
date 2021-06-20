#include <string>

using namespace std;


string getTab(int tab);

class Node {
    public:
        virtual string to_s(int tab, int tabAux = 0) { };
};

class VacilaIn : public Node {
    public:
        Node * id;
        Node * exp;
        Node * program;
        VacilaIn(Node * id, Node * exp, Node * program);
        string to_s(int tab, int tabAux = 0);
};

class Repeticion2 : public Node {
    public:
        Node * exp;
        Node * program;
        Repeticion2(Node * exp, Node * program);
        string to_s(int tab, int tabAux = 0);
};

class Repeticion : public Node {
    public:
        Node * declaration;
        Node * exp1;
        Node * exp2;
        Node * id;
        Node * program;
        Repeticion(Node * declaration, Node * exp1, Node * exp2, Node * id, Node * program);
        string to_s(int tab, int tabAux = 0);
};

class FunCall : public Node {
    public:
        Node * id;
        Node * args;
        FunCall(Node * , Node * args);
        string to_s(int tab, int tabAux = 0);
};

class Params : public Node {
    public:
        Node * l_params;
        Node * param;
        Params(Node * l_params , Node * param);
        string to_s(int tab, int tabAux = 0);
};

class Chamba : public Node {
    public:
        Node * id;
        Node * params;
        Node * program;
        Chamba(Node * id , Node * params, Node * program);
        string to_s(int tab, int tabAux = 0);
};

class EmbededFunc : public Node {
    public:
        string inst;
        Node * exp;
        EmbededFunc(string isnt, Node * exp);
        string to_s(int tab, int tabAux = 0);
};

class Caso : public Node {
    public:
        Node * l_casos;
        Node * exp;
        Node * program;
        Caso(Node * l_casos, Node * exp, Node * program);
        string to_s(int tab, int tabAux = 0);
};

class Tantea : public Node {
    public:
        Node * id;
        Node * casos;
        Tantea(Node * id, Node * casos);
        string to_s(int tab, int tabAux = 0);
};

class Seleccion : public Node {
    public:
        Node * guard;
        Node * program;
        Node * seleccion2;
        string inst;
        Seleccion(Node * guard, Node * program, Node * seleccion2, string inst);
        string to_s(int tab, int tabAux = 0);
};

class Io : public Node {
    public:
        Node * exp;
        string inst;
        Io(Node * exp, string inst);
        string to_s(int tab, int tabAux = 0);
};

class Array : public Node {
    public:
        Node * l_array;
        Array(Node * l_array);
        string to_s(int tab, int tabAux = 0);
};

class ArrayList : public Node {
    public:
        Node * l_exp;
        Node * exp;
        ArrayList(Node * l_exp, Node * exp);
        string to_s(int tab, int tabAux = 0);
};

class Indexing : public Node {
    public:
        Node * id;
        Node * l_index;
        Indexing(Node * id, Node * l_index);
        string to_s(int tab, int tabAux = 0);
};

class ListIndexing : public Node {
    public:
        Node * l_index;
        Node * exp;
        ListIndexing(Node * l_index, Node * exp);
        string to_s(int tab, int tabAux = 0);
};

class ListAccesor : public Node {
    public:
        Node * l_accesor;
        Node * accesor;
        ListAccesor(Node * l_accesor, Node * accesor);
        string to_s(int tab, int tabAux = 0);
};

class Accesor : public Node{
    public:
        Node * idNode;
        string id;
        Accesor(Node * idNode, string id);
        string to_s(int tab, int tabAux = 0);
};

class BinaryExp : public Node {
    public:
        Node * op1;
        Node * op2;
        string op;
        BinaryExp(Node * op1, Node * op2, string op);
        string to_s(int tab, int tabAux = 0);
};

class LiteralBool : public Node {
    public: 
        string value;
        LiteralBool(string value);
        string to_s(int tab, int tabAux = 0);

};

class LiteralStr : public Node {
    public: 
        string value;
        LiteralStr(string value);
        string to_s(int tab, int tabAux = 0);

};

class LiteralChar : public Node {
    public: 
        char value;
        LiteralChar(char value);
        string to_s(int tab, int tabAux = 0);

};

class LiteralFloat : public Node {
    public: 
        float value;
        LiteralFloat(float value);
        string to_s(int tab, int tabAux = 0);

};

class LiteralInt : public Node {
    public: 
        int value;
        LiteralInt(int value);
        string to_s(int tab, int tabAux = 0);

};

class Exp : public Node {
    public:
        Node *exp;
        Exp(Node *exp);
        string to_s(int tab, int tabAux = 0);
};

class Asign : public Node {
    public: 
        Node *id;
        Node *exp;
        Asign(Node * id, Node * exp);
        string to_s(int tab, int tabAux = 0);
};

class Id : public Node {
    public:
        string id;
        Id(string id);
        string to_s(int tab, int tabAux = 0);
};

class Declaration : public Node {
    public:
        Node * node;
        Node * l_declaration;
        Declaration(Node * node, Node * l_declaration);
        string to_s(int tab, int tabAux = 0);
        

};

class DeclarationList : public Node{
    public:
        Node * l_declaration;
        Node * declaration;
        DeclarationList(Node * l_declaration, Node * declaration);
        string to_s(int tab, int tabAux = 0);
};

class Inst : public Node {
    public:
        Node * node;
        Inst(Node * node);
        string to_s(int tab, int tabAux = 0);
};

class InstList : public Node{
    public:
        Node * l_instruction;
        Node * instruction;
        InstList(Node * l_instruction, Node * instruction);
        string to_s(int tab, int tabAux = 0);
};

class Body : public Node{
    public:
        Node * l_declaration;
        Node * l_instruction;
        Body(Node * l_declaration, Node * l_instruction);
        string to_s(int tab, int tabAux = 0);
};

class Program : public Node{
    public: 
        Node * body;
        Program(Node * body);
        string to_s(int tab, int tabAux);
};

