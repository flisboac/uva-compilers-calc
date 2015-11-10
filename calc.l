%{
#include <cstdio>
#include <iostream>
#include "calc.tab.h"

#define YY_DECL extern "C" int yylex()
#define TOKEN(v) (yylval.texto = yytext; yylval.idtoken = v)

YY_DECL;

%}
%%
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.simbolo = calc::simb(IDENT, yytext); return TOKEN(TIDENT); }
[0-9]+"."[0-9]+\b       { yylval.decimal = atof(yytext); return TOKEN(TDECIMAL); }
[0-9]+\b                { yylval.inteiro = atoi(yytext); return TOKEN(TINTEIRO); }
\+                      { return TOKEN(TADD); }
\-                      { return TOKEN(TSUB); }
\*                      { return TOKEN(TMUL); }
\/                      { return TOKEN(TDIV); }
\(                      { return TOKEN(TLPAREN); }
\)                      { return TOKEN(TRPAREN); }
=                       { return TOKEN(TATRIBUIR); }
[ \t\n]                 /* ignorar espacos */;
%%
