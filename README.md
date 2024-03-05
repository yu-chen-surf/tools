The tool is divided into three parts: scheduler related scripts/source files,
simd related scripts/source files, lkp relateds scripts/source files.

simd directory is composed of two parts, the amx(tmul) and avx512 tests.

Use:
```
gcc -O3 -march=native -fno-strict-aliasing amx-test.c -o amx-test -lpthread
```
to compile the amx-test.c. The gcc version should be later than 12.3

