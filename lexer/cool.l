%{
	int comstate = 0,comcount=0;
	int ops=0,num_lines = 0, num_chars = 0, num_idt = 0,num_int=0,com=0,mlcom=0,kw=0,numf=0,str=0;
	struct node
	{
		int id;
		char val[100];
		char type[100];
		struct node* next;
		struct node* prev;
	};
	struct node* tablehead;
	int toknum = 0;
%}

DELIM [ \t\n\r\v\f]
WS {DELIM}+
DIGIT [0-9]
INTEGER	[\-]?{DIGIT}+
NUMBER {INTEGER}.{DIGIT}+
SLCOMMENT "--"[^\n]+
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
{INTEGER} {if(!comstate)++num_int;}
{NUMBER} {if(!comstate)++numf;}
{KW} {if(!comstate)++kw;}
{ID} {if(!comstate) {++num_idt;installtoken(yytext);}}
{STRING} {if(!comstate)++str;}
\n		++num_lines;
{SLCOMMENT} ++com;
"(*" {++mlcom,++comcount,comstate=1;}
"*)" {--comcount; if(comcount == 0) comstate = 0;}
{OP} if(!comstate)++ops;
%%

void printlist(struct node* head)
{
printf("\n");
while(head)
	{
		printf("%d %s\n",head -> id,head -> val);
		head = head -> next;
	}

}
void searchlist(struct node* head)
{
	while(head)
		head = head -> next;

}
struct node* createnode(int i,char ar[])
{
	struct node* temp = (struct node*) malloc(sizeof(struct node));
	temp -> id = i;
	temp -> next = 0;
	temp -> prev = 0;
	int j=0;
	while(ar[j]!='\0') {
		temp->val[j] = ar[j];
		j++;
	}
	return temp;
}

void insert(struct node** head,int i,char ar[],int pos)
{
	if(!(*head))
		*head = createnode(i,ar);
	else
	{
		if(!pos)
			{
				struct node* t1;
				t1 = createnode(i,ar);
				t1 -> next = (*head);
				(*head) -> prev = t1;
				(*head) = t1;
			}
		else
			{
				struct node* t1;
				struct node* t2;
				t1 = (*head);
				int steps = pos - 1;
				while(steps--&&t1)
				{
					t1 = t1 -> next;
				}
				t2 = createnode(i,ar);
				
				t2 -> next = t1 -> next;
				t2 -> prev = t1;
				t1 -> next = t2;
				if(t2 -> next)
					t2 -> next -> prev = t2;
			}
	}
}
void delete(struct node** head,int pos)
{
	if(!pos)
		{
			struct node* t1;
			t1 = (*head);
			*head = (*head)->next;
			(*head) -> prev = 0;
			free(t1);
		}
	else
		{
			struct node* t1;
			struct node* t2;
			t1 = (*head);
			int steps = pos - 1;
			while(steps--&&t1)
			{
				t1 = t1 -> next;
			}
			
			t1 -> prev -> next = t1 -> next;
			if(t1 -> next)
				t1 -> next -> prev = t1 -> prev;			
		}
}

void installtoken() {
	char* ptr = yytext;
	insert(&tablehead,toknum,ptr,0);
	toknum++;
}
void main()  {
	yylex();
	printlist(tablehead);
	printf( "#of ops %d,# of strings = %d,# of lines = %d, # of int = %d # of float = %d #num of comments = %d #num of mlcom = %d, #num of keyword %d,#num of id %d\n",
               ops,str,num_lines, num_int,numf,com,mlcom,kw,num_idt);
}

