#include "ast.h"
#include "iostream"

using namespace std;

int listlength;
int instListLen;
int argsList;

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
string Program::to_s(int tab, int tabAux){
    return body->to_s(tab);
};

Body::Body(Node * _l_declaration, Node * _l_instruction){
    l_declaration = _l_declaration;
    l_instruction = _l_instruction;
};
string Body::to_s(int tab, int tabAux){

    string s = getTab(tab) + "Block\n";

    if (l_declaration != NULL) {
        s += getTab(tab+1) + "Beticas\n" + l_declaration->to_s(tab+2, tab);
        if(l_instruction != NULL){
            s += getTab(tab+1) + "Instructions\n" + l_instruction->to_s(tab+2,tab);
        };
    } else {
        s += getTab(tab+1) + "Instructions\n" + l_instruction->to_s(tab+2, tab);
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
        s += getTab((tab - tabAux) + instListLen - 1) + "Sequencing\n" + instruction->to_s((tab - tabAux) + instListLen, instListLen - 1);
    }
    else {
        instListLen = tabAux;
        s += instruction->to_s(tab, instListLen - 1);
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
    return getTab(tab) + "Literal: " + value + "\n"; 
};

LiteralBool::LiteralBool(string _value){
   value = _value;
};
string LiteralBool::to_s(int tab, int tabAux){
    return getTab(tab) + "Literal: " + value + "\n"; 
};

Accesor::Accesor(Node * _idNode, string _id){
    idNode = _idNode;
    id = _id;
};
string Accesor::to_s(int tab, int tabAux){
    return getTab(tab) + "Accesor";
}

ListAccesor::ListAccesor(Node * _l_accesor, Node * _accesor){
    l_accesor = _l_accesor;
    accesor = _accesor;
};
string ListAccesor::to_s(int tab, int tabAux){
    string s = "";
    if(l_accesor != NULL){
        s += l_accesor->to_s(tab, tabAux + 1);
        s += getTab((tab - tabAux) + listlength - 1) + "AccesTo\n" + accesor->to_s((tab - tabAux) + listlength);
    }
    else {
        listlength =  tabAux;
        s += accesor->to_s(tab);
    }
    return s;
}

ListIndexing::ListIndexing(Node * _l_index, Node * _exp){
    l_index = _l_index;
    exp = _exp;
};
string ListIndexing::to_s(int tab, int tabAux){
    string s = "";
    if(l_index != NULL){
        s += l_index->to_s(tab, tabAux + 1);
        s += getTab((tab - tabAux) + listlength - 1) + "Indexing\n" + exp->to_s((tab - tabAux) + listlength);
    }
    else {
        listlength =  tabAux;
        s += exp->to_s(tab);
    }
    return s;
}

Indexing::Indexing(Node * _id, Node * _l_index){
    l_index = _l_index;
    id = _id;
};
string Indexing::to_s(int tab, int tabAux){
    return getTab(tab) + "Indexing\n" + id->to_s(tab+1) + l_index->to_s(tab+1);
}

ArrayList::ArrayList(Node * _l_exp, Node * _exp){
    l_exp = _l_exp;
    exp = _exp;
};
string ArrayList::to_s(int tab, int tabAux){
    string s = "";
    if(l_exp != NULL){
        s += l_exp->to_s(tab, tabAux + 1);
        s += getTab((tab - tabAux) + listlength - 1) + "Comma\n" + exp->to_s((tab - tabAux) + listlength);
    }
    else {
        listlength =  tabAux;
        s += exp->to_s(tab);
    }
    return s;
}

Array::Array(Node * _l_array){
    l_array = _l_array;
};
string Array::to_s(int tab, int tabAux){
    return getTab(tab) + "Array\n" + l_array->to_s(tab+1);
}

Io::Io(Node * _exp, string _inst){
    exp = _exp;
    inst = _inst;
};
string Io::to_s(int tab, int tabAux){
    return getTab(tab) + inst + "\n" + exp->to_s(tab+1);
}

Seleccion::Seleccion(Node * _guard, Node * _program, Node * _seleccion2, string _inst){
    guard = _guard;
    program = _program;
    seleccion2 = _seleccion2;
    inst = _inst;
};
string Seleccion::to_s(int tab, int tabAux){

    string s = getTab(tab) + inst + "\n";

    if(guard != NULL){
        s += getTab(tab+1) + "Guard\n" + guard->to_s(tab+2) + program->to_s(tab+1);
    }else{
        s += program->to_s(tab+1);
    }

    if(seleccion2 != NULL){
        s += seleccion2->to_s(tab);
    }
    return s;
}

Tantea::Tantea(Node * _id, Node * _casos){
    id = _id;
    casos = _casos;
};
string Tantea::to_s(int tab, int tabAux){
    string s = "";
    s += getTab(tab) + "Tantea\n" + id->to_s(tab+1) + getTab(tab+1) + "Cases\n" + casos->to_s(tab+2);
    return s;
}

Caso::Caso(Node * _l_casos, Node * _exp, Node * _program){
    l_casos = _l_casos;
    exp = _exp;
    program = _program;
};
string Caso::to_s(int tab, int tabAux){
    string s = "";
    if(l_casos != NULL){
        s += l_casos->to_s(tab, tabAux + 1);
        s += getTab((tab - tabAux) + listlength - 1) + "NextCase\n" + getTab((tab - tabAux) + listlength) + "Guard\n"  + exp->to_s((tab - tabAux) + listlength + 1) + program->to_s((tab - tabAux) + listlength);
    }
    else {
        listlength =  tabAux;
        s += getTab(tab) + "Guard\n" + exp->to_s(tab + 1) + program->to_s(tab);
    }
    return s;
}

EmbededFunc::EmbededFunc(string _inst, Node * _exp){
    inst = _inst;
    exp = _exp;
};
string EmbededFunc::to_s(int tab, int tabAux){
    string s = "";
    s += getTab(tab) + inst + "\n" + exp->to_s(tab+1); 
    return s;
}

Chamba::Chamba(Node * _id, Node * _params, Node * _program){
    id = _id;
    params = _params;
    program = _program;
};
string Chamba::to_s(int tab, int tabAux){
    string s = getTab(tab) + "Chamba\n";
    if(params != NULL){
       s += getTab(tab + 1) + "Params\n" + params->to_s(tab + 2) + program->to_s(tab + 1);
    }
    else{
        s += program->to_s(tab+1);
    }
    return s;
}

Params::Params(Node * _l_params, Node * _param){
    l_params = _l_params;
    param = _param;
};
string Params::to_s(int tab, int tabAux){
    string s = "";
    if(l_params != NULL){
        s += l_params->to_s(tab, tabAux + 1);
        s += getTab((tab - tabAux) + argsList - 1) + "Comma\n" + param->to_s((tab - tabAux) + argsList, argsList - 1);
    }
    else {
        argsList =  tabAux;
        s += param->to_s(tab, argsList - 1);
    }
    return s;
}

FunCall::FunCall(Node * _id, Node * _args){
    id = _id;
    args = _args;
};
string FunCall::to_s(int tab, int tabAux){
    string s = getTab(tab) + "Funcall\n" + id->to_s(tab+1);
    if(args != NULL){
       s += getTab(tab + 1) + "Args\n" + args->to_s(tab + 2);
    }
    return s;
}

Repeticion::Repeticion(Node * _declaration, Node * _exp1, Node * _exp2, Node * _id, Node * _program){
    declaration = _declaration;
    exp1 = _exp1;
    exp2 = _exp2;
    id = _id;
    program = _program;
};
string Repeticion::to_s(int tab, int tabAux){
    string s = getTab(tab) + "Vacila\n";
    if (declaration != NULL) {
        s += declaration->to_s(tab+1);
        s += getTab(tab+1) + exp1->to_s(tab+2) + exp2->to_s(tab+2);
        s += getTab(tab+1) + program->to_s(tab+2);
    } else {
        s += id->to_s(tab+1);
        s += getTab(tab) + "in\n" + exp1->to_s(tab+1);
        s += getTab(tab) + program->to_s(tab+2);
    }

    return s;
}

Repeticion2::Repeticion2(Node * _exp, Node * _program){
    exp = _exp;
    program = _program;
};
string Repeticion2::to_s(int tab, int tabAux){
    string s = getTab(tab) + "Pegao\n" + getTab(tab+1) + "Guard\n" + exp->to_s(tab+2) + program->to_s(tab+1);

    return s;
}

Unary::Unary(Node * _exp, string _op){
    exp = _exp;
    op = _op;
};
string Unary::to_s(int tab, int tabAux){
    return getTab(tab) + op + "\n" + exp->to_s(tab+1);
}