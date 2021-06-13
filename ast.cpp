#include "ast.h"
#include "iostream"

using namespace std;

int listlength;

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
string Body::to_s(int tab, int tabAux){
    string s = getTab(tab) + "Block\n" + getTab(tab+1) + "Beticas\n" + l_declaration->to_s(tab+2, tab);
    return s;
};

DeclarationList::DeclarationList(Node * _l_declaration, Node * _declaration){
    l_declaration = _l_declaration;
    declaration = _declaration;
};
string DeclarationList::to_s(int tab, int tabAux) {
    string s = "";
    if(l_declaration != NULL){
        s += l_declaration->to_s(tab, tabAux + 1);
        s += getTab((tab - tabAux) + listlength - 1) + "Sequencing\n" + declaration->to_s((tab - tabAux) + listlength);
    }
    else {
        listlength =  tabAux;
        s += declaration->to_s(tab);
    }
    return s;
};

Declaration::Declaration(string _id){
   id = _id;
}
string Declaration::to_s(int tab, int tabAux){
    return getTab(tab) + "ident: " + id + "\n";
}



