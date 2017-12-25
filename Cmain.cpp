
#include<stdio.h>
#pragma inline
#include<string.h>
#define N 5
char tab[N * 16 + 1] ={
	'T','E','M','P','V','A','L','U','E','\0',56,90,95,12,0,2,
	'T','E','M','P','V','A','L','U','E','\0',45,90,95,23,0,2,
    'T','E','M','P','V','A','L','U','E','\0',12,90,95,34,0,3,
    'T','E','M','P','V','A','L','U','E','\0',34,90,95,45,0,5,
    'T','E','M','P','V','A','L','U','E','\0',45,90,95,23,0,3
	};
char *p=tab;
extern  "C" void _Cdecl  AVERAGE(char * info);
extern  "C" void _Cdecl RANK(char *info);

void INSERT (void);
void  PRINT(void);

int main(void)
{
	//  printf("Menu\n");
	//  printf("1:INSERT STUDENTS' NAMES AND SCORES\n");
    //  printf("2:CACULATE AVERAGE SCORES\n");
    //  printf("3:CACULATE RANKINGS\n");
    //  printf("4:EXPORT TRANSCRIPTS\n");
    //  printf("5:Exit");
	//  char c;
	 while(1)
	 {
		 char c;
		 printf("Menu\n");
		 printf("1:INSERT STUDENTS' NAMES AND SCORES\n");
		 printf("2:CACULATE AVERAGE SCORES\n");
		 printf("3:CACULATE RANKINGS\n");
		 printf("4:EXPORT TRANSCRIPTS\n");
		 printf("5:Exit\n");
		 c=getchar();
		 getchar();
		 switch(c)
		 {
			 case '1':INSERT();
			 break;
			 case '2':
			 asm mov ax,0;
			 AVERAGE(tab);
			 break;
			 case '3':RANK(tab);
			 break;
			 case '4':PRINT();
			 break;
			 default:
			 return 0;
		 }
	 }
	 return 0;
}
void  PRINT(void)
{
	int i;
	int j;
	int temp;
	printf("This is the GPA and ranking of students!\n");
	for(i=0;i<5;i++)
	{
		printf("%10s",tab+16*i);
		printf("%6d",(int)tab[16*i+13]);
		printf("%6d",(int)tab[16*i+14]);
		//printf("%2d",(int)tab[16*i+15]);
		printf("\n");
	}
}
void INSERT(void)
{
	
	int i;
	int i1;
	int i2;
	int i3;
	char c;
	int count;
	int num_sp;
	int j;
	for(i=0;i<5;i++)
	{
		//char *ptr=tab;
		printf("STUDENT ");
		printf("%d\n",i);
		printf("Please enter the student's name  in  english!:");
        asm mov si,0;
		asm mov di,0;
		//asm mov as,0;
		asm mov sp,0;
		asm mov bx,0;
		asm mov cx,0;
		asm mov dx,0;
		asm mov di,0;
		asm mov bp,0;
		asm mov sp,0;
		asm mov bx,0;
		asm mov ax,0;
		scanf("%s",tab+16*i);
		getchar();

		printf("Please enter the student's chinese score!:");

		scanf("%d",&j);
		getchar();
		while (!((j>=0)&&(j<=100)))
			{
				printf("Please enter numbers between 0 and 100 inclusively!");
				scanf("%d",&j);
			}
		tab[16*i+10]=(char)(j&0xff);
		

		printf("Please enter the student's math score!:");
		scanf("%d",&j);
		getchar();
		while (!((j>=0)&&(j<=100)))
			{
				printf("Please enter numbers between 0 and 100 inclusively!");
				scanf("%d",&j);
			}
		tab[16*i+11]=(char)(j&0xff);
	

		printf("Please enter the student's english score!:");
		scanf("%d",&j);
		getchar();
		while (!((j>=0)&&(j<=100)))
			{
				printf("Please enter numbers between 0 and 100 inclusively!");
				scanf("%d",&j);
			}
		tab[16*i+12]=(char)(j&0xff);
		printf("\n");
	}
}

