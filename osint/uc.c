
#include "port.h"
#include <stdio.h>

#define UC_MAX 1024

struct	ccblk {
	int	len;
	char	str[UC_MAX];
	};	

struct scblk  s_blk[3];

//struct ccblk  c_blk[3];
char c_blk[3][UC_MAX];

static int c_length(char *cp);

void uc_init(int num) {
	c_blk[num][0] = '\0';
	s_blk[num].typ = TYPE_SCL;
	s_blk[num].len = 0;
}

char * uc_str(int num) {
	return c_blk[num];
}

struct scblk * uc_scblk(int num) {
	return (struct scblk *) &s_blk[num];
}

int uc_decode(int num) {
	char * cp = c_blk[num];
	char * sp = s_blk[num].str;
//	fprintf(stderr,"decode:%d %s\n",c_length(cp),cp);
	int l = c_length(cp);
	for (int i = 0;i<l; i++) {
		*sp++ = *cp++;
	}
	s_blk[num].len = l;
	return 0;
}

int uc_encode(int num) {
	char * cp = c_blk[num];
	char * sp = s_blk[num].str;
	for (int i = 0;i<s_blk[num].len; i++) {
		*cp++ = *sp++;
	}
	*cp = '\0';
	return 0;
}


void uc_strcpy(int num, char * s) {
	int n = c_length(s);
	char * cp=c_blk[num];
	int i;
	for (i=0;(*cp++ = *s++) != 0;i++) {
		;
	}
	*cp = 0;
}


void uc_strcat(int num, char * s) {
	char c;
	while ((c=*s++) != '\0') {
		uc_putc(num,c);
	}
}

void uc_putc(int num, char c) {
	register int n = c_length(c_blk[num]);
	if (n>=UC_MAX) return;
	c_blk[num][n++] = c;
	c_blk[num][n] = 0;
}


/* return length of string argument */
static int c_length(char *cp) {
	char *p = cp;
	while(*p++) ;
	return p - cp - 1;
}

/*
int		uc_putstr(int num, char * s)
int		uc_putc(int num, char c)
*/




