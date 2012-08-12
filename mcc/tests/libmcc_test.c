/*
 * Simple Test program for libmcc
 *
 * libmcc can be useful to use mcc as a "backend" for a code generator.
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "libmcc.h"

/* this function is called by the generated code */
int add(int a, int b)
{
    return a + b;
}

char my_program[] =
"int fib(int n)\n"
"{\n"
"    if (n <= 2)\n"
"        return 1;\n"
"    else\n"
"        return fib(n-1) + fib(n-2);\n"
"}\n"
"\n"
"int foo(int n)\n"
"{\n"
"    printf(\"Hello World!\\n\");\n"
"    printf(\"fib(%d) = %d\\n\", n, fib(n));\n"
"    printf(\"add(%d, %d) = %d\\n\", n, 2 * n, add(n, 2 * n));\n"
"    return 0;\n"
"}\n";

int main(int argc, char **argv)
{
    MCCState *s;
    int (*func)(int);
    void *mem;
    int size;

    s = mcc_new();
    if (!s) {
        fprintf(stderr, "Could not create mcc state\n");
        exit(1);
    }

    /* if mcclib.h and libmcc1.a are not installed, where can we find them */
    if (argc == 2 && !memcmp(argv[1], "lib_path=",9))
        mcc_set_lib_path(s, argv[1]+9);

    /* MUST BE CALLED before any compilation */
    mcc_set_output_type(s, MCC_OUTPUT_MEMORY);

    if (mcc_compile_string(s, my_program) == -1)
        return 1;

    /* as a test, we add a symbol that the compiled program can use.
       You may also open a dll with mcc_add_dll() and use symbols from that */
    mcc_add_symbol(s, "add", add);

    /* get needed size of the code */
    size = mcc_relocate(s, NULL);
    if (size == -1)
        return 1;

    /* allocate memory and copy the code into it */
    mem = malloc(size);
    mcc_relocate(s, mem);

    /* get entry symbol */
    func = mcc_get_symbol(s, "foo");
    if (!func)
        return 1;

    /* delete the state */
    mcc_delete(s);

    /* run the code */
    func(32);

    free(mem);
    return 0;
}
