
#include "port.h"
#include <stdio.h>

#define UC_BLOCKS 4

int uc_trace=0;
struct scblk  s_blk[UC_BLOCKS];

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
	return  &c_blk[num];
}

struct scblk * uc_scblk(int num) {
	return &s_blk[num];
}

int uc_decodes(struct ccblk * cb,struct scblk *sb) {
	unsigned char * cp = cb->str;
	CHAR * sp = sb->str;
	int i;
	sb->typ = TYPE_SCL;
	sb->len = 0;
#ifdef ARCH_X32_8
	for (i = 0;i<cb->len; i++) {
		*sp++ = *cp++;
	}
        sb->len = cb->len;
#else
// here for new code
// fprintf(stderr,"use new\n");
        if (uc_trace) {
	    fprintf(stderr,"\ndecodes  in: %d ",cb->len);
	    for (i=0;i<cb->len;i++) {
		unsigned int c = (unsigned int) cp[i];
		if (0<c && c<127)
	            fprintf(stderr," %c",c);
		else
	            fprintf(stderr," %x",c);
	    }
	    fprintf(stderr,"\n");
	}
	int rc = utf8_to_mchar(cp, cb->len, sp, UC_MAX, 0);
// fprintf(stderr,"mchar result length%d\n",rc);
        sb->len = rc;
	if (uc_trace) {
	    fprintf(stderr,"\ndecodes out: %d ",sb->len);
	    int i;
	    for (i=0;i<sb->len;i++) {
		unsigned int c = sp[i];
		if (0<c && c<127)
	            fprintf(stderr," %c",c);
		else
	            fprintf(stderr," %x",c);
	    }
	    fprintf(stderr,"\n");
	}
#endif
	return 0;
}

int uc_decode(int num,struct ccblk * cb) {
	return uc_decodes(cb, uc_scblk(num));
}

int uc_encodes(struct ccblk *cb,struct scblk *sb) {
// return 0 if can encode, 1 if not

	int i;
	cb->len = 0;
	cb->str[0] = '\0';
	unsigned char * cp = cb->str;
	CHAR * sp = sb->str;
	if (sb->len > UC_MAX) return 1;
#ifdef ARCH_X32_8
	for (i = 0;i<sb->len; i++) {
		*cp++ = *sp++;
	}
	cb->len = sb->len;
	*cp = 0;
#else

        if (uc_trace) {
	    fprintf(stderr,"\nencodes  in: %d ",sb->len);
	    for (i=0;i<sb->len;i++) {
		unsigned int c = sp[i];
		if (c<127)
	            fprintf(stderr," %c",c);
		else
	            fprintf(stderr," %x",c);
	    }
	    fprintf(stderr,"\n");
	}
	int rc = mchar_to_utf8(sp, sb->len, cp, UC_MAX, 0);
	cb->len = rc;
//	*cp = 0;
	if (uc_trace) {
	    fprintf(stderr,"\nencodes out: %d ",cb->len);
	    int i;
	    for (i=0;i<cb->len;i++) {
		unsigned int c = cp[i];
		if (0<c && c<127)
	            fprintf(stderr," %c",c);
		else
	            fprintf(stderr," %x",c);
	    }
	    fprintf(stderr,"\n");
	}
#endif
	return 0;
}

int uc_encode(int num,struct scblk *sb) {
// return 0 if can encode, 1 if not
	return uc_encodes(uc_ccblk(num), sb);
}



