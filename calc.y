%{
#include <cstdio>
#include <iostream>
#include <string>

#include "calc.hpp"

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
 
void yyerror(const char *s);
%}

%union {
	int         idtoken;
	std::string texto;

	calc::simb  simbolo;
	long        inteiro;
	double      decimal;
	calc::expr* expr;
}

%token <simbolo> TIDENT
%token <inteiro> TINTEIRO
%token <decimal> TDECIMAL
%token <idtoken> TADD TSUB TMUL TDIV TLPAREN TRPAREN TATRIBUIR

%type <expr> e

%left TADD TSUB
%left TMUL TDIV

%start e

%%
e : e TATRIBUIR e     { $$ = new calc::expr(calc::simb(yylval.idtoken, yylval.texto), new calc::expr($1), new calc::expr($3)); }
  | e TADD      e     { $$ = new calc::expr(calc::simb(yylval.idtoken, yylval.texto), new calc::expr($1), new calc::expr($3)); }
  | e TSUB      e     { $$ = new calc::expr(calc::simb(yylval.idtoken, yylval.texto), new calc::expr($1), new calc::expr($3)); }
  | e TMUL      e     { $$ = new calc::expr(calc::simb(yylval.idtoken, yylval.texto), new calc::expr($1), new calc::expr($3)); }
  | e TDIV      e     { $$ = new calc::expr(calc::simb(yylval.idtoken, yylval.texto), new calc::expr($1), new calc::expr($3)); }
  | TLPAREN e TRPAREN { }
  | TIDENT            { $$ = new calc::expr(yylval.decimal); }
  | TINTEIRO          { $$ = new calc::expr(yylval.inteiro); }
  | TDECIMAL          { $$ = new calc::expr(yylval.decimal); }
  ;
%%
