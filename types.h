
#include <string>
using namespace std;

class Type {
    public: 
        string name;
        Type(string typeName):
            name(typeName) {};
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