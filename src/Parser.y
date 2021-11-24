%{
  import java.io.*;
%}

%token COMPONENT
%token ENVIRONMENT
%token USER
%token DISPLAY
%token SYMBOL
%token DETAIL

%token Identifier
%token Name
%token StringVal
%token DirectoryVal
%token IntVal
%token FloatVal
%token MeasurementTypeVal
%token UndefinedVal

%type <obj> PROG
%type <obj> SEGMENT
%type <obj> SEGMENTLIST
%type <obj> VALUE
%type <obj> VALUELIST

%type <obj> COMPONENTSEGMENT
%type <obj> ENVIRONMENTSEGMENT
%type <obj> USERSEGMENT
%type <obj> DISPLAYSEGMENT
%type <obj> SYMBOLSEGMENT
%type <obj> DETAILSEGMENT

%% 

PROG: COMPONENTSEGMENT
    ;

COMPONENTSEGMENT: '{' COMPONENT VALUE
    ENVIRONMENTSEGMENT
    USERSEGMENT
    DISPLAYSEGMENT
    SYMBOLSEGMENT
    DETAILSEGMENT
    '}'
    ;

ENVIRONMENTSEGMENT: '{' ENVIRONMENT SEGMENTLIST '}';
USERSEGMENT: '{' USER SEGMENTLIST '}';
DISPLAYSEGMENT: '{' DISPLAY SEGMENTLIST '}';
SYMBOLSEGMENT: '{' SYMBOL SEGMENTLIST '}';
DETAILSEGMENT: '{' DETAIL SEGMENTLIST '}';

SEGMENTLIST: SEGMENT
        | SEGMENT SEGMENTLIST
        ;

SEGMENT:  '{' VALUELIST '}'
        | '[' VALUELIST ']'
        | '{' SEGMENTLIST '}'
        | '{' SEGMENTLIST ']'
        ;

VALUELIST: VALUE
        | VALUE VALUELIST
        | VALUE SEGMENTLIST
        ;

VALUE: Identifier
    | Name
    | StringVal
    | DirectoryVal
    | IntVal
    | FloatVal
    | MeasurementTypeVal
    | UndefinedVal
    ;

%%
  /* a reference to the lexer object */
  private Lexer lexer;

  /* interface to the lexer */
  private int yylex () {
    int yyl_return = -1;
    try {
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }

  /* error reporting */
  public void yyerror (String error) {
    var currToken = (Token)yyval.obj;
    System.err.println ("Error[ " + currToken.Line + " ; " + currToken.Column + " ]: " + error );
  }

  /* lexer is created in the constructor */
  public Parser(Reader r) {
    lexer = new Lexer(r, this);
  }

  /* that's how you use the parser */
  public static void main(String args[]) throws IOException {
    Parser yyparser = new Parser(new FileReader("recources/Sample01.trm"));
    yyparser.yyparse();
  }