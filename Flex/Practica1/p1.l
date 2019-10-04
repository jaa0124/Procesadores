%{

int pMayusc = 0;
int n2Cifras = 0;
int linea = 1;
%}
MAYUSCULAS    [A-Z]+
_NUMEROS    [0-9]{2}
%%
{MAYUSCULAS}    { pMayusc++; }
{_NUMEROS}   { n2Cifras; }
\n  { printf("\tSalto de línea %d\n",linea); linea++; }
%%
int main(){
    yylex();
    printf("# de palabras mayúsculas: %d\n# de números de 2 cifras: %d\n", pMayusc, n2Cifras);
}