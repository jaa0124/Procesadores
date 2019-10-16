%{
#include<string.h>
int nKeys = 0;
%}
%%
\{    { 
                            if((strcmp(yytext,"{"))== 0){
                                nKeys++;
                            }

                        }
                
%%
int main(){
    yylex();
    printf("Se han encontrado %d llaves.\n", nKeys);
}