%x EXPECT
%%
<INITIAL>@float         BEGIN(EXPECT);
<EXPECT>[0-9]+"."[0-9]+   {
                            printf( "found a float, = %f\n", atof(yytext));
                        }       
<EXPECT>\n              { printf("returning to INITIAL...\n");
                        BEGIN(INITIAL);
                        }
[0-9]+                  {
                            printf( "found an integer, = %d\n", atoi(yytext));
                        }
"."                     { printf("found a dot\n"); }
%%
