/*Alicia Benítez Rogero, Álvaro Molina García*/
%{
// SECCION 1 Declaraciones de C-Yacc

#include <stdio.h>
#include <ctype.h>            // declaraciones para tolower
#include <string.h>           // declaraciones para code
#include <stdlib.h>           // declaraciones para exit ()

#define FF fflush(stdout);    // para forzar la impresion inmediata

int yylex () ;
void yyerror () ;
char *my_malloc (int) ;
char *gen_code (char *) ;
char *int_to_string (int) ;
char *char_to_string (char) ;

char temp [2048] ;
char nombre_funcion [100] ;

// Definitions for explicit attributes

typedef struct s_attr {
        int value ;
        int type ;
        char *code ;
} t_attr ;

#define YYSTYPE t_attr
#define LOGIC 0
#define ARITMETIC 1

%}

// Definitions for explicit attributes

%token NUMBER        
%token IDENTIF       // Identificador=variable
%token INTEGER       // identifica el tipo entero
%token STRING
%token MAIN          // identifica el comienzo del proc. main
%token WHILE         // identifica el bucle main
%token PUTS
%token PRINTF
%token WHILELOOP
%token OR
%token AND
%token EQUAL
%token GREATEQUAL
%token LESSEQUAL
%token NOTEQUAL
%token IF
%token ELSE
%token FORLOOP
%token RETURN

// Definitions for implicit attributes.
// USE THESE ONLY AT YOUR OWN RISK
/*

%union {                      // El tipo de la pila tiene caracter dual
    int value ;             // - valor numerico de un NUMERO
    char *code ;          // - para pasar los nombres de IDENTIFES
}

%token <value> NUMBER       // Todos los token tienen un tipo para la pila
%token <code> IDENTIF       // Identificador=variable
%token <code> INTEGER       // identifica la definicion de un entero
%token <code> STRING
%token <code> MAIN          // identifica el comienzo del proc. main
%token <code> WHILE         // identifica el bucle main
%token <code> PUTS            // identifica la funcion puts
%token <code> PRINTF            // identifica la funcion printf
%token <code> WHILELOOP
%token <code> EQUAL         // condicion ==
%token <code> OR    // condicion ||
%token <code> AND    // condicion &&
%token <code> NOTEQUAL // condicion !=
%token <code> GREATEQUAL // condicion >=
%token <code> LESSEQUAL // condicion <=
%token <code> IF        // condicion if
%token <code> ELSE        // condicion else
%token <code> FORLOOP        // condicion for
%token <code> RETURN        // condicion return





%type <...> Axiom ...

*/

%right OR
%left AND
%left EQUAL
%left '<' '>' LESSEQUAL GREATEQUAL NOTEQUAL '%'

%right '='                     // es la ultima operacion que se debe realizar
%left '+' '-'                 // menor orden de precedencia
%left '*' '/'                 // orden de precedencia intermedio
%left UNARY_SIGN              // mayor orden de precedencia


%%                            // Seccion 3 Gramatica - Semantico

axioma:             decl_variables                  {printf("%s ", $1.code);}

                    decl_funciones                  {printf("%s ", $3.code);}

                    programa                        {printf("%s", $5.code) ;}
            ;

decl_variables:     variable ';' decl_variables     {sprintf(temp, "%s %s", $1.code, $3.code);
                                                    $$.code = gen_code(temp);}
            |                                       { $$.code = "" ; }
            ;

decl_funciones:     funcion  decl_funciones     {sprintf(temp, "%s %s", $1.code, $2.code);
                                                    $$.code = gen_code(temp);}
            |                                       { $$.code = "" ; }
            ;

funcion:            IDENTIF                                 {sprintf(nombre_funcion, "%s", $1.code);}
                    '(' params ')' '{' codigo_funcion '}'   {sprintf(temp, "(defun %s (%s) %s)", $1.code, $4.code, $7.code);
                                                            $$.code = gen_code(temp);}
            ;
params:             INTEGER IDENTIF                 {sprintf(temp, "%s", $2.code);
                                                    $$.code = gen_code(temp);}

            |       INTEGER IDENTIF ',' params      {sprintf(temp, "%s %s", $2.code, $4.code);
                                                    $$.code = gen_code(temp);}

            |                                       {$$.code = "";}
            ; 

