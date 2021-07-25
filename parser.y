%error-verbose
%{
    #include<iostream>
    #include<stdlib.h>
    #include<string.h>
    #include <vector>
    #include "ast.h"
    #include "definitions.h"
    #include "symtable.h"
    #include "parser.tab.h"

    using namespace std;

    vector<Token> tokens;
    vector<Token> errors;
    vector<string> st_errors;
    vector<string> type_errors;

    #define YYDEBUG 1

    extern int yylex(void);
    extern int yylineno;
    extern int yyleng;
    extern int yycolumn;
    extern FILE* yyin;
    extern char* yytext;
    void redeclared_variable(string id, int line, int col);
    Type * checkIfDef(string id, int line, int col);
    void checkAsignType(Node * a, Node * b, int line, int col);
    Type * checkPlusType(Node * a, Node * b, string op, int line, int col);
    Type * checkAritType(Node * a, Node * b, string op, int line, int col);
    Type * checkBoolType(Node * a, Node * b, string op, int line, int col);
    Type * checkCompareType(Node * a, Node * b, int line, int col);
    Type * checkNumCompareType(Node * a, Node * b, int line, int col);
    Type * checkArrType(Node * a, Node * b, int line, int col);
    Type * checkMethod(string type_name, Node * a, string func, int line, int col);
    Type * checkFuncCall(Node * id, vector<Type*> args, int line, int col);
    bool checkReturnType(Type * f, Type * r, int line, int col);
    string getArgsList(vector<Type*> args);
    Program * root_ast;
    sym_table st;

    void yyerror(const char *s);
%}

%union {	
    int num; 
    bool boolean;
    char * str;
    char ch;
    float flot;
    Node * node;
    Program * program;
    Type * type;
}


%locations
%start Start

%left AND OR
%left LEQ GEQ LESS GREATER
%left EQUAL NQUAL
%left PLUS MINUS
%left POTEN MULT DIV INTDIV REST
%right NOT

%token BS 1 BSF 2 
%token DEVALUA 3 EFECTIVO 4
%token LETRA 5 
%token BETICAS 6 
%token OBLOCK 7 CBLOCK 8 
%token LABIA 9 QLQ 10 BUS 11 BULULU 12 POINTER 13
%token LEER 14 IMPRIMIR 15
%token SEMICOLON 23 ASIGN 24
%token PLUS 25 MINUS 26 MULT 27 POTEN 28 DIV 29 INTDIV 30 REST 31
%token LEQ 32 GEQ 33 LESS 34 GREATER 35 EQUAL 36 NQUAL 37 AND 38 OR 39 NOT 40
%token OPAR 41 CPAR 42 OBRACKET 43 CBRACKET 44
%token TAM 45 SITIO 46 METELE 47 SACALE 48 VOLTEA 49 
%token HASH 50
%token <boolean> ELDA 51 
%token <boolean> COBA 52 
%token COMMA 53
%token PORSIA 54 SINO 55 NIMODO 56 TANTEA 57 CASO 58
%token VACILA 59 IN 60 ACHANTA 61 SIGUELA 62
%token PEGAO 63 CHAMBA 64 RESCATA 65 
%token ERROR 67
%token <str> ID 66
%token <str> STRING 68
%token <ch> CHAR 69
%token <num> INT 70
%token <flot> FLOAT 71
%token METRO 72 METROBUS 73
%token NADA 74
%token POINT 75
%token DEREFERENCE 76
%type <node> Body DeclarationList Declaration Id Asignacion Literal Exp InstList Inst Lvalue Init ListAccesor Indexing ArrayIndexing List Array Seleccion Seleccion2 Casos Conversion ArrOp FuncDef ParamList FuncCall Args Repeticion 
%type <program> Program 
%type <type> Type ArrayType

%%
Start               : Program                                                       {root_ast = $1;}
                    | 
                    ;

Program             :  OScope Body CScope                                           {$$ = new Program($2);}
                    |  OBLOCK CBLOCK                                                {$$ = new Program(NULL);}
                    ;

OScope              : OBLOCK                                                        {st.new_scope();}

CScope              : CBLOCK                                                        {st.exit_scope()}

