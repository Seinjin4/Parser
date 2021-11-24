public class Token {

    public int Line;
    public int Column;
    public TokenType Type;
    public String Value = null;

    public Token(int line, int column, TokenType type, String value)
    {
        Line = line;
        Column = column;
        Type = type;
        /*
        if(Type == TokenType.StringVal)
            value = extractString(value);
         */
        Value = value;
    }

    @Override
    public String toString() {
        return String.format("%6d %10d %20s %40s", Line, Column, Type, Value == null ? "" : Value);
    }

    @Deprecated
    private String extractString(String str)
    {
        return str.substring(1, str.length()-1);
    }
}
