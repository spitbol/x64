
#include "port.h"
#include <stdio.h>

//#define UC_MAX 512
#define UC_BLOCKS 4
// Above should match TCCBLK_LENGTH until that is eliminated.

struct ccblk  s_blk[UC_BLOCKS];

struct ccblk 	c_blk[UC_BLOCKS];

/* return length of string argument */
static int c_length(char *cp) {
	char *p = cp;
	while(*p++) ;
	return p - cp - 1;
}

static void	uc_init_c(int num) {
	c_blk[num].len = 0;
	c_blk[num].str[0] = '\0';
}

static void	uc_init_s(int num) {
	s_blk[num].typ = TYPE_SCL;
	s_blk[num].len = 0;
}

static void uc_init(int num) {
	uc_init_c(num);
	uc_init_s(num);
}

struct ccblk * uc_ccblk(int num) {
	return (struct ccblk *) &c_blk[num];
}

struct scblk * uc_scblk(int num) {
	return (struct scblk *) &s_blk[num];
}

int uc_decodes(struct ccblk * cb,struct scblk *sb) {
	char * cp = cb->str;
	char * sp = sb->str;
//	fprintf(stderr,"decode: %d %s\n",cb->len,cb->str);
	int i;
	sb->typ = TYPE_SCL;
	sb->len = 0;
	for (i = 0;i<cb->len; i++) {
		*sp++ = *cp++;
	}
        sb->len = cb->len;
	return 0;
}

int uc_decode(int num,struct ccblk * cb) {
	return uc_decodes(cb, uc_scblk(num));
}

int uc_encodes(struct ccblk *cb,struct scblk *sb) {
// return 0 if can encode, 1 if not

	cb->len = 0;
	cb->str[0] = '\0';
	char * cp = cb->str;
	char * sp = sb->str;
//	fprintf(stderr,"decode:%d %s\n",c_length(cp),cp);
	int l = c_length(cp);
	if (sb->len > UC_MAX) return 1;
	int i;
	for (i = 0;i<sb->len; i++) {
		*cp++ = *sp++;
	}
	cb->len = sb->len;
	*cp = 0;
	return 0;
}

int uc_encode(int num,struct scblk *sb) {
// return 0 if can encode, 1 if not
	return uc_encodes(uc_ccblk(num), sb);
}

#ifdef UC_ALL

int	uc_len(int num) {
	return c_blk[num].len;
}

void	uc_setlen(int num, int length) {
	c_blk[num].len = length;
	c_blk[num].str[length] = '\0'; // shorten c string
}

char * uc_str(int num) {
	return c_blk[num].str;
}

int	uc_type(int num) {
	return s_blk[num].typ;
}



void uc_append(int num, char * s) {
	int n = c_length(s);
	struct ccblk *cb = &c_blk[num];
	if (cb->len + n > UC_MAX) {
		return;
	}
	int i;
	for (i=0;i<n;i++) {
		cb->str[cb->len+i] = s[i];
	}
	cb->len += n;
	cb->str[cb->len] = 0;
}

void uc_putc(int num, char c) {
	struct ccblk *cb = &c_blk[num];
	if (cb->len == UC_MAX) return;
	cb->str[cb->len++] = c;
	cb->str[cb->len] = 0;
}

/*
int		uc_putstr(int num, char * s)
int		uc_putc(int num, char c)
*/
#endif