Body                : BETICAS DeclarationList InstList                                    {$$ = new Body($2, $3);$$->setType($3->type)}
                    | BETICAS DeclarationList                                             {$$ = new Body($2, NULL);}
                    | InstList                                                            {$$ = new Body(NULL, $1); $$->setType($1->type)}
                    ;

// Variables Declaration

DeclarationList     : DeclarationList SEMICOLON Declaration                         {$$ = new DeclarationList($1, $3);}
                    | Declaration                                                   {$$ = new DeclarationList(NULL, $1);} 
                    ;

Declaration         : Type Init                                                     {
                                                                                        Asign * asign = dynamic_cast<Asign*>($2);
                                                                                        Id * idNode =dynamic_cast<Id*>(asign->id); 
                                                                                        idNode->setType($1);
                                                                                        string id = idNode->id;
                                                                                        Node *exp = asign->exp;
                                                                                        if(!st.insert(id, "Variable", $1)){redeclared_variable(id, @$.first_line, @$.first_column);}; 
                                                                                        checkAsignType(idNode, exp, @$.first_line, @$.first_column);
                                                                                        $$ = new Declaration($2, NULL);
                                                                                        $$->setType($1)
                                                                                    }                                                                    
                    | BUS Id OScope DeclarationList CScope                          { 
                                                                                        string id = dynamic_cast<Id*>($2)->id; 
                                                                                        if(!st.insert(id, "Struct", NULL)){redeclared_variable(id, @$.first_line, @$.first_column);}; 
                                                                                        $$ = new Declaration($2, $4);
                                                                                    }
                    | BULULU Id OScope DeclarationList CScope                       {
                                                                                        string id = dynamic_cast<Id*>($2)->id; 
                                                                                        if(!st.insert(id, "Union", NULL)){redeclared_variable(id, @$.first_line, @$.first_column);}; 
                                                                                        $$ = new Declaration($2, $4);
                                                                                    }
                    | Type POINTER Id                                               {
                                                                                        if(!st.insert(dynamic_cast<Id*>($3)->id, "Variable", new PointerType($1))){redeclared_variable(dynamic_cast<Id*>($3)->id, @$.first_line, @$.first_column);};
                                                                                        $$ = new Declaration($3, NULL);
                                                                                    }
                    | Type POINTER Init                                             {
                                                                                        Asign * asign = dynamic_cast<Asign*>($3);
                                                                                        string id = dynamic_cast<Id*>(asign->id)->id;
                                                                                        if(!st.insert(id, "Variable", $1)){redeclared_variable(id, @$.first_line, @$.first_column);}; 
                                                                                        $$ = new Declaration($3, NULL);}
                    | Type Id                                                       {
                                                                                        Id *idNode = dynamic_cast<Id*>($2); 
                                                                                        string id = idNode->id;
                                                                                        idNode->setType($1);
                                                                                        if(!st.insert(id, "Variable", $1)){redeclared_variable(id, @$.first_line, @$.first_column);}; 
                                                                                        $$ = new Declaration($2, NULL);
                                                                                        $$->setType($1)
                                                                                    }
                    ;

Init                : Id ASIGN Exp                                          {$$ = new Asign($1, $3); }
                    ;

Asignacion          : Lvalue ASIGN Exp                                      {checkAsignType($1, $3, @$.first_line, @$.first_column);$$ = new Asign($1, $3);}
                    ;

Lvalue              : ListAccesor                                       {$$ = $1;}
                    | Indexing                                            {$$ = $1;}
                    ; 

ListAccesor         : ListAccesor POINT Id                              {$$ = new ListAccesor($1, $3);}
                    | ListAccesor POINT Indexing                        {$$ = new ListAccesor($1, $3);}
                    | Id                                                {
                                                                            string id = dynamic_cast<Id*>($1)->id; 
                                                                            Type * type = checkIfDef(id, @$.first_line, @$.first_column);
                                                                            $$ = new ListAccesor(NULL, $1);
                                                                            $$->setType(type)
                                                                        }
                    ; 

Indexing            : Id ArrayIndexing                                  {$$ = new Indexing($1, $2);}
                    ;

Id			        : ID										        {$$ = new Id($1);}
			        ;

ArrayIndexing	    : ArrayIndexing OBRACKET Exp CBRACKET  		        {$$ = new ListIndexing($1, $3)}
                    | OBRACKET Exp CBRACKET                             {$$ = new ListIndexing(NULL, $2)}
                    ;