programa:       MAIN                                {sprintf(nombre_funcion, "%s", $1.code);}

                '(' ')' '{' codigo_funcion'}'       {sprintf(temp, "(defun main () %s)",$6.code);
                                                    $$.code = gen_code(temp);}
            ;
lines:          sentencia ';'                                                   {sprintf(temp, "%s", $1.code);
                                                                            $$.code = gen_code(temp);}

            |   WHILELOOP '(' expresion ')' '{' codigo_bucle  '}'       {if ($3.type != 0) {
                                                                            sprintf(temp, "(if (/= %s 0) 1 0)", $3.code);
                                                                            $3.code = gen_code(temp);
                                                                        }
                                                                        sprintf(temp, "(loop while %s do %s) ",$3.code, $6.code);
                                                                        $$.code = gen_code(temp);}

            |   FORLOOP '(' declaracion ';' expresion ';' sentencia ')' '{' codigo_bucle  '}'       {if ($5.type != 0) {
                                                                                                        sprintf(temp, "(if (/= %s 0) 1 0)", $5.code);
                                                                                                        $5.code = gen_code(temp);
                                                                                                    }
                                                                                                    sprintf(temp, "(let (%s) (loop while %s do %s %s))",$3.code, $5.code, $10.code, $7.code);
                                                                                                    $$.code = gen_code(temp);}

            |   FORLOOP '(' INTEGER declaracion ';' expresion ';' sentencia ')' '{' codigo_bucle  '}'   {if ($6.type != 0) {
                                                                                                            sprintf(temp, "(if (/= %s 0) 1 0)", $6.code);
                                                                                                            $6.code = gen_code(temp);
                                                                                                        }
                                                                                                        sprintf(temp, "(let (%s) (loop while %s do %s %s))",$4.code, $6.code, $11.code, $8.code);
                                                                                                        $$.code = gen_code(temp);}

            |   IF '(' expresion ')' '{' codigo_if  '}'     {if ($3.type != 0) {
                                                                sprintf(temp, "(if (/= %s 0) 1 0)", $3.code);
                                                                $3.code = gen_code(temp);
                                                            }
                                                            sprintf(temp, "(if %s (progn %s))",$3.code, $6.code);
                                                            $$.code = gen_code(temp);}

            |   IF '(' expresion ')' '{' codigo_if  '}' ELSE '{' codigo_if  '}'     {if ($3.type != 0) {
                                                                                        sprintf(temp, "(if (/= %s 0) 1 0)", $3.code);
                                                                                        $3.code = gen_code(temp);
                                                                                    }
                                                                                    sprintf(temp, "(if %s (progn %s) (progn %s))",$3.code, $6.code, $10.code);
                                                                                    $$.code = gen_code(temp);}

            |   RETURN argumentos ';'         {if (strstr($2.code, ", ") == NULL)
                                                sprintf(temp, "(return-from %s (values %s))", nombre_funcion, $2.code);
                                            else
                                                sprintf(temp, "(return-from %s %s)", nombre_funcion, $2.code);
                                            $$.code = gen_code(temp);}

            |   '{' codigo_funcion '}'        {sprintf(temp, "%s",$2.code);
                                            $$.code = gen_code(temp);}  
            ;

codigo_funcion: lines codigo_funcion        {sprintf(temp, "%s %s", $1.code, $2.code);
                                            $$.code = gen_code(temp);}

            |   lines                       {sprintf(temp, "%s", $1.code);
                                            $$.code = gen_code(temp);}

            |   INTEGER declaracion ';'     {sprintf(temp, "(let (%s))", $2.code) ;
                                            $$.code = gen_code(temp);}

            |   INTEGER declaracion ';' codigo_funcion          {sprintf(temp, "(let (%s) %s)", $2.code, $4.code) ;
                                                                $$.code = gen_code(temp);}

            |   PRINTF '(' print ')' ';'    { $$ = $3 ; }


            |   PRINTF '(' print ')' ';' codigo_funcion         {sprintf(temp, "%s %s", $3.code, $6.code);
                                                                $$.code = gen_code(temp); }

            |   RETURN argumentos           {if (strstr($2.code, ", ") == NULL)
                                                sprintf(temp, "(return-from %s (values %s))", nombre_funcion, $2.code);
                                            else
                                                sprintf(temp, "%s", $2.code);
                                            $$.code = gen_code(temp);}
            ;

