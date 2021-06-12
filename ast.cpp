#include "ast.h"
#include "iostream"

using namespace std;


string getTab(int tab){
    string s="";
    for (int i = 0; i < tab; i++)
    {
       s += ' ';
    }
    return s;
    
}

 
Program::Program(Node * _body){
   body = _body;
};

string Program::to_s(){
    return body->to_s(0);
};


Body::Body(Node * _l_declaration){
    l_declaration = _l_declaration;
};

string Body::to_s(int tab){
    string s = getTab(tab) + "Block\n" + getTab(tab+1) + "Beticas\n" + l_declaration->to_s(tab+2);
    return s;
};


// DeclarationList::DeclarationList(DeclarationList * l_declaration){
//     l_declaration = l_declaration;
// };

string DeclarationList::to_s(int tab) {
    return getTab(tab) +  "DeclarationList\n";
};



