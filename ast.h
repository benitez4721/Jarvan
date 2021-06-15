#include <string>

using namespace std;


string getTab(int tab);

class Node {
    public:
        virtual string to_s(int tab, int tabAux = 0) { };
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
        string to_s();

};

