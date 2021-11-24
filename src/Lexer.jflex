
%%
%byaccj
//%debug
%class Lexer
//%function next_token
//%type Token
%line
%column


%{
  /* store a reference to the parser object */
  private Parser yyparser;
  StringBuffer string = new StringBuffer();

  /* constructor taking an additional parser object */
  public Lexer(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

LineTerminator  = \r\n|\r|\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Identifier = [_a-zA-Z][_a-zA-Z0-9\-\+]*
Name = [_a-zA-Z][_a-zA-Z0-9]*\.[a-zA-Z]{3}

StringVal = \"[^\"]*\"
DirectoryVal = \\{StringVal}
IntVal = -[1-9][0-9]* | [1-9][0-9]* | 0
FloatVal = [0-9]*\.[0-9]+ | -[0-9]*\.[0-9]+
MeasurementTypeVal = [a-zA-Z]{1,3}
UndefinedVal = "?"

AnyCharacter = [\s\S]

%state COMMENT
%state NUMBER
%state STRING

%%

<COMMENT> {
    {LineTerminator}        {yybegin(YYINITIAL);}

    {AnyCharacter}          {}
}

<NUMBER>{
    "}"                     {yybegin(YYINITIAL);
                             yyparser.yylval = new ParserVal(new Token(yyline, yycolumn, TokenType.CurlyBracketCl, null));
                              return '}';}
    "]"                     {yybegin(YYINITIAL);
                             yyparser.yylval = new ParserVal(new Token(yyline, yycolumn, TokenType.SquareBracketCl, null));
                             return ']';}
    {WhiteSpace}            {yybegin(YYINITIAL);}

    {MeasurementTypeVal}    {yybegin(YYINITIAL);
                             yyparser.yylval = new ParserVal(new Token(yyline, yycolumn, TokenType.MeasurementTypeVal, yytext()));
                              return Parser.MeasurementTypeVal;}
}

<STRING> {
  \"                             { yybegin(YYINITIAL);
                                   yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.StringVal, string.toString()));
                                   return Parser.StringVal;}
  [^\n\r\"\\]+                   { string.append( yytext() ); }
  \\t                            { string.append("\\t"); }
  \\n                            { string.append("\\n"); }

  \\r                            { string.append("\\r"); }
  \\\"                           { string.append("\\\""); }
  \\                             { string.append("\\\\"); }
}

<YYINITIAL>{
    {WhiteSpace}            {}

    "%"                     {yybegin(COMMENT);}

    "COMPONENT"             {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.KComponent, null)); return Parser.COMPONENT;}
    "ENVIRONMENT"           {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.KEnvironment, null)); return Parser.ENVIRONMENT;}
    "USER"                  {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.KUser, null)); return Parser.USER;}
    "DISPLAY"               {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.KDisplay, null)); return Parser.DISPLAY;}
    "SYMBOL"                {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.KSymbol, null)); return Parser.SYMBOL;}
    "DETAIL"                {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.KDetail, null)); return Parser.DETAIL;}

    "{"                     {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.CurlyBracketOp, null)); return '{';}
    "}"                     {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.CurlyBracketCl, null)); return '}';}
    "["                     {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.SquareBracketOp, null)); return '[';}
    "]"                     {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.SquareBracketCl, null)); return ']';}

    {Name}                  {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.Name, yytext())); return Parser.Name;}
    {Identifier}            {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.Identifier, yytext())); return Parser.Identifier;}

    {DirectoryVal}          {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.DirectoryVal, yytext())); return Parser.DirectoryVal;}
    \"                      {yybegin(STRING);
                             string.setLength(0);}
    {IntVal}                {yybegin(NUMBER);
                             yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.IntVal, yytext())); return Parser.IntVal;}
    {FloatVal}              {yybegin(NUMBER);
                             yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.FloatVal, yytext())); return Parser.FloatVal;}
    {UndefinedVal}          {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.UndefinedVal, null)); return Parser.UndefinedVal;}

    <<EOF>>                 {yyparser.yylval = new ParserVal( new Token(yyline, yycolumn, TokenType.EndOfFile, null)); return 0;}
}