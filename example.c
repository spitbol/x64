        #include "c_64.h"
	#include <stdio.h>
        #define CFP_B	8
        #define RNSI_	5
        #define RLEND	0
        #define RLADJ	RLEND+1
        #define RLSTR	RLADJ+1
        #define RSSI_	RLSTR+1
	
	void rlaj0();
	void rlaj1();
	void rlaj2();
	void rlaj3();
	void rlaj4();
        d_word rlals = 0;

        void relaj() {
        C_PUSH(xr);
        C_PUSH(wa);
        rlals= xl;
        xr= wb;
        C_GOTO(rlaj0);
        } /* relaj */
	
        void rlaj0() {
        xl= rlals;
        if (work_register =  (xr-*((word *)(xs))) != 0) C_GOTO(rlaj1);
        wa= *((word *)(xs)); xs = xs - 8;
        xr= *((word *)(xs)); xs = xs - 8;
        {goto_nextfunction = NULL;  _rt_ = 0;return;}
        } /* rlaj0 */
	
        void rlaj1() {
        wa= *((word *)(xr));
        wb= RNSI_;
        C_GOTO(rlaj2);
        } /* rlaj1 */
	
        void rlaj2() {
        if (work_register =  (wa-*((word *)((CFP_B*RLEND)+xl))) > 0) C_GOTO(rlaj3);
        if (work_register =  (wa-*((word *)((CFP_B*RLSTR)+xl))) < 0) C_GOTO(rlaj3);
        wa += *((word *)((CFP_B*RLADJ)+xl));
        *((word *)(xr))= wa;
         C_GOTO(rlaj4);
        } /* rlaj2 */
	
	
        void rlaj3() {
        xl += CFP_B*RSSI_;
        if ((work_register = (--wb)))  C_GOTO(rlaj2);
        C_GOTO(rlaj4);
        } /* rlaj3 */
	
        void rlaj4() {
        xr += CFP_B;
         C_GOTO(rlaj0);
        } /* rlaj4 */

word stack[100];
word test[5] = {0x600000,0x600008,0x604040,0x700000,0x0};

word list[4] = {0x600000,0x700000,0,0};

int main() {
xs=(word)(stack+99);
wa = (word)(test+5);
wb = (word)test;
xl = (word)list;
C_JSR(relaj);
for (int i=0;i<5;i++) {
  printf("new addr %d is %lx\n",i,test[i]);
  }
return(0);
}