Type                : BS                                                    {$$ = new Int();}
                    | BSF                                                   {$$ = new Float();}
                    | LABIA                                                 {$$ = new String();}
                    | LETRA                                                 {$$ = new Char();}                                                
                    | QLQ                                                   {$$ = new Bool();}
                    | ArrayType                                             {$$ = $1;}
                    ;

ArrayType           : METRO LESS Type OBRACKET INT CBRACKET GREATER                      {$$ = new ArrayType($5, $3)}
                    | METROBUS LESS Type GREATER                                         {$$ = new ListType($3);}
                    ;

// Literals

Literal             : INT                                                   {$$ = new LiteralInt($1); $$->setType(new Int())}                                                   
                    | FLOAT                                                 {$$ = new LiteralFloat($1); $$->setType(new Float())}
                    | CHAR                                                  {$$ = new LiteralChar($1); $$->setType(new Char())}
                    | STRING                                                {$$ = new LiteralStr($1); $$->setType(new String())}                                             
                    | ELDA                                                  {$$ = new LiteralBool("elda");$$->setType(new Bool())}
                    | COBA                                                  {$$ = new LiteralBool("coba");$$->setType(new Bool())}
                    | Array                                                 {$$ = new Array($1); $$->setType(new ArrayType($1->len, $1->type));}
                    ;

Array               : OBRACKET List CBRACKET                            {$$ = $2}
                    ;

List                : Exp                                               {$$ = new ArrayList(NULL, $1); $$->setType($1->type); $$->increment_size(0)}                                               
                    | List COMMA Exp                                    {$$ = new ArrayList($1, $3);$$->setType(checkArrType($1, $3, @$.first_line, @$.first_column)); $$->increment_size($1->len)}                                             
                    ;

Exp         : OPAR Exp CPAR                                                 {$$ = new Exp($2); $$->setType($2->type)}

            | Exp PLUS Exp                                                  {$$ = new BinaryExp($1, $3, "+"); $$->setType(checkPlusType($1, $3, "+", @$.first_line, @$.first_column))}
            | Exp MINUS Exp                                                 {$$ = new BinaryExp($1, $3, "-");$$->setType(checkAritType($1, $3, "-", @$.first_line, @$.first_column))}
            | Exp MULT Exp                                                  {$$ = new BinaryExp($1, $3, "*");$$->setType(checkAritType($1, $3, "*", @$.first_line, @$.first_column))}
            | Exp DIV Exp                                                   {$$ = new BinaryExp($1, $3, "/");$$->setType(checkAritType($1, $3, "/", @$.first_line, @$.first_column))}
            | Exp POTEN Exp                                                 {$$ = new BinaryExp($1, $3, "^");$$->setType(checkAritType($1, $3, "^", @$.first_line, @$.first_column))}
            | Exp INTDIV Exp                                                {$$ = new BinaryExp($1, $3, "//");$$->setType(checkAritType($1, $3, "//", @$.first_line, @$.first_column))}
            | Exp REST Exp                                                  {$$ = new BinaryExp($1, $3, "%");$$->setType(checkAritType($1, $3, "%", @$.first_line, @$.first_column))}

            | Exp AND Exp                                                   {$$ = new BinaryExp($1, $3, "&&");$$->setType(checkBoolType($1, $3, "&&", @$.first_line, @$.first_column))}
            | Exp OR Exp                                                    {$$ = new BinaryExp($1, $3, "||");$$->setType(checkBoolType($1, $3, "&&", @$.first_line, @$.first_column))}
            | NOT Exp                                                       {$$ = new Unary($2, "!")}
            | MINUS Exp                                                     {$$ = new Unary($2, "-")}
            | DEREFERENCE Id                                                {$$ = new Unary($2, "&")}

            | Exp EQUAL Exp                                                 {$$ = new BinaryExp($1, $3, "==");$$->setType(checkCompareType($1, $3, @$.first_line, @$.first_column))}
            | Exp NQUAL Exp                                                 {$$ = new BinaryExp($1, $3, "!=");$$->setType(checkCompareType($1, $3, @$.first_line, @$.first_column))}
            | Exp GEQ Exp                                                   {$$ = new BinaryExp($1, $3, ">=");$$->setType(checkNumCompareType($1, $3, @$.first_line, @$.first_column))}
            | Exp LEQ Exp                                                   {$$ = new BinaryExp($1, $3, "<=");$$->setType(checkNumCompareType($1, $3, @$.first_line, @$.first_column))}
            | Exp GREATER Exp                                               {$$ = new BinaryExp($1, $3, ">");$$->setType(checkNumCompareType($1, $3, @$.first_line, @$.first_column))}
            | Exp LESS Exp                                                  {$$ = new BinaryExp($1, $3, "<");$$->setType(checkNumCompareType($1, $3, @$.first_line, @$.first_column))}
        
            | ArrOp                                                         {$$ = $1}
            | Conversion                                                    {$$ = $1}
            | Literal                                                       {$$ = $1;}                                                          
            | FuncCall                                                      {$$ = $1}
            | Lvalue                                                        {$$ = $1}
            ;

