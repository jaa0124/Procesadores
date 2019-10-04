%{
    int numero_saltos = 0;
%}
%%
\n   { printf("SE HA ENCONTRADO UN SALTO DE LÍNEA\n");
        numero_saltos++;
}


%%
main(){
    yylex();
    printf("Saltos TOrales: %d", numero_saltos); 
}
