#ifndef LIBMCC_H
#define LIBMCC_H

#ifdef LIBMCC_AS_DLL
#define LIBMCCAPI __declspec(dllexport)
#else
#define LIBMCCAPI
#endif

#ifdef __cplusplus
extern "C" {
#endif

struct MCCState;

typedef struct MCCState MCCState;

/* create a new MCC compilation context */
LIBMCCAPI MCCState *tcc_new(void);

/* free a MCC compilation context */
LIBMCCAPI void tcc_delete(MCCState *s);

/* add debug information in the generated code */
LIBMCCAPI void tcc_enable_debug(MCCState *s);

/* set error/warning display callback */
LIBMCCAPI void tcc_set_error_func(MCCState *s, void *error_opaque,
                        void (*error_func)(void *opaque, const char *msg));

/* set/reset a warning */
LIBMCCAPI int tcc_set_warning(MCCState *s, const char *warning_name, int value);

/*****************************/
/* preprocessor */

/* add include path */
LIBMCCAPI int tcc_add_include_path(MCCState *s, const char *pathname);

/* add in system include path */
LIBMCCAPI int tcc_add_sysinclude_path(MCCState *s, const char *pathname);

/* define preprocessor symbol 'sym'. Can put optional value */
LIBMCCAPI void tcc_define_symbol(MCCState *s, const char *sym, const char *value);

/* undefine preprocess symbol 'sym' */
LIBMCCAPI void tcc_undefine_symbol(MCCState *s, const char *sym);

/*****************************/
/* compiling */

/* add a file (either a C file, dll, an object, a library or an ld
   script). Return -1 if error. */
LIBMCCAPI int tcc_add_file(MCCState *s, const char *filename);

/* compile a string containing a C source. Return non zero if
   error. */
LIBMCCAPI int tcc_compile_string(MCCState *s, const char *buf);

/*****************************/
/* linking commands */

/* set output type. MUST BE CALLED before any compilation */
#define MCC_OUTPUT_MEMORY   0 /* output will be ran in memory (no
                                 output file) (default) */
#define MCC_OUTPUT_EXE      1 /* executable file */
#define MCC_OUTPUT_DLL      2 /* dynamic library */
#define MCC_OUTPUT_OBJ      3 /* object file */
#define MCC_OUTPUT_PREPROCESS 4 /* preprocessed file (used internally) */
LIBMCCAPI int tcc_set_output_type(MCCState *s, int output_type);

#define MCC_OUTPUT_FORMAT_ELF    0 /* default output format: ELF */
#define MCC_OUTPUT_FORMAT_BINARY 1 /* binary image output */
#define MCC_OUTPUT_FORMAT_COFF   2 /* COFF */

/* equivalent to -Lpath option */
LIBMCCAPI int tcc_add_library_path(MCCState *s, const char *pathname);

/* the library name is the same as the argument of the '-l' option */
LIBMCCAPI int tcc_add_library(MCCState *s, const char *libraryname);

/* add a symbol to the compiled program */
LIBMCCAPI int tcc_add_symbol(MCCState *s, const char *name, void *val);

/* output an executable, library or object file. DO NOT call
   tcc_relocate() before. */
LIBMCCAPI int tcc_output_file(MCCState *s, const char *filename);

/* link and run main() function and return its value. DO NOT call
   tcc_relocate() before. */
LIBMCCAPI int tcc_run(MCCState *s, int argc, char **argv);

/* copy code into memory passed in by the caller and do all relocations
   (needed before using tcc_get_symbol()).
   returns -1 on error and required size if ptr is NULL */
LIBMCCAPI int tcc_relocate(MCCState *s1, void *ptr);

/* return symbol value or NULL if not found */
LIBMCCAPI void *tcc_get_symbol(MCCState *s, const char *name);

/* set CONFIG_MCCDIR at runtime */
LIBMCCAPI void tcc_set_lib_path(MCCState *s, const char *path);

#ifdef __cplusplus
}
#endif

#endif