codigo_bucle:   lines codigo_bucle          {sprintf(temp, "%s %s", $1.code, $2.code);
                                            $$.code = gen_code(temp);}

            |   lines                       {sprintf(temp, "%s", $1.code);
                                            $$.code = gen_code(temp);}

            |   INTEGER declaracion ';'     {sprintf(temp, "(let (%s))", $2.code) ;
                                            $$.code = gen_code(temp);}

            |   INTEGER declaracion ';' codigo_funcion  {sprintf(temp, "(let (%s) %s)", $2.code, $4.code) ;
                                                        $$.code = gen_code(temp);}

            |   PRINTF '(' print ')' ';'    { $$ = $3 ; }

            |   PRINTF '(' print ')' ';' codigo_bucle   {sprintf(temp, "%s %s", $3.code, $6.code);
                                                        $$.code = gen_code(temp); }
                                                        
            |   RETURN argumentos           {if (strstr($2.code, ", ") == NULL)
                                                sprintf(temp, "(return-from %s (values %s))", nombre_funcion, $2.code);
                                            else
                                                sprintf(temp, "(return-from %s %s)", nombre_funcion, $2.code);
                                            $$.code = gen_code(temp);}
            ;

codigo_if:      lines codigo_if             {sprintf(temp, "(progn %s %s)", $1.code, $2.code);
                                            $$.code = gen_code(temp);}

            |   lines                       {sprintf(temp, "%s", $1.code);
                                            $$.code = gen_code(temp);}

            |   PRINTF '(' print ')' ';'    { $$ = $3;}

            |   PRINTF '(' print ')' ';' codigo_if      {sprintf(temp, "%s %s", $3.code, $6.code);
                                                        $$.code = gen_code(temp); }

            |   INTEGER declaracion ';'     {sprintf(temp, "(let (%s))", $2.code) ;
                                            $$.code = gen_code(temp);}

            |   INTEGER declaracion ';' codigo_funcion  {sprintf(temp, "(let (%s) %s)", $2.code, $4.code) ;
                                                        $$.code = gen_code(temp);}

            |   RETURN argumentos           {if (strstr($2.code, ", ") == NULL)
                                                sprintf(temp, "(return-from %s (values %s))", nombre_funcion, $2.code);
                                            else
                                                sprintf(temp, "(return-from %s %s)", nombre_funcion, $2.code);
                                          $$.code = gen_code(temp);}
            ;


variable:     INTEGER IDENTIF              { sprintf(temp, "(setq %s 0)", $2.code);
                                           $$.code = gen_code(temp); }

            | INTEGER IDENTIF '[' termino ']'   {sprintf(temp, "(setq %s (make-array %s))", $2.code, $4.code);
                                                $$.code = gen_code(temp); }
                                                
sentencia:    IDENTIF '=' expresion         {sprintf(temp, "(setq %s %s)", $1.code, $3.code) ; 
                                            $$.code = gen_code (temp) ; }

            | IDENTIF '[' expresion ']' '=' expresion       {sprintf(temp, "(setf (aref %s %s) %s)", $1.code, $3.code, $6.code) ; 
                                                            $$.code = gen_code (temp) ; }
                                                            
            | PUTS '(' STRING ')'           {sprintf(temp, "(print \"%s\")", $3.code) ; 
                                            $$.code = gen_code (temp) ; }

            | INTEGER IDENTIF '[' expresion ']'         {sprintf(temp, "(setq %s (make-array %s))", $2.code, $4.code);
                                                        $$.code = gen_code(temp); }

            | IDENTIF '(' argumentos ')'    {sprintf(temp, "(%s %s)", $1.code, $3.code);
                                            $$.code = gen_code(temp); }

            | expresion ',' argumentos '=' expresion ',' argumentos     {sprintf(temp, "(setf (values %s %s) (values %s %s))", $1.code, $3.code, $5.code, $7.code);
                                                                        $$.code = gen_code(temp); }

            | expresion ',' argumentos '=' expresion        {sprintf(temp, "(setf (values %s %s) %s)", $1.code, $3.code, $5.code);
                                                            $$.code = gen_code(temp); }

            | IDENTIF '=' expresion ',' definicion         {sprintf(temp, "(setq %s %s) %s", $1.code, $3.code, $5.code);
                                                            $$.code = gen_code(temp); }

            | IDENTIF '[' expresion ']' '=' expresion ',' definicion   {sprintf(temp, "(setf (aref %s %s) %s) %s", $1.code, $3.code, $6.code, $8.code);
                                                                        $$.code = gen_code(temp); }
            ;

argumentos: expresion ',' argumentos        {sprintf(temp, "%s %s", $1.code, $3.code);
                                            $$.code = gen_code(temp);}

            |  expresion                    {sprintf(temp, "%s", $1.code);
                                            $$.code = gen_code(temp);}

            |                               {$$.code = gen_code("");}
            ;

declaracion:  IDENTIF '=' expresion         {sprintf(temp, "(%s %s)", $1.code, $3.code) ; 
                                            $$.code = gen_code (temp) ;}
               
            | IDENTIF                       {sprintf(temp, "(%s 0)", $1.code);
                                            $$.code = gen_code(temp);}

            | IDENTIF ',' declaracion       {sprintf(temp, "(%s 0) %s", $1.code, $3.code) ; 
                                            $$.code = gen_code (temp) ;}

            | IDENTIF '=' expresion ',' declaracion     {sprintf(temp, "(%s %s) %s", $1.code, $3.code, $5.code) ; 
                                                        $$.code = gen_code (temp) ;}

            | IDENTIF '[' expresion ']' '=' expresion   {sprintf(temp, "((aref %s %s) %s)", $1.code, $3.code, $6.code) ; 
                                                        $$.code = gen_code (temp) ;}

            | IDENTIF '[' expresion ']' '=' expresion declaracion       {sprintf(temp, "((aref %s %s) %s) %s", $1.code, $3.code, $6.code, $7.code) ; 
                                                                        $$.code = gen_code (temp) ;}
            ;

definicion:  IDENTIF '=' expresion         {sprintf(temp, "(setq %s %s)", $1.code, $3.code) ; 
                                            $$.code = gen_code (temp) ;}
               
            | IDENTIF                       {sprintf(temp, "(setq %s 0)", $1.code);
                                            $$.code = gen_code(temp);}

            | IDENTIF ',' definicion       {sprintf(temp, "(setq %s 0) %s", $1.code, $3.code) ; 
                                            $$.code = gen_code (temp) ;}

            | IDENTIF '=' expresion ',' definicion     {sprintf(temp, "(setq %s %s) %s", $1.code, $3.code, $5.code) ; 
                                                        $$.code = gen_code (temp) ;}

            | IDENTIF '[' expresion ']' '=' expresion   {sprintf(temp, "(setq (aref %s %s) %s)", $1.code, $3.code, $6.code) ; 
                                                        $$.code = gen_code (temp) ;}

            | IDENTIF '[' expresion ']' '=' expresion definicion       {sprintf(temp, "(setq (aref %s %s) %s) %s", $1.code, $3.code, $6.code, $7.code) ; 
                                                                        $$.code = gen_code (temp) ;}
            ;

print:        expresion  ',' print          {sprintf(temp, "(print %s) %s", $1.code, $3.code);
                                            $$.code = gen_code(temp);}

            |   STRING ',' print            { sprintf(temp, "%s", $3.code);
                                            $$.code = gen_code(temp);}

            |   expresion                   {sprintf(temp, "(print %s)", $1.code);
                                            $$.code = gen_code(temp); }

            |   STRING                      {$$.code = ""; }

            ;



expresion:      termino                     {$$ = $1 ; }

            |   expresion '+' expresion     {$$.type = 1;
                                            if ($1.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                $1.code = gen_code(temp);}
                                            if ($3.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $3.code);
                                                $3.code = gen_code(temp);
                                            }
                                            sprintf(temp, "(+ %s %s)", $1.code, $3.code);
                                            $$.code = gen_code (temp) ; }

            |   expresion '-' expresion     {$$.type = 1;
                                            if ($1.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                $1.code = gen_code(temp);}
                                            if ($3.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $3.code);
                                                $3.code = gen_code(temp);
                                            }
                                            sprintf(temp, "(- %s %s)", $1.code, $3.code);
                                            $$.code = gen_code (temp) ; }

            |   expresion '*' expresion     {$$.type = 1;
                                            if ($1.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                $1.code = gen_code(temp);}
                                            if ($3.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $3.code);
                                                $3.code = gen_code(temp);
                                            }
                                            sprintf(temp, "(* %s %s)", $1.code, $3.code);
                                            $$.code = gen_code (temp) ; }

            |   expresion '/' expresion     {$$.type = 1;
                                            if ($1.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                $1.code = gen_code(temp);}
                                            if ($3.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $3.code);
                                                $3.code = gen_code(temp);
                                            }
                                            sprintf(temp, "(/ %s %s)", $1.code, $3.code);
                                            $$.code = gen_code (temp) ; }

            |   expresion '%' expresion     {$$.type = 1;
                                            if ($1.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                $1.code = gen_code(temp);}
                                            if ($3.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $3.code);
                                                $3.code = gen_code(temp);
                                            }
                                            sprintf(temp, "(mod %s %s)", $1.code, $3.code);
                                            $$.code = gen_code (temp) ; }

            |   expresion '<' expresion     {$$.type = 0;
                                            if ($1.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                $1.code = gen_code(temp);}
                                            if ($3.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $3.code);
                                                $3.code = gen_code(temp);
                                            }
                                            sprintf(temp, "(< %s %s)", $1.code, $3.code);
                                            $$.code = gen_code (temp) ; }

            |   expresion '>' expresion      {$$.type = 0;
                                            if ($1.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                $1.code = gen_code(temp);}
                                            if ($3.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $3.code);
                                                $3.code = gen_code(temp);
                                            }
                                            sprintf(temp, "(> %s %s)", $1.code, $3.code);
                                            $$.code = gen_code (temp) ; }

            |   expresion EQUAL expresion   {$$.type = 0;
                                            if ($1.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                $1.code = gen_code(temp);}
                                            if ($3.type != 1) {
                                                sprintf(temp, "(if %s 1 0)", $3.code);
                                                $3.code = gen_code(temp);
                                            }
                                            sprintf(temp, "(= %s %s)", $1.code, $3.code);
                                            $$.code = gen_code (temp) ; }

            |   expresion NOTEQUAL expresion    {$$.type = 0;
                                                if ($1.type == 1 && $3.type == 0) {
                                                    sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                    $1.code = gen_code(temp);}
                                                if ($1.type == 0 && $3.type == 1) {
                                                    sprintf(temp, "(if %s 1 0)", $3.code);
                                                    $3.code = gen_code(temp);
                                                }
                                                sprintf(temp, "(/= %s %s)", $1.code, $3.code);
                                                $$.code = gen_code (temp) ; }

            |   expresion GREATEQUAL expresion      {$$.type = 0;
                                                    if ($1.type != 1) {
                                                        sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                        $1.code = gen_code(temp);}
                                                    if ($3.type != 1) {
                                                        sprintf(temp, "(if %s 1 0)", $3.code);
                                                        $3.code = gen_code(temp);
                                                    }
                                                    sprintf(temp, "(>= %s %s)", $1.code, $3.code);
                                                    $$.code = gen_code (temp) ; }

            |   expresion LESSEQUAL expresion       {$$.type = 0;
                                                    if ($1.type != 1) {
                                                        sprintf(temp, "(if %s 1 0)", $1.code) ;
                                                        $1.code = gen_code(temp);}
                                                    if ($3.type != 1) {
                                                        sprintf(temp, "(if %s 1 0)", $3.code);
                                                        $3.code = gen_code(temp);
                                                    }
                                                    sprintf(temp, "(<= %s %s)", $1.code, $3.code);
                                                    $$.code = gen_code (temp) ; }

            |   expresion AND expresion       { sprintf(temp, "(and %s %s)", $1.code, $3.code);
                                            $$.code = gen_code(temp); }

            |   expresion OR expresion        { sprintf(temp, "(or %s %s)", $1.code, $3.code);
                                            $$.code = gen_code(temp); }
                                            
            
            ;




