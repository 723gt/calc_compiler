%{
  #include <stdio.h>
  #include <stdlib.h>
  #define YYDEBUG 1
%}

%union{
  double double_val;
}

%token <double_val> DOUBLE_LITERAL
%token ADD SUB MUL DIV CR  
%type <double_val> expr term primary_expr  

%%
/* line_listはline(行)または行並び 行 である*/
line_list: line 
         |line_list line;
line: expr CR /* 行は式と改行である*/
    {
      /* 改行時に結果を出力する*/
      printf(">>%lf\n",$1);
    }
    ;
expr:term /* 式とは項である*/
    |expr ADD term /*または 式 + 項である*/
    {
      $$ = $1 + $3;
    }
    |expr SUB term /* または 式 - 項 である*/
    {
      $$ = $1 - $3;
    }
    ;
term: primary_expr /*項とは一次式である*/
    |term MUL primary_expr /*または項 * 一次式である*/
    {
      $$ = $1 * $3;
    }
    |term DIV primary_expr /* または項 / 一次式である*/
    {
      $$ = $1 / $3;
    };
primary_expr:DOUBLE_LITERAL; /* 一次式とは実数である*/
%%

int yyerror(char const *str){
  extern char *yytext;
  fprintf(stderr," error %s\n",yytext);
  return 0;
}

int main(void){
  extern int yyparse(void);
  extern FILE *yyin;
  
  yyin = stdin;
  if(yyparse()){
    fprintf(stderr,"Error!!Error!!\n");
    exit(1);
  } 
  return 0;
}
