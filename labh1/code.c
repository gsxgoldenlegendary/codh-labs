#include<stdio.h>
int main(){
	FILE*fp=fopen("code.txt","wb");
	for(int i=0;i<256;i++)
		fprintf(fp,"	.word	%d\n",256-i);
	return 0;
}
