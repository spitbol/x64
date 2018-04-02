
system: test_ext.so test_extr

test_extr: test_extr.c
	gcc -g   -o  test_extr test_extr.c  -ldl

test_ext.so: test_ext.o
	gcc -g -shared -fPIC -o test_ext.so test_ext.c



text_ext.o: test_ext.c
	gcc -g -shared -c -fPIC -DHAVE_CONFIG_H test_ext.c		

