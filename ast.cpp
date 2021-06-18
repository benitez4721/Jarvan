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

    if (l_declaration != NULL) {
        s += getTab(tab) + "Block\n" + l_declaration->to_s(tab+1, tab);
        if(l_instruction != NULL){
            s += l_instruction->to_s(tab+1,tab);
        };
    } else {
        s +=  l_instruction->to_s(tab+1, tab);
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
        s += getTab((tab - tabAux) + listlength - 1) + "Sequencing\n" + declaration->to_s((tab - tabAux) + listlength, listlength - 1);
    }
    else {
        listlength =  tabAux;
        s += declaration->to_s(tab, listlength - 1);
    }
    return s;
};

Declaration::Declaration(Node * _node, Node * _l_declaration){
   node = _node;
   l_declaration = _l_declaration;
};
string Declaration::to_s(int tab, int tabAux){
    string s = "";
    if(l_declaration){
        s += getTab(tab) + "RegisterBlock\n" + l_declaration->to_s(tab+1, tabAux);
    }else{
        s += node->to_s(tab);
    }
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

Inst::Inst(Node * _node){
   node = _node;
};
string Inst::to_s(int tab, int tabAux){
    string s = node->to_s(tab);
    return s;
}

// Id's

Id::Id(string _id){
    id = _id;
};
string Id::to_s(int tab, int tabAux){
    return getTab(tab) + "ident: " + id + "\n";
};

// Asignacion

Asign::Asign(Node * _id, Node * _exp){
    id = _id;
    exp = _exp;
};
string Asign::to_s(int tab, int tabAux){
    return getTab(tab) + "Asign\n" + id->to_s(tab+1) + getTab(tab+1) + "Exp\n" + exp->to_s(tab+2);
};

// Expresiones

Exp::Exp(Node * _exp){
    exp = _exp;
};
string Exp::to_s(int tab, int tabAux){
    return exp->to_s(tab);
}

BinaryExp::BinaryExp(Node * _op1, Node * _op2, string _op) {
    op1 = _op1;
    op2 = _op2;
    op = _op;
    // if (_op  == "PLUS") {
    //     op = "+";
    // } else if (_op  == "MINUS") {
    //     op = "-";
    // } else if (_op  == "MULT") {
    //     op = "*";
    // } else if (_op  == "DIV") {
    //     op = "-";
    // } else if (_op  == "INTDIV") {
    //     op = "-";
    // } else if (_op  == "REST") {
    //     op = "-";
    // } else if (_op  == "POTEN") {
    //     op = "^";
    // } else if (_op  == "AND") {
    //     op = "-";
    // } else if (_op  == "OR") {
    //     op = "-";
    // }
    
};
string BinaryExp::to_s(int tab, int tabAux){
    return getTab(tab) + op + "\n" + op1->to_s(tab+1) + op2->to_s(tab+1); 
}



// Literales

LiteralInt::LiteralInt(int _value){
   value = _value;
};
string LiteralInt::to_s(int tab, int tabAux){
    return getTab(tab) + "Literal: " + to_string(value) + "\n"; 
}

LiteralFloat::LiteralFloat(float _value){
   value = _value;
};
string LiteralFloat::to_s(int tab, int tabAux){
    return getTab(tab) + "Literal: " + to_string(value); 
}

LiteralChar::LiteralChar(char _value){
   value = _value;
};
string LiteralChar::to_s(int tab, int tabAux){
    return getTab(tab) + "Literal: " + value; 
}

LiteralStr::LiteralStr(string _value){
   value = _value;
};
string LiteralStr::to_s(int tab, int tabAux){
    return getTab(tab) + "Literal: " + value; 
};

LiteralBool::LiteralBool(bool _value){
   value = _value;
};
string LiteralBool::to_s(int tab, int tabAux){
    return getTab(tab) + "Literal: " + "true"; 
}