termino:        operando                           { $$ = $1 ; }      

            |   '+' operando %prec UNARY_SIGN      { $$.type = $2.type;
                                                     sprintf(temp, "(+ %s)", $2.code) ;
                                                     $$.code = gen_code (temp) ; }

            |   '-' operando %prec UNARY_SIGN      { $$.type = $2.type;
                                                     sprintf(temp, "(- %s)", $2.code) ;
                                                     $$.code = gen_code (temp) ; }    
            ;

operando:       IDENTIF                     { $$.type = 1;
                                             sprintf(temp, "%s", $1.code) ;
                                             $$.code = gen_code (temp) ; }

            |   IDENTIF '[' expresion ']'   { $$.type = 1;
                                             sprintf(temp, "(aref %s %s)", $1.code, $3.code) ;
                                             $$.code = gen_code (temp) ; }

            |   IDENTIF '(' argumentos ')'  { $$.type = 1;
                                             sprintf(temp, "(%s %s)", $1.code, $3.code) ;
                                             $$.code = gen_code (temp) ; }

            |   NUMBER                      { $$.type = 1;
                                            sprintf(temp, "%d", $1.value) ;
                                            $$.code = gen_code (temp) ; }

            |   '(' expresion ')'           { $$ = $2 ; }
            
            ;


%%                            // SECCION 4    Codigo en C

int n_line = 1 ;

void yyerror (char *message)
{
    fprintf (stderr, "%s in line %d\n", message, n_line) ;
    printf ( "\n") ;
}

char *int_to_string (int n)
{
    sprintf(temp, "%d", n) ;
    return gen_code (temp) ;
}

char *char_to_string (char c)
{
    sprintf(temp, "%c", c) ;
    return gen_code (temp) ;
}

char *my_malloc (int nbytes)       // reserva n bytes de memoria dinamica
{
    char *p ;
    static long int nb = 0;        // sirven para contabilizar la memoria
    static int nv = 0 ;            // solicitada en total

    p = malloc (nbytes) ;
    if (p == NULL) {
        fprintf (stderr, "No memoria left for additional %d bytes\n", nbytes) ;
        fprintf (stderr, "%ld bytes reserved in %d calls\n", nb, nv) ;
        exit (0) ;
    }
    nb += (long) nbytes ;
    nv++ ;

    return p ;
}


/***************************************************************************/
/********************** Seccion de Palabras Reservadas *********************/
/***************************************************************************/

typedef struct s_keyword { // para las palabras reservadas de C
    char *name ;
    int token ;
} t_keyword ;

t_keyword keywords [] = { // define las palabras reservadas y los
    "main",        MAIN,           // y los token asociados
    "int",         INTEGER,
    "puts",         PUTS,
    "printf",         PRINTF,
    "while",         WHILELOOP,
    "for",         FORLOOP,
    "if",           IF,
    "else",         ELSE,
    "==",           EQUAL,
    "||",           OR,
    "&&",           AND,
    "!=",           NOTEQUAL,
    ">=",           GREATEQUAL,
    "<=",           LESSEQUAL,
    "return",       RETURN,
    NULL,          0               // para marcar el fin de la tabla
} ;

t_keyword *search_keyword (char *symbol_name)
{                                  // Busca n_s en la tabla de pal. res.
                                   // y devuelve puntero a registro (simbolo)
    int i ;
    t_keyword *sim ;

    i = 0 ;
    sim = keywords ;
    while (sim [i].name != NULL) {
	    if (strcmp (sim [i].name, symbol_name) == 0) {
		                             // strcmp(a, b) devuelve == 0 si a==b
            return &(sim [i]) ;
        }
        i++ ;
    }

    return NULL ;
}

 
/***************************************************************************/
/******************* Seccion del Analizador Lexicografico ******************/
/***************************************************************************/

