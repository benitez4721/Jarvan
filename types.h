

#ifndef TYPES_H
#define TYPES_H
#include <string>
using namespace std;

class Type {
    public: 
        string name;
        Type(string typeName):
           name(typeName) {}
        virtual string get_name(){
            return name;
        }
};

class Int : public Type {
    public:
        Int():Type("int"){};
};

class Float : public Type {
    public:
        Float():Type("float"){};
};

class Char : public Type {
    public:
        Char():Type("char"){};
};

class String : public Type {
    public:
        String():Type("str"){};
};

class Bool : public Type {
    public:
        Bool():Type("bool"){};
};

class Void : public Type {
    public: 
        Void():Type("void"){};
};

class ArrayType: public Type {
    public:
        Type * type;
        int size;
        ArrayType(int s, Type * arrType):Type("array"),size(s), type(arrType){}
        string get_name(){
            return "array <" + type->get_name() + ">[" + to_string(size) + "]";
        }
};

class GenericArray: public Type {
    public: 
        GenericArray():Type("array"){};
};

class ListType: public Type {
    public:
        Type * type;
        ListType( Type * lType):Type("list"),type(lType){}
        string get_name(){
            return "list <" + type->get_name() + "> ";
        }
};

class PointerType: public Type {
    public:
        Type * type;
        PointerType( Type * pType):Type("pointer"),type(pType){}
        string get_name(){
            return "~" + type->get_name();
        }
};

class Type_Error: public Type {
    public: 
        Type_Error():Type("type_error"){};
};

// class Pointer
#endif