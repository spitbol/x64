

/* test add two integers */
int add(int a,int b) {
return (a+b);
}




/* test piglatin converter */
char pigbuffer[20000];
char *piglatin(char *source) {
int i;
int j;
int state=0;
i = 0;
j = 0;
int end2=0;
while (source[i]) {
  if (state==0) {
    if ((source[i]=='a')||(source[i]=='e')||(source[i]=='i')||(source[i]=='o')||(source[i]=='u')||
        (source[i]=='y')) {
      state=1;
      pigbuffer[j++] = source[i++];
      }
    else {
      state=2;
      i++;
      }
    }
  else if (state==1) {
    pigbuffer[j++] = source[i++];
    }
  else if (state==2) {
    if ((source[i]=='a')||(source[i]=='e')||(source[i]=='i')||(source[i]=='o')||(source[i]=='u')||
        (source[i]=='y')) {
      state=3;
      end2=i;
      pigbuffer[j++] = source[i++];
      }
    }
  else if (state==3) {
    pigbuffer[j++] = source[i++];
    }
  }
if (state==0) {
  pigbuffer[j++] = 'w';          
  pigbuffer[j++] = 'a';          
  pigbuffer[j++] = 'y';
  } 
else if (state==1) {
  pigbuffer[j++] = 'w';          
  pigbuffer[j++] = 'a';          
  pigbuffer[j++] = 'y';
  }
else if (state==2) {
  pigbuffer[j++] = 'a';          
  pigbuffer[j++] = 'y';
  i = 0;
  while (source[i]) {
    pigbuffer[j++] = source[i++];
    }
  pigbuffer[j++] = 'a';          
  pigbuffer[j++] = 'y';
  }
else if (state==3) {
  i = 0;
  while (i<end2) {
    pigbuffer[j++] = source[i++];
    }
  pigbuffer[j++] = 'a';          
  pigbuffer[j++] = 'y';          
  }
pigbuffer[j]='\0';
return pigbuffer;
}
