%{
	int ops=0,num_lines = 0, num_chars = 0, num_idt = 0,num_int=0,com=0,mlcom=0,kw=0,numf=0,str=0;
%}

DELIM [ \t\n\r\v\f]
WS {DELIM}+
DIGIT [0-9]
INTEGER	[\-]?{DIGIT}+
NUMBER {INTEGER}.{DIGIT}+
COMMENT "--"[^\n]+
ML  "(*"[.\n\t\r\*]*"*)"
KW class|else|fi|if|in|inherits|let|loop|pool|then|while|case|esac|new|of|f[a|A][l|L][s|S][e|E]|t[R|r][u|U][e|E]
STRING \"(.|\\{WS}|[ ])+\"
IDREM [a-zA-Z0-9_]*
TID [A-Z]{IDREM}
OID [a-z]{IDREM}
SID "self"|"SELF_TYPE"
ID {TID}|{SID}|{OID}
MATHOP "+"|"-"|"/"|"*"
BITOP "~"
RELOP "<"|"<="|">"|">="|"="
OP {MATHOP}|{BITOP}|{RELOP}|isvoid|not|"<-"|"@"|"."

%%
{INTEGER} {++num_int;printf("integer %s",yytext);}
{NUMBER} {++numf;printf("number float %s",yytext);}
{KW} {++kw;printf("keyword %s",yytext);}
{ID} {++num_idt;printf("identifier %s",yytext);}
{STRING} {++str;printf("string %s",yytext);}
\n		++num_lines;
{COMMENT} {++com;printf("comment %s",yytext);}
{ML} ++mlcom;
{OP} ++ops;
%%

void main()  {
	yylex();
	printf( "#of ops %d,# of strings = %d,# of lines = %d, # of int = %d # of float = %d #num of comments = %d #num of mlcom = %d, #num of keyword %d,#num of id %d\n",
               ops,str,num_lines, num_int,numf,com,mlcom,kw,num_idt);
}
