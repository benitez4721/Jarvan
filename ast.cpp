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

Body::Body(Node * _l_declaration, Node * _l_instruction){
    l_declaration = _l_declaration;
    l_instruction = _l_instruction;
};
string Body::to_s(int tab, int tabAux){

    string s = "";

    if (l_declaration == NULL && l_instruction != NULL) {
        string s = getTab(tab) + "Block\n" + l_instruction->to_s(tab+1, tab);
    } else if (l_declaration != NULL && l_instruction == NULL) {
        string s = getTab(tab) + "Block\n" + getTab(tab+1) + "Beticas\n" + l_declaration->to_s(tab+2, tab);
    } else {
        string s = getTab(tab) + "Block\n" + getTab(tab+1) + "Beticas\n" + l_declaration->to_s(tab+2, tab) + l_declaration->to_s(tab+3, tab);
    }

    return s;
};

// Declaraciones

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

Declaration::Declaration(Node * _node, Node * _l_declaration){
   node = _node;
   l_declaration = _l_declaration;
};
string Declaration::to_s(int tab, int tabAux){
    string s = node->to_s(tab);
    if(l_declaration){
       s += getTab(tab) + "RegisterBlock\n" + l_declaration->to_s(tab+1);
    };
    return s;
}

// Instrucciones

InstList::InstList(Node * _l_instruction, Node * _instruction){
    l_instruction = _l_instruction;
    instruction = _instruction;
};
string InstList::to_s(int tab, int tabAux) {
    string s = "";
    if(l_instruction != NULL){
        s += l_instruction->to_s(tab, tabAux + 1);
        s += getTab((tab - tabAux) + listlength - 1) + "Sequencing\n" + instruction->to_s((tab - tabAux) + listlength);
    }
    else {
        listlength =  tabAux;
        s += instruction->to_s(tab);
    }
    return s;
};

Inst::Inst(Node * _node, Node * _l_instruction){
   node = _node;
   l_instruction = _l_instruction;
};
string Inst::to_s(int tab, int tabAux){
    string s = node->to_s(tab);
    if(l_instruction){
       s += getTab(tab) + "InstructionBlock\n" + l_instruction->to_s(tab+1);
    };
    return s;
}

// Id's

Id::Id(string _id){
    id = _id;
};
string Id::to_s(int tab, int tabAux){
    return getTab(tab) + "ident: " + id + "\n";
};

Asign::Asign(Node * _id){
    id = _id;
};
string Asign::to_s(int tab, int tabAux){
    return getTab(tab) + "Asign\n" + id->to_s(tab+1) + getTab(tab+1) + "Exp\n" + getTab(tab+2) + "Literal: 5\n";
};



