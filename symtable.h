
#ifndef S_H
#define S_H
#include <vector>
#include <deque>
#include <map>
#include <string>
#include <iostream>
#include <algorithm>
#include "types.h"
using namespace std;

enum elem_tipes {VARIABLE, FUNCTION};

class extra_info{
	public:
		extra_info(){};
		virtual ~extra_info() = default;
};
class extra_info_struct : public extra_info {
	public :
		int child_scope;
		extra_info_struct(int cs):
			extra_info(), child_scope(cs){};
};


class extra_info_func : public extra_info {
	public :
		int child_scope;
		int numArgs;
		bool isGeneric;
		vector<Type*> args_types;
		extra_info_func(int na, vector<Type*> at,bool is_g,  int cs = 0):
			extra_info(), child_scope(cs), numArgs(na), args_types(at), isGeneric(is_g){};
};

/* Elementos de la tabla de simbolos, despues se expandira */
class table_element {
	public:
		string id;
		string category;
		int scope;
		Type * type;
		extra_info * ef;


		table_element(string i, string c , int s, Type * t, extra_info * _ef): id(i),category(c), scope(s), type(t), ef(_ef){};

		bool operator==(const table_element & rhs) const { return (this->scope == rhs.scope && this->id == rhs.id);}

		void print(){
			cout << "SCOPE: " << scope << " CATEGORY: " << category << " Type: " << type->name;
		}
	
};


/* Definicion de la tabla de simbolos */
class sym_table {
	private:
		map<string, deque<table_element*> > table;
		vector<int> stack;
	public:
		int last_scope;
		sym_table() : last_scope(0) {
			stack.push_back(0);
			insert("tam", "func", new Int(),new extra_info_func(1, {new GenericArray()}, true) );
			insert("sitio", "func", new Int(),new extra_info_func(2, {}, true) );
			insert("metele", "func", new Int(),new extra_info_func(2, {}, true) );
			insert("sacale", "func", new Int(),new extra_info_func(1, {new GenericList()}, false) );
			insert("voltea", "func", new Int(),new extra_info_func(1, {new GenericList()}, false) );
			insert("devalua", "func", new Float(),new extra_info_func(1, {new Int()}, false) );
			insert("efectivo", "func", new Int(),new extra_info_func(1, {new Float()}, false) );
			insert("new", "func", new Void(),new extra_info_func(1, {NULL}, false) );
		};

		int new_scope(){

			last_scope++;
			stack.push_back(last_scope);

			// for (size_t i = 0; i < stack.size(); i++)
			// {
			// 	cout << stack[i];
			// }

			return last_scope;
		}

		// void open_scope(std::string x){
		// 	table_element * scope = lookup(x, -1);
		// 	if (scope == NULL){
		// 		std::cout << x << " esta variable no esta definida." << std::endl;
		// 		stack.push_back(-1);
		// 	}
		// 	else if (scope->child_scope == -1){
		// 		std::cout << x << " no es de un tipo complejo." << std::endl;
		// 		error_sintactico = 1;
		// 		stack.push_back(scope->child_scope);
		// 	} else {	
		// 		stack.push_back(scope->child_scope);
		// 	}
		// }

		void exit_scope(){
			if (!stack.empty())
			stack.pop_back();
		}

		table_element * lookup(std::string x){
			table_element * pervasive = NULL;
			table_element * best = NULL;

			for (auto e : table[x]){
				if(e->id == x){
					if(e->scope == 0){
						pervasive = e;
					}else{
						vector<int>::reverse_iterator it = stack.rbegin();
						while(it != stack.rend()){
							if(*it == e->scope){
								best = e;
								break;
							}
							else if(best && *it == best -> scope){
								break;
							}

							it++;

						}
					}
				}
			}
			if(best){
				return best;
			}
			return pervasive;
		}
		table_element * lookup(string id, int scope) {
			for(auto e : table[id]) {
				if(e->id == id) {
					if(scope == e->scope) {
						return e;
					}
				}
			}
			table_element * best = NULL;
			return best;
		}


		// table_element * lookup_top(std::string x){

		// 	if ( tabla.find(x) == tabla.end() ) {
		// 		return NULL;
		// 	} 

		// 	for (std::deque<table_element>::iterator vit = tabla[x].begin() ; vit != tabla[x].end(); vit++){
		// 		if (vit->scope == stack.back()){
		// 			return &(*vit);
		// 		}
		// 	}
		// 	return NULL;
		// }

