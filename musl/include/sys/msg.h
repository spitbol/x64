#ifndef _SYS_MSG_H
#define _SYS_MSG_H

#ifdef __cplusplus
extern "C" {
#endif

#include <sys/ipc.h>

#define __NEED_pid_t
#define __NEED_key_t
#define __NEED_time_t
#define __NEED_size_t
#define __NEED_ssize_t

#include <bits/alltypes.h>

typedef unsigned long msgqnum_t;
typedef unsigned long msglen_t;

#include <bits/msg.h>

#define __msg_cbytes msg_cbytes

#define MSG_NOERROR 010000

#define MSG_STAT 11
#define MSG_INFO 12

struct msginfo {
	int msgpool, msgmap, msgmax, msgmnb, msgmni, msgssz, msgtql;
	unsigned short msgseg;
};

int msgctl (int, int, struct msqid_ds *);
int msgget (key_t, int);
ssize_t msgrcv (int, void *, size_t, long, int);
int msgsnd (int, const void *, size_t, int);

#ifdef __cplusplus
}
#endif

#endif