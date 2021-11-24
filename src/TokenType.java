public enum TokenType {
    CurlyBracketOp, // {
    CurlyBracketCl, // }
    SquareBracketOp, // [
    SquareBracketCl, // ]

    IntVal,
    FloatVal,
    StringVal,
    DirectoryVal,
    MeasurementTypeVal,
    UndefinedVal,

    Identifier,
    Name,

    KComponent, //COMPONENT
    KEnvironment, //ENVIRONMENT
    KUser, //USER
    KDisplay, //DISPLAY
    KSymbol, //SYMBOL
    KDetail, //DETAIL

    EndOfFile
}
