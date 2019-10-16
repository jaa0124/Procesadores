%{
/*
*Práctica 1
*@author Arrobo Acaro Johnson
*@author Arroyo Pérez Miguel
*/
#include <stdio.h>
#include <string.h>

int nDefinitions= 0, nStartCond= 0, nRules= 0, longestPattern = 0, nChar = 0, caracteresRegla = 0, longestRule = 0;
int nBraceOpened=0, nBraceClosed=0;
char *longestDefinition = "", *auxDefinition = "";
%}
START_DEF       \%\{
END_DEF         \%\}
START_RUL       \%\%
START_COND     \%x 
RUL_NAME    ^[a-zA-Z_][a-zA-Z]+
RUL_STAY_NAME   [a-zA-Z]
LETTER      [a-zA-Z]
NUM         [0-9]
EOL         \n
SPACE       " " 
WHITSPACE  [\ \t]
C_CODE  [^\ ]
ANY     .|{EOL}
OTHER       ^[^\ |^\t]
%x C_DEF DEF_ER COND PATTERN PRE_RUL RULES CODE EXP_REG CLASS CODE_BRACE BRACE STATE PNTH STR STR_C CHAR END
%%
<INITIAL>{START_DEF}        BEGIN(C_DEF);
<INITIAL>{RUL_NAME}         { auxDefinition=strdup(yytext);
                                BEGIN(DEF_ER);
                    }
<INITIAL>{START_COND}        BEGIN(COND);      
<INITIAL>{START_RUL}        BEGIN(RULES);
<C_DEF>{ANY}                ;
<C_DEF>{END_DEF}            BEGIN(INITIAL);
<DEF_ER>{RUL_STAY_NAME}          ;
<DEF_ER>{WHITSPACE}+        BEGIN(PATTERN);
<PATTERN>{ALL}              nChar++;;/*NOs mantenemos para ver longitud de la def*/
<PATTERN>{EOL}              {
                            if(nChar>longestPattern){
                                longestPattern = nChar;
                                longestDefinition = auxDefinition;
                            }
                            nDefinitions++; 
                            nChar = 0;
                            BEGIN(INITIAL);
                            }
<COND>{SPACE}[A-Z]+         nStartCond++;; //nos mantenemos en ese estado
<COND>{EOL}             BEGIN(INITIAL);
<RULES>[a-zA-Z]         BEGIN(EXP_REG);
<RULES>\{               BEGIN(BRACE);
<BRACE>[a-zA-Z,]   ;
<BRACE>\}               BEGIN(EXP_REG);
<EXP_REG>\}                BEGIN(BRACE);
<RULES>"["              BEGIN(CLASS);
<CLASS>[a-zA-Z0-9]   ;
<CLASS>\]                  BEGIN(EXP_REG);
<EXP_REG>\]             BEGIN(CLASS);
<RULES>\<               BEGIN(COND);
<COND>[a-zA-Z*\/^]   ;
<COND>\>                    BEGIN(EXP_REG);
<EXP_REG>\>              BEGIN(COND);
<RULES><\"               BEGIN(STR);
<STR>{ANY}               ;
<STR>\"                     BEGIN(EXP_REG);
<EXP_REG>\"                 BEGIN(STR);
<EXP_REG>{WHITSPACE}       BEGIN(CODE); //código C
<CODE>[a-z]              caracteresRegla++;
<CODE>\{                 BEGIN(CODE_BRACE);
<CODE_BRACE>.            {
                    caracteresRegla++;
                    if((strcmp(yytext, "{"))==0){
                        nBraceOpened++;
                    }else if((strcmp(yytext, "}"))==0){
                        nBraceClosed++;
                    }
                    if(nBraceClosed > nBraceOpened && (strcmp(yytext, " "))==0){
                        nRules++;
                        BEGIN(RULES);
                    }
}
<CODE>\n            nRules++;BEGIN(RULES);

<CODE>\"            BEGIN(STR_C);
<STR_C>.               ;
<STR_C>\"           BEGIN(CODE);
<CODE>\'            BEGIN(CHAR);
<CHAR>[a-zA-Z]{1}               ;
<CHAR>\'           BEGIN(CODE);             

%%
int main(int argc, char **argv){
    if(argc > 1){
        FILE *file;
        file = fopen(argv[1], "r");
        if(!file){
            fprintf(stderr, "no se puede abrir %s\n", argv[1]);
            exit(1);
        }
        yyin = file;
    }

    yylex();
    printf("------------------------------\n");
    printf("- El número de definiciones es: %d\n", nDefinitions);
    printf("- El número de condiciones de arranque es: %d\n", nStartCond);
    printf("- Se han definido %d reglas.\n", nRules);
    printf("- El nombre de la definicion con el mayor patrón es: %s\n", longestDefinition);
    printf("- La regla con el mayor fragmento de código C es la %d.\n", longestRule);
    return 0;
}
