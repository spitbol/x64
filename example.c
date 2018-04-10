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
        if ((w0 =  (xr-*(xs_it.wp))) != 0) C_GOTO(rlaj1);
        wa= C_POP();
        xr= C_POP();
        C_EXIT(0);
// rlaj1:
        } /* rlaj0 */
        void rlaj1() {
        wa= *(xr_it.wp);
        wb= RNSI_;
        C_GOTO(rlaj2);
        } /* rlaj1 */

        void rlaj2() {
        if ((w0 =  (wa-*((word *)(CFP_B*RLEND)+xl))) > 0) C_GOTO(rlaj3);
        if ((w0 =  (wa-*((word *)(CFP_B*RLSTR)+xl))) < 0) C_GOTO(rlaj3);
        wa += *((word *)(CFP_B*RLADJ+xl));
        *(xr_it.wp)= wa;
         C_GOTO(rlaj4);
	 
// rlaj3:
//	{rlaj3{add{7,xl{19,*rssi_{{advance to next section{7324
        } /* rlaj2 */
	
	
        void rlaj3() {
        xl += CFP_B*RSSI_;
        if ((w0 = (--wb)))  C_GOTO(rlaj2);
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
xs=(word)(stack);
wa = (word)(test+5);
wb = (word)test;
xl = (word)list;
C_JSR(relaj);
for (int i=0;i<5;i++) {
  printf("new addr %d is %lx\n",i,test[i]);
  }
return(0);
}