		bool insert(string id, string category, Type * type, extra_info* ef = NULL ){

			if(table.find(id) == table.end()){
				table[id];
			}
			table_element * e = lookup(id);
			if (e != NULL && e->scope == stack.back() ){
				// std::cout << "La variable " << identifier << " ya esta declarada en el scope: " << stack.back() << std::endl;
				return false;	
			}  

			// cout << "Insertando " << id << " en el scope: " << stack.back();

			table[id].push_front(new table_element(id, category, stack.back(),type, ef));
			return true;
		}

		Type * checkAttr(Node * s, Node * att, int line, int col, vector<string> &errors){
			Node * register_acc = dynamic_cast<ListAccesor*>(s)->accesor;
			string register_id = dynamic_cast<Id*>(register_acc)->id;
			string att_id = dynamic_cast<Id*>(att)->id;


			if(s->type->get_name() == "type_error"){
				return new Type_Error();
			}
			table_element * register_el = lookup(register_id);


			if(register_el == NULL || register_el->category != "struct"){
				string e = "TypeError: '" + register_id + "' is not a struct" + " at line "+ to_string(line) + ", column " + to_string(col) + "\n";
				errors.push_back(e);	
				return new Type_Error();
			}


			int cs = dynamic_cast<extra_info_struct*>(register_el->ef)->child_scope;
			table_element * attr = lookup(att_id,cs);

			if (attr == NULL){
				errors.push_back("Error: type '" + register_id  + "' has no attribute '" + att_id +"' at line "+ to_string(line) + ", column " + to_string(col) + "\n");
				return new Type_Error();
			}
   			return attr->type;
			return new Type_Error();
		}

		bool checkIsValidType(Node * id, int line, int col, vector<string> &errors){
			string id_name = dynamic_cast<Id*>(id)->id;
			table_element * id_el = lookup(id_name);
			if(id_el==NULL){

				string error = "Error: variable " + id_name + " at line " + to_string(line) + ", column " + to_string(col) + ", has not been declared."+ "\n";
				errors.push_back(error);
				return false;
			}
			if(id_el->category != "struct"){
				string error = "Error: '" + id_name + "' is not a type, at line " + to_string(line) + ", column " + to_string(col) + "\n";
				errors.push_back(error);
				return false;
			}
			return true;

		}

		Type * checkUnaryExp(Type * e,string op, int line, int col, vector<string> &errors){
			string e_name = e->get_simple_type();
			if(e_name == "type_error"){
				return e;
			}
			if(op == "-"){
				if(!(e_name == "int" || e_name == "float")){
					
        			string error = "TypeError: expected type 'int' or 'float' but received '" + e_name + "' at line "+ to_string(line) + ", column " + to_string(col) + "\n"; 
					errors.push_back(error);
					return new Type_Error();
				}
				return e;
			}
			if(op == "!"){
				if(!(e_name == "bool")){

        			string error = "TypeError: expected type 'bool' but received '" + e_name + "' at line "+ to_string(line) + ", column " + to_string(col) + "\n"; 
					errors.push_back(error);
					return new Type_Error();
				}
				return e;
			}

		}
		Type * checkDeref(Node * id, int line, int col, vector<string> &errors){
			
			string id_name = dynamic_cast<Id*>(id)->id;
			table_element * id_el = lookup(id_name);
			if(id_el==NULL){

				string error = "Error: variable " + id_name + " at line " + to_string(line) + ", column " + to_string(col) + ", has not been declared."+ "\n";
				errors.push_back(error);
				return  new Type_Error();
			}
			if(id_el->type->get_simple_type() != "pointer"){
        		string error = "TypeError: expected type 'pointer' but received '" + id_el->type->get_simple_type() + "' at line "+ to_string(line) + ", column " + to_string(col) + "\n"; 
				errors.push_back(error);
				return new Type_Error();
			}
			PointerType * p= dynamic_cast<PointerType*>(id_el->type);
			return p->type;
		}


		void print(){		
			std::cout << std::endl << "Imprimiendo tabla de simbolos:" << std::endl; 
			map<string, deque<table_element*>>::iterator it;
			for(it = table.begin(); it != table.end(); it++){

		    	std::cout << "Symbol: " << it->first << endl << '\t' << "[" << endl << "\t\t";
		    	for (auto e : it->second) {
					e->print();
					if (e != it->second.back())
						cout << ", " << endl << "\t\t";
		    	}
				cout << endl << '\t'<< "]" << endl << endl;
			}
		}
};

#endif