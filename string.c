#include "types.h"
#include "x86.h"
#include "defs.h"

unsigned int mem_kakunin;

void*
memset(void *dst, int c, uint n)
{
	/* if ((int)dst%4 == 0 && n%4 == 0) */
	/* { */
	/* 	c &= 0xFF; */
	/* 	stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4); */
	/* }  */
	/* else */
	/* 	stosb(dst, c, n); */
	/* return dst; */
	int i;
	int f = 0;
	int *addr = dst;
//	uint dfsr;

	for (i = 0; i < 32; i++){
//		uart_puts("F");
		f = f | (c << i);
	}
	
	for (i = 0; i < (n / 4); i++)
	{
//		uart_puts("G");
		*addr = f;
		addr++; //addrは(int *)なので、これで４番地先に進む
		/* asm volatile("MRC p15, 0, r6, c6, c0, 0"); //Read Fault Address Register */
		/* asm volatile("MRC p15, 0, r7, c5, c0, 1"); //Read Instruction Fault Status Register */
		/* asm volatile("MRC p15, 0, r8, c6, c0, 2"); //Read Instruction Fault Address Register */

	}
//	uart_puts("memset done\n");
	return dst;

}

/* int */
/* memcmp(const void *v1, const void *v2, uint n) */
/* { */
/*   const uchar *s1, *s2; */
  
/*   s1 = v1; */
/*   s2 = v2; */
/*   while(n-- > 0){ */
/*     if(*s1 != *s2) */
/*       return *s1 - *s2; */
/*     s1++, s2++; */
/*   } */

/*   return 0; */
/* } */

/* void* */
/* memmove(void *dst, const void *src, uint n) */
/* { */
/*   const char *s; */
/*   char *d; */

/*   s = src; */
/*   d = dst; */
/*   if(s < d && s + n > d){ */
/*     s += n; */
/*     d += n; */
/*     while(n-- > 0) */
/*       *--d = *--s; */
/*   } else */
/*     while(n-- > 0) */
/*       *d++ = *s++; */

/*   return dst; */
/* } */

/* // memcpy exists to placate GCC.  Use memmove. */
/* void* */
/* memcpy(void *dst, const void *src, uint n) */
/* { */
/*   return memmove(dst, src, n); */
/* } */

/* int */
/* strncmp(const char *p, const char *q, uint n) */
/* { */
/*   while(n > 0 && *p && *p == *q) */
/*     n--, p++, q++; */
/*   if(n == 0) */
/*     return 0; */
/*   return (uchar)*p - (uchar)*q; */
/* } */

/* char* */
/* strncpy(char *s, const char *t, int n) */
/* { */
/*   char *os; */
  
/*   os = s; */
/*   while(n-- > 0 && (*s++ = *t++) != 0) */
/*     ; */
/*   while(n-- > 0) */
/*     *s++ = 0; */
/*   return os; */
/* } */

/* // Like strncpy but guaranteed to NUL-terminate. */
/* char* */
/* safestrcpy(char *s, const char *t, int n) */
/* { */
/*   char *os; */
  
/*   os = s; */
/*   if(n <= 0) */
/*     return os; */
/*   while(--n > 0 && (*s++ = *t++) != 0) */
/*     ; */
/*   *s = 0; */
/*   return os; */
/* } */

/* int */
/* strlen(const char *s) */
/* { */
/*   int n; */

/*   for(n = 0; s[n]; n++) */
/*     ; */
/*   return n; */
/* } */