InstList    : InstList SEMICOLON Inst                                       {$$ = new InstList($1, $3);if(!$1->type){$$->setType($3->type);}else{$$->setType($1->type);}}
            | Inst                                                          {$$ = new InstList(NULL, $1); $$->setType($1->type)}

Inst        : Conversion                                                        {$$ = $1;}
            | Seleccion                                                         {$$ = $1;}
            | Repeticion                                                        {$$ = $1;}
            | FuncDef                                                           {$$ = $1;}
            | FuncCall                                                          {$$ = $1;}
            | Asignacion                                                        {$$ = $1;}
            | ArrOp                                                             {$$ = $1;}
            | IMPRIMIR OPAR Exp CPAR                                            {$$ = new Io($3,"Imprimir");}
            | LEER OPAR Id CPAR                                                 {$$ = new Io($3, "Leer");}
            | RESCATA Exp                                                       {$$ = new Rescata($2); $$->setType($2->type)}
            | Program                                                           {$$ = $1;}
            ;

Conversion  : EFECTIVO OPAR Exp CPAR                                   {$$ = new EmbededFunc("Efectivo", $3)}
            | DEVALUA OPAR Exp CPAR                                    {$$ = new EmbededFunc("Devalua", $3)}
            ;

Seleccion   : PORSIA OPAR Exp CPAR Program Seleccion2                       {$$ = new Seleccion($3,$5,$6,"Porsia")}
            | TANTEA OPar Type Id CPAR OBLOCK Casos CBLOCK                  {
                                                                                string id = dynamic_cast<Id*>($4)->id; 
                                                                                if(!st.insert(id, "Variable", $3)){redeclared_variable(id, @$.first_line, @$.first_column);}; 
                                                                                $$ = new Tantea($4, $7);
                                                                                st.exit_scope()
                                                                            }
            ;

Seleccion2  : SINO OPAR Exp CPAR Program  Seleccion2                          {$$ = new Seleccion( $3, $5, $6, "Sino")}
            | NIMODO Program                                                  {$$ = new Seleccion(NULL, $2, NULL, "Nimodo")}
            |                                                                 {$$ = NULL;}
            ;

Casos       : Casos CASO OPAR Exp CPAR Program                                {$$ = new Caso($1, $4, $6);}
            | CASO OPAR Exp CPAR Program                                      {$$ = new Caso(NULL, $3, $5);}
            ;

Repeticion  : VACILA OPar Declaration SEMICOLON Exp SEMICOLON Exp CPAR OBLOCK Body CScope       {$$ = new Repeticion($3, $5, $7, NULL, $10);}
            | VACILA OPar Type Id IN Exp CPAR OBLOCK Body CBLOCK                                     {
                                                                                                    string id = dynamic_cast<Id*>($4)->id; 
                                                                                                    if(!st.insert(id, "Iterator", NULL)){redeclared_variable(id, @$.first_line, @$.first_column);}; 
                                                                                                    $$ = new Repeticion(NULL, $6, NULL, $4, $9);
                                                                                                    st.exit_scope()
                                                                                                }  
            | PEGAO OPAR Exp CPAR Program                                          {$$ = new Repeticion2($3, $5);} 
            ;

ArrOp       : SITIO OPAR Exp CPAR                                          {$$ = new EmbededFunc("Sitio", $3)}
            | METELE OPAR Exp CPAR                                         {$$ = new EmbededFunc("Metele", $3)}
            | SACALE OPAR Exp CPAR                                         {$$ = new EmbededFunc("Sacale", $3)}
            | VOLTEA OPAR Exp CPAR                                         {$$ = new EmbededFunc("Voltea", $3)}
            ;

