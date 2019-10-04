%%
.|\n	{ ECHO; }
%{
    /*
        - La expresión regular:
            . ->  cualquier carácter menos el salto de línea  
            |  -> operador de selección, UNION de lenguajes regulares
            \n -> salto de línea
        "Cualquier carácter menos el salto de línea UNION salto de línea, es decir, cualquier carácter"

        - El ECHO es una macro que equivale a:
        printf("%s", yytext);

        yytext -> siempre que flex encuentra concordancia con un patrón,
        el token con el que se ha producido la concordancia 
        se guarda en la variable yytext
        
        - EN la parte de definición, se define lo que hace la MACRO
        en este caso se podría hacer:
        #define ECHO (printf("%s", yytext))
    */
%}

