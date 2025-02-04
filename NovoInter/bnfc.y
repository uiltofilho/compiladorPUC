/* -*- c -*- File generated by the BNF Converter (bnfc 2.9.5). */

/* Parser definition to be used with Bison. */

/* Generate header file for lexer. */
%defines "Bison.h"

/* Reentrant parser */
%api.pure
  /* From Bison 2.3b (2008): %define api.pure full */
%lex-param   { yyscan_t scanner }
%parse-param { yyscan_t scanner }

/* Turn on line/column tracking in the bnfc_lloc structure: */
%locations

/* Argument to the parser to be filled with the parsed tree. */
%parse-param { YYSTYPE *result }

%{
/* Begin C preamble code */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Absyn.h"

#define YYMAXDEPTH 10000000

/* The type yyscan_t is defined by flex, but we need it in the parser already. */
#ifndef YY_TYPEDEF_YY_SCANNER_T
#define YY_TYPEDEF_YY_SCANNER_T
typedef void* yyscan_t;
#endif

typedef struct yy_buffer_state *YY_BUFFER_STATE;
extern YY_BUFFER_STATE bnfc__scan_string(const char *str, yyscan_t scanner);
extern void bnfc__delete_buffer(YY_BUFFER_STATE buf, yyscan_t scanner);

extern void bnfc_lex_destroy(yyscan_t scanner);
extern char* bnfc_get_text(yyscan_t scanner);

extern yyscan_t bnfc__initialize_lexer(FILE * inp);

/* List reversal functions. */

/* End C preamble code */
%}

%union
{
  int    _int;
  char   _char;
  double _double;
  char*  _string;
  Expr expr_;
  Term term_;
  Factor factor_;
  Stm stm_;
}

%{
void yyerror(YYLTYPE *loc, yyscan_t scanner, YYSTYPE *result, const char *msg)
{
  fprintf(stderr, "error: %d,%d: %s at %s\n",
    loc->first_line, loc->first_column, msg, bnfc_get_text(scanner));
}

int yyparse(yyscan_t scanner, YYSTYPE *result);

extern int yylex(YYSTYPE *lvalp, YYLTYPE *llocp, yyscan_t scanner);
%}

%token          _ERROR_
%token          _LPAREN    /* ( */
%token          _RPAREN    /* ) */
%token          _STAR      /* * */
%token          _PLUS      /* + */
%token          _MINUS     /* - */
%token          _SLASH     /* / */
%token          _EQ        /* = */
%token          _LBRACK    /* [ */
%token          _RBRACK    /* ] */
%token          _KW_print  /* print */
%token<_string> T_Ident    /* Ident */
%token<_string> T_Integer  /* Integer */
%token<_string> T_String   /* String */
%token<_string> _STRING_
%token<_int>    _INTEGER_
%token<_string> _IDENT_

%type <expr_> Expr
%type <term_> Term
%type <factor_> Factor
%type <stm_> Stm

%start Expr

%%

Expr : Expr _PLUS Term { $$ = make_EAdd($1, $3); result->expr_ = $$; }
  | Expr _MINUS Term { $$ = make_ESub($1, $3); result->expr_ = $$; }
;
Term : Term _STAR Factor { $$ = make_TMul($1, $3); result->term_ = $$; }
  | Term _SLASH Factor { $$ = make_TDiv($1, $3); result->term_ = $$; }
  | Factor { $$ = make_TExpr($1); result->term_ = $$; }
;
Factor : T_Integer { $$ = make_FInt($1); result->factor_ = $$; }
  | T_Ident { $$ = make_FVar($1); result->factor_ = $$; }
  | T_String { $$ = make_FStr($1); result->factor_ = $$; }
  | _LPAREN Expr _RPAREN { $$ = make_FPar($2); result->factor_ = $$; }
  | T_Ident _LBRACK Expr _RBRACK { $$ = make_FIndex($1, $3); result->factor_ = $$; }
;
Stm : T_Ident _EQ Expr { $$ = make_Assign($1, $3); result->stm_ = $$; }
  | T_Ident _LBRACK Expr _RBRACK _EQ Expr { $$ = make_ArrAssign($1, $3, $6); result->stm_ = $$; }
  | _KW_print Expr { $$ = make_Print($2); result->stm_ = $$; }