// // Sobre las funciones

FuncCall    : Id OPAR Args CPAR                                                  {$$ = new FunCall($1,$3); if(!$3){$$->setType(checkFuncCall($1, {}, @$.first_line, @$.first_column));}else{$$->setType(checkFuncCall($1, $3->args, @$.first_line, @$.first_column));}}
            ;

Args        : Args COMMA Exp                                                {$$ = new Params($1, $3);$$->add_arg($1->args, $3->type);}
            | Exp                                                           {$$ = new Params(NULL, $1);$$->add_arg({}, $1->type);}
            |                                                               {$$ = NULL;}
            ;
            

FuncDef     : CHAMBA Type Id OPar ParamList CPAR OBLOCK Body CScope             {
                                                                                    string id = dynamic_cast<Id*>($3)->id; 
                                                                                    extra_info_func * ef; 
                                                                                    if(!$5){                                                                                            
                                                                                        ef=new extra_info_func(0,{},false);
                                                                                    }else{
                                                                                        ef=new extra_info_func($5->args.size(), $5->args, false);
                                                                                    }
                                                                                    if(!st.insert(id, "func", $2, ef)){redeclared_variable(id, @$.first_line, @$.first_column);}; 
                                                                                    checkReturnType($2, $8->type, @$.first_line, @$.first_column);
                                                                                    $$ = new Chamba($3, $5, $8);
                                                                                }
            | CHAMBA NADA Id OPAR ParamList CPAR Program                {

                                                                            string id = dynamic_cast<Id*>($3)->id; 
                                                                            if(!st.insert(id, "Proc", new Void())){redeclared_variable(id, @$.first_line, @$.first_column);}; 
                                                                            $$ = new Chamba($3, $5, $7)
                                                                        }
            ;
            
OPar        : OPAR                                                      {st.new_scope()}
            
ParamList   : ParamList COMMA Declaration                                   {$$ = new Params($1, $3);$$->add_arg($1->args, $3->type);}
            | Declaration                                                   {$$ = new Params(NULL, $1);$$->add_arg({}, $1->type);}
            |                                                               {$$ = NULL}
            ;

%%

// void imprimir_tabla(){
// 	if (!error_sintactico){
// 		table.print();
// 	}
// }

void yyerror (char const *s) {
    cout << "Sintax Error, unexpected: " << yytext << " in row " << yylineno << ", column " << yycolumn-strlen(yytext) << ".\n"; 
    // fprintf (stderr, "%s%s\n", s);
}

void redeclared_variable(string id, int line, int col){
    string error = "Error: redeclared variable " + id + " at line " + to_string(line) + ", column " + to_string(col) + ".\n";
    st_errors.push_back(error);
}

Type * checkIfDef(string id, int line, int col){
    table_element * symbol = st.lookup(id);
    if(!symbol){
        string error = "Error: variable " + id + " at line " + to_string(line) + ", column " + to_string(col) + ", has not been declared."+ "\n";
        st_errors.push_back(error);
        return new Type_Error();
    }
    return symbol->type;
}

void checkAsignType(Node * a, Node * b, int line, int col){
    string nameA = a->type->get_name();
    string nameB = b->type->get_name();
    if(nameA != nameB){
        if(nameA != "type_error" && nameB != "type_error"){
            string error = "TypeError: cannot asign variable of type '" + nameB + "' to variable of type '" + nameA + "'" + " at line "+ to_string(line) + ", column " + to_string(col) + "\n";
            st_errors.push_back(error);
            return;
        }
    }
}

Type * checkPlusType(Node * a, Node * b, string op, int line, int col){
    string nameA = a->type->name;
    string nameB = b->type->name;
    string error = "TypeError: cannot use operator '"+ op + "' with types '" + nameA + "' and '" + nameB + "'" + " at line "+ to_string(line) + ", column " + to_string(col) + "\n";
    if(nameA == "type_error" || nameB == "type_error"){
        return new Type_Error();
    }
    if(!(nameA == "int" || nameA == "float" || nameA == "char" || nameA == "str")){
        st_errors.push_back(error);
        return new Type_Error();
    }
    if(!(nameB == "int" || nameB == "float" || nameB == "char" || nameB == "str")){
        st_errors.push_back(error);
        return new Type_Error();
    }
    if((nameA == "char" && nameB =="str") ||(nameB == "char" && nameA == "str")){
        return new String();
    }
    if((nameA == "int" && nameB == "float") ||(nameA == "float" && nameB == "int") ){
        return new Float();
    }
    return a->type;
}

