#include <string>

using namespace std;


string getTab(int tab);

class Node {
    public:
        virtual string to_s(int tab, int tabAux = 0) { };
};

// class Literal : public Node {
//     public: 
//         any value;

// }

class Asign : public Node {
    public: 
        Node *id;
        Asign(Node * id);
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

class Body : public Node{
    public:
        Node * l_declaration;
        Body(Node * l_declaration);
        string to_s(int tab, int tabAux = 0);
};

class Program : public Node{
    public: 
        Node * body;
        Program(Node * body);
        string to_s();

};