;

%%


/* Entrypoint: parse Expr from file. */
Expr pExpr(FILE *inp)
{
  YYSTYPE result;
  yyscan_t scanner = bnfc__initialize_lexer(inp);
  if (!scanner) {
    fprintf(stderr, "Failed to initialize lexer.\n");
    return 0;
  }
  int error = yyparse(scanner, &result);
  bnfc_lex_destroy(scanner);
  if (error)
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return result.expr_;
  }
}

/* Entrypoint: parse Expr from string. */
Expr psExpr(const char *str)
{
  YYSTYPE result;
  yyscan_t scanner = bnfc__initialize_lexer(0);
  if (!scanner) {
    fprintf(stderr, "Failed to initialize lexer.\n");
    return 0;
  }
  YY_BUFFER_STATE buf = bnfc__scan_string(str, scanner);
  int error = yyparse(scanner, &result);
  bnfc__delete_buffer(buf, scanner);
  bnfc_lex_destroy(scanner);
  if (error)
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return result.expr_;
  }
}

/* Entrypoint: parse Term from file. */
Term pTerm(FILE *inp)
{
  YYSTYPE result;
  yyscan_t scanner = bnfc__initialize_lexer(inp);
  if (!scanner) {
    fprintf(stderr, "Failed to initialize lexer.\n");
    return 0;
  }
  int error = yyparse(scanner, &result);
  bnfc_lex_destroy(scanner);
  if (error)
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return result.term_;
  }
}

/* Entrypoint: parse Term from string. */
Term psTerm(const char *str)
{
  YYSTYPE result;
  yyscan_t scanner = bnfc__initialize_lexer(0);
  if (!scanner) {
    fprintf(stderr, "Failed to initialize lexer.\n");
    return 0;
  }
  YY_BUFFER_STATE buf = bnfc__scan_string(str, scanner);
  int error = yyparse(scanner, &result);
  bnfc__delete_buffer(buf, scanner);
  bnfc_lex_destroy(scanner);
  if (error)
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return result.term_;
  }
}

/* Entrypoint: parse Factor from file. */
Factor pFactor(FILE *inp)
{
  YYSTYPE result;
  yyscan_t scanner = bnfc__initialize_lexer(inp);
  if (!scanner) {
    fprintf(stderr, "Failed to initialize lexer.\n");
    return 0;
  }
  int error = yyparse(scanner, &result);
  bnfc_lex_destroy(scanner);
  if (error)
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return result.factor_;
  }
}

/* Entrypoint: parse Factor from string. */
Factor psFactor(const char *str)
{
  YYSTYPE result;
  yyscan_t scanner = bnfc__initialize_lexer(0);
  if (!scanner) {
    fprintf(stderr, "Failed to initialize lexer.\n");
    return 0;
  }
  YY_BUFFER_STATE buf = bnfc__scan_string(str, scanner);
  int error = yyparse(scanner, &result);
  bnfc__delete_buffer(buf, scanner);
  bnfc_lex_destroy(scanner);
  if (error)
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return result.factor_;
  }
}

/* Entrypoint: parse Stm from file. */
Stm pStm(FILE *inp)
{
  YYSTYPE result;
  yyscan_t scanner = bnfc__initialize_lexer(inp);
  if (!scanner) {
    fprintf(stderr, "Failed to initialize lexer.\n");
    return 0;
  }
  int error = yyparse(scanner, &result);
  bnfc_lex_destroy(scanner);
  if (error)
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return result.stm_;
  }
}

/* Entrypoint: parse Stm from string. */
Stm psStm(const char *str)
{
  YYSTYPE result;
  yyscan_t scanner = bnfc__initialize_lexer(0);
  if (!scanner) {
    fprintf(stderr, "Failed to initialize lexer.\n");
    return 0;
  }
  YY_BUFFER_STATE buf = bnfc__scan_string(str, scanner);
  int error = yyparse(scanner, &result);
  bnfc__delete_buffer(buf, scanner);
  bnfc_lex_destroy(scanner);
  if (error)
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return result.stm_;
  }
}