Type * checkArrType(Node * a, Node * b, int line, int col){
    string nameA = a->type->get_name();
    string nameB = b->type->get_name();
    string error = "TypeError: some elements in array has diferents types at line "+ to_string(line) + ", column " + to_string(col) + "\n";
    if(nameA == "type_error" || nameB == "type_error"){
        return new Type_Error();
    }
    if(nameA != nameB){
        st_errors.push_back(error);
        return new Type_Error();
    }
    return a->type;

}

Type * checkAritType(Node * a, Node * b, string op, int line, int col){
    string nameA = a->type->name;
    string nameB = b->type->name;
    string error = "TypeError: cannot use operator '"+ op + "' with types '" + nameA + "' and '" + nameB + "'" + " at line "+ to_string(line) + ", column " + to_string(col) + "\n";
    if(nameA == "type_error" || nameB == "type_error"){
        return new Type_Error();
    }
    if((nameA == "int" || nameA == "float") && (nameB == "float" || nameB == "int")){
        if(op == "//"){
            return new Int();
        }
        if(nameA == "float" || nameB == "float"){
            return new Float();
        }
        return a->type; 
    }
    st_errors.push_back(error);
    return new Type_Error();
}

Type * checkBoolType(Node * a, Node * b, string op, int line, int col){
    string nameA = a->type->name;
    string nameB = b->type->name;
    string error = "TypeError: cannot use operator '"+ op + "' with types '" + nameA + "' and '" + nameB + "'" + " at line "+ to_string(line) + ", column " + to_string(col) + "\n";
    if(nameA == "type_error" || nameB == "type_error"){
        return new Type_Error();
    }
    if(nameA != "bool" || nameB != "bool"){
        st_errors.push_back(error);
        return new Type_Error();
    }
    return a->type;
}

Type * checkArrMethod(Node * a, string func, Type * return_type, int line, int col){
    string nameA = a->type->name;
    if(nameA == "type_error"){
        return a->type;
    }
    if(nameA != "array" || nameA != "list"){

        string error = "TypeError:  '"+ func + "' takes one argument of type 'list' or 'array''" + nameA + "' but recives'" + nameA + "'" + " at line "+ to_string(line) + ", column " + to_string(col) + "\n";
        st_errors.push_back(error);
    }
    return new Int();

}

Type * checkCompareType(Node * a, Node * b, int line, int col){
    string nameA = a->type->name;
    string nameB = b->type->name;
    string error = "TypeError: forbids comparison between '" + nameA + "' and '" + nameB + "'" + " at line "+ to_string(line) + ", column " + to_string(col) + "\n";
    if(nameA == "type_error" || nameB == "type_error"){
        return new Type_Error();
    }
    if(nameA != nameB){
        st_errors.push_back(error);
        return new Type_Error();
    }
    return new Bool();
}
Type * checkNumCompareType(Node * a, Node * b, int line, int col){
    string nameA = a->type->name;
    string nameB = b->type->name;
    string error = "TypeError: forbids comparison between '" + nameA + "' and '" + nameB + "'" + " at line "+ to_string(line) + ", column " + to_string(col) + "\n";
    if(nameA == "type_error" || nameB == "type_error"){
        return new Type_Error();
    }
    if((nameA == "int" || nameA == "float") && (nameB == "float" || nameB == "int")){
        if(nameA == nameB){
            return new Bool();
        }
    }
    st_errors.push_back(error);
    return new Type_Error();
}
Type * checkFuncCall(Node * id, vector<Type*> args, int line, int col){
    string id_name = dynamic_cast<Id*>(id)->id;
    Type * return_type = checkIfDef(id_name, line, col);
    if(return_type->name == "type_error"){
        return return_type;
    }
    table_element * symbol = st.lookup(id_name);
    extra_info_func * ef = dynamic_cast<extra_info_func*>(symbol->ef);
    if(symbol->category != "func"){
        string error = "Error: " + id_name + " is not a function, at line "+ to_string(line) + ", column " + to_string(col) + "\n";
        st_errors.push_back(error);
        return new Type_Error();
    }
    if(ef->numArgs != args.size()){
        string error = "Error: " + id_name + " takes " + to_string(ef->numArgs) + " arguments but received " + to_string(args.size()) + " at line "+ to_string(line) + ", column " + to_string(col) + "\n";
        st_errors.push_back(error);
        return new Type_Error();
    }

    for(int i=0; i < args.size(); i++){
        if(ef->isGeneric){
            string argType = args[i]->get_simple_type();
            cout << argType <<endl;
            if(argType != "list" && argType != "array"){
                string error = "Error: no matching function for call to " + id_name + getArgsList(args);
                st_errors.push_back(error);
                return new Type_Error();
            }
        }else{
            if(ef->args_types[i]->get_name() != args[i]->get_name()){
                string error = "Error: no matching function for call to " + id_name + getArgsList(args);
                st_errors.push_back(error);
                return new Type_Error();
            }
        }
    }

    return return_type;

}

