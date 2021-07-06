
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