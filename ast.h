#include <string>

using namespace std;


string getTab(int tab);

class Node {
    public:
        virtual string to_s(int tab) { };
};

class Declaration {

};

class DeclarationList : public Node{
    public:
        Node * l_declaration;
        Declaration * declaration;
        // DeclarationList(DeclarationList * l_declaration);
        string to_s(int tab);
};

class Body : public Node{
    public:
        Node * l_declaration;
        Body(Node * l_declaration);
        string to_s(int tab);
};

class Program : public Node{
    public: 
        Node * body;
        Program(Node * body);
        string to_s();

};