bool checkReturnType(Type * a, Type * r, int line, int col){
    string nameR = r->get_name();
    string nameA = a->get_name();
    if(nameR == "type_error"){
        return false;
    }
    if(nameA != "int" && nameA != "str" && nameA != "char" && nameA != "bool" && nameA != "float"){
        string error = "TypeError: invalid return type at line "+ to_string(line) + ", column " + to_string(col) + "\n";
        st_errors.push_back(error);
        return false;
    }

    if(nameR != nameA){
        string error = "TypeError: return type does not match with func type at line "+ to_string(line) + ", column " + to_string(col) + "\n";
        st_errors.push_back(error);
        return false;
    }
    return true;
}

string getArgsList(vector<Type*> args){
    string s = "(";
    for(int i=0; i < args.size(); i++ ){
        if(i == args.size() - 1){
            s += args[i]->get_name();
        }else{

            s += args[i]->get_name() + ", ";
        }
    }
    s += ")";
    return s;
}
void run_lexer(){
    cout << "executing lexer" << endl << endl;
    int ntoken;
    ntoken = yylex();
    int column = 1;
    int row = yylineno;
    bool isComment = false;
    
    while(ntoken) {
        if(row != yylineno){
            row = yylineno;
            isComment = false;
        }

        if(nTokens[ntoken] != "ws" && !isComment){
            if(ntoken == ERROR){
                errors.push_back(Token(yytext, nTokens[ntoken], yylineno, yylloc.first_column));
            }
            else{
                tokens.push_back(Token(yytext, nTokens[ntoken], yylineno, yylloc.first_column));
            }
        }

        if(ntoken == HASH){
            isComment = true;
        }
        
        ntoken = yylex();

    }
    if(errors.size() > 0){
        for(int i = 0; i < errors.size(); i++){
            cout << errors[i].to_str();
        }
    }else {
        for(int i = 0; i < tokens.size(); i++){
            
            cout << tokens[i].to_str();
        }
    }
}

void run_parser(){
	cout << "Ejecutando parser" << endl << endl;
    
    try {
		yyparse();
	}
	catch(const char* const errorMessage){
		cout << "Error: " << endl;
			cout << errorMessage << endl;
	}
	
    // cout << root_ast->to_s(0,0) << endl;
    if(st_errors.size() > 0){
        for(int i = 0; i <st_errors.size(); i++){
            cout << st_errors[i];
        }
    }else{

        st.print();
    }
    // cout << st.print() << endl;
	// Si hay errores del lexer, imprimirlos
    
    // imprimir_tabla();
}

int main(int argc, char *argv[]){
    init_tokens_definitions();
    string filePath = argv[1];
    yyin = fopen(argv[1], "r");
    if (yyin == false){
    	cout << "Error de lectura, revise el archivo " << argv[1] << endl;
    	return 0;
    }

    if (argc > 2){
		for (int i = 2; i < argc; i++ ){
			string arg(argv[i]);
			if (arg == "-l"){
				run_lexer();
			}
			else if (arg == "-p"){
				run_parser();
			}
		}
	} else {
		// por defecto ejecuta el parser
		run_parser();
	}

    return 0;
}