char *gen_code (char *name)     // copia el argumento a un
{                                      // string en memoria dinamica
    char *p ;
    int l ;
	
    l = strlen (name)+1 ;
    p = (char *) my_malloc (l) ;
    strcpy (p, name) ;
	
    return p ;
}


int yylex ()
{
    int i ;
    unsigned char c ;
    unsigned char cc ;
    char expandable_ops [] = "!<=>|%/&+-*" ;
    char temp_str [256] ;
    t_keyword *symbol ;

    do {
        c = getchar () ;

        if (c == '#') {	// Ignora las lineas que empiezan por #  (#define, #include)
            do {		//	OJO que puede funcionar mal si una linea contiene #
                c = getchar () ;
            } while (c != '\n') ;
        }

        if (c == '/') {	// Si la linea contiene un / puede ser inicio de comentario
            cc = getchar () ;
            if (cc != '/') {   // Si el siguiente char es /  es un comentario, pero...
                ungetc (cc, stdin) ;
            } else {
                c = getchar () ;	// ...
                if (c == '@') {	// Si es la secuencia //@  ==> transcribimos la linea
                    do {		// Se trata de codigo inline (Codigo embebido en C)
                        c = getchar () ;
                        putchar (c) ;
                    } while (c != '\n') ;
                } else {		// ==> comentario, ignorar la linea
                    while (c != '\n') {
                        c = getchar () ;
                    }
                }
            }
        } else if (c == '\\') c = getchar () ;
		
        if (c == '\n')
            n_line++ ;

    } while (c == ' ' || c == '\n' || c == '\r' || c == 10 || c == 13 || c == '\t') ;

    if (c == '\"') {
        i = 0 ;
        do {
            c = getchar () ;
            temp_str [i++] = c ;
        } while (c != '\"' && i < 255) ;
        if (i == 256) {
            printf ("WARNING: string with more than 255 characters in line %d\n", n_line) ;
        }		 	// habria que leer hasta el siguiente " , pero, y si falta?
        temp_str [--i] = '\0' ;
        yylval.code = gen_code (temp_str) ;
        return (STRING) ;
    }

    if (c == '.' || (c >= '0' && c <= '9')) {
        ungetc (c, stdin) ;
        scanf ("%d", &yylval.value) ;
//         printf ("\nDEV: NUMBER %d\n", yylval.value) ;        // PARA DEPURAR
        return NUMBER ;
    }

    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
        i = 0 ;
        while (((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
            (c >= '0' && c <= '9') || c == '_') && i < 255) {
            temp_str [i++] = tolower (c) ;
            c = getchar () ;
        }
        temp_str [i] = '\0' ;
        ungetc (c, stdin) ;

        yylval.code = gen_code (temp_str) ;
        symbol = search_keyword (yylval.code) ;
        if (symbol == NULL) {    // no es palabra reservada -> identificador antes vrariabre
//               printf ("\nDEV: IDENTIF %s\n", yylval.code) ;    // PARA DEPURAR
            return (IDENTIF) ;
        } else {
//               printf ("\nDEV: OTRO %s\n", yylval.code) ;       // PARA DEPURAR
            return (symbol->token) ;
        }
    }

    if (strchr (expandable_ops, c) != NULL) { // busca c en operadores expandibles
        cc = getchar () ;
        sprintf(temp_str, "%c%c", (char) c, (char) cc) ;
        symbol = search_keyword (temp_str) ;
        if (symbol == NULL) {
            ungetc (cc, stdin) ;
            yylval.code = NULL ;
            return (c) ;
        } else {
            yylval.code = gen_code (temp_str) ; // aunque no se use
            return (symbol->token) ;
        }
    }

//    printf ("\nDEV: LITERAL %d #%c#\n", (int) c, c) ;      // PARA DEPURAR
    if (c == EOF || c == 255 || c == 26) {
//         printf ("tEOF ") ;                                // PARA DEPURAR
        return (0) ;
    }

    return c ;
}


int main ()
{
    yyparse () ;
}