#ifndef TABLE_H
#define TABLE_H

#include <vector>
#include <deque>
#include <map>
#include <string>
#include <iostream>
#include <algorithm>

enum elem_tipes {VARIABLE, FUNCTION};
extern bool error_sintactico;

/* Elementos de la tabla de simbolos, despues se expandira */
class table_element {
	public:
		std::string id;
		int scope;
		int child_scope;
		elem_tipes type;

		table_element(std::string i, int s, elem_tipes e): id(i), scope(s), type(e), child_scope(-1){};

		bool operator==(const table_element & rhs) const { return (this->scope == rhs.scope && this->id == rhs.id);}

		void print(){
			std::cout << "SCOPE: " << scope ; 
			if (child_scope != -1)
				std::cout << ", CHILD SCOPE: " << child_scope ; 

		}
};


/* Definicion de la tabla de simbolos */
class sym_table {
	private:
		std::map<std::string, std::deque<table_element> > tabla;
		std::vector<int> stack;
		int last_scope;
	public:
		sym_table() : last_scope(0) {stack.push_back(last_scope);}

		int new_scope(){
			last_scope++;
			stack.push_back(last_scope);
			return last_scope;
		}

		void open_scope(std::string x){
			table_element * scope = lookup(x, -1);
			if (scope == NULL){
				std::cout << x << " esta variable no esta definida." << std::endl;
				stack.push_back(-1);
			}
			else if (scope->child_scope == -1){
				std::cout << x << " no es de un tipo complejo." << std::endl;
				error_sintactico = 1;
				stack.push_back(scope->child_scope);
			} else {	
				stack.push_back(scope->child_scope);
			}
		}

		void exit_scope(){
			if (!stack.empty())
			stack.pop_back();
		}

		table_element * lookup(std::string x, int scope){

			if ( tabla.find(x) == tabla.end() ) {
				return NULL;
			} 

			for (std::deque<table_element>::iterator vit = tabla[x].begin() ; vit != tabla[x].end(); vit++){
				if ( scope == -1  && (std::find(stack.begin(), stack.end(), vit->scope) != stack.end() ) ){
					return &(*vit);
				} 
				if ( scope != -1 && vit->scope == scope ){
					return &(*vit);
				}
			}
			return NULL;
		}

		table_element * lookup_top(std::string x){

			if ( tabla.find(x) == tabla.end() ) {
				return NULL;
			} 

			for (std::deque<table_element>::iterator vit = tabla[x].begin() ; vit != tabla[x].end(); vit++){
				if (vit->scope == stack.back()){
					return &(*vit);
				}
			}
			return NULL;
		}

		bool insert(std::string identifier){
			if(tabla.find(identifier) == tabla.end()){
				tabla[identifier];
			}
			if (lookup(identifier, stack.back()) != NULL){
				// std::cout << "La variable " << identifier << " ya esta declarada en el scope: " << stack.back() << std::endl;
				return false;	
			}  

			tabla[identifier].push_front(table_element(identifier, stack.back(), VARIABLE));
			return true;
		}

		void print(){		
			std::cout << std::endl << "Imprimiendo tabla de simbolos:" << std::endl; 
		    for(std::map<std::string, std::deque<table_element> >::iterator it = tabla.begin(); it != tabla.end(); ++it) {
		    	std::cout << "Variable: " << it->first << " [";
		    	for (std::deque<table_element>::iterator vit = it->second.begin() ; vit != it->second.end(); ++vit) {
					vit->print();
					if (vit+1 != it->second.end())
						cout << ", ";
		    	}
			    std::cout << "]" << std::endl;
		    }
		}
};

#endif