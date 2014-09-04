#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"


volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;
//emulator: UART0::0x101f1000;                                                                      

/* void print_uart0(const char *s) { */
/* 	while(*s != '\0') { /\* Loop until end of string *\/ */
/* 		*UART0DR = (unsigned int)(*s); /\* Transmit char *\/ */
/* 		s++; /\* Next char *\/ */
/* 	} */
/* } */

int main(void){
//	print_uart0("Hello main!\n");
	*UART0DR = (unsigned int)0x44;
	while(1){}
	
	return 0;
}
/* static void startothers(void); */
/* static void mpmain(void)  __attribute__((noreturn)); */
/* extern pde_t *kpgdir; */
/* extern char end[]; // first address after kernel loaded from ELF file */

/* // Bootstrap processor starts running C code here. */
/* // Allocate a real stack and switch to it, first */
/* // doing some setup required for memory allocator to work. */
/* int */
/* main(void) */
/* { */
/*   kinit1(end, P2V(4*1024*1024)); // phys page allocator */
/*   kvmalloc();      // kernel page table */
/*   mpinit();        // collect info about this machine */
/*   lapicinit(); */
/*   seginit();       // set up segments */
/*   cprintf("\ncpu%d: starting xv6\n\n", cpu->id); */
/*   picinit();       // interrupt controller */
/*   ioapicinit();    // another interrupt controller */
/*   consoleinit();   // I/O devices & their interrupts */
/*   uartinit();      // serial port */
/*   pinit();         // process table */
/*   tvinit();        // trap vectors */
/*   binit();         // buffer cache */
/*   fileinit();      // file table */
/*   iinit();         // inode cache */
/*   ideinit();       // disk */
/*   if(!ismp) */
/*     timerinit();   // uniprocessor timer */
/*   startothers();   // start other processors */
/*   kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers() */
/*   userinit();      // first user process */
/*   // Finish setting up this processor in mpmain. */
/*   mpmain(); */
/* } */

/* // Other CPUs jump here from entryother.S. */
/* static void */
/* mpenter(void) */
/* { */
/*   switchkvm();  */
/*   seginit(); */
/*   lapicinit(); */
/*   mpmain(); */
/* } */

/* // Common CPU setup code. */
/* static void */
/* mpmain(void) */
/* { */
/*   cprintf("cpu%d: starting\n", cpu->id); */
/*   idtinit();       // load idt register */
/*   xchg(&cpu->started, 1); // tell startothers() we're up */
/*   scheduler();     // start running processes */
/* } */



//pde_t entrypgdir[];  // For entry.S



/* // Start the non-boot (AP) processors. */
/* static void */
/* startothers(void) */
/* { */
/*   extern uchar _binary_entryother_start[], _binary_entryother_size[]; */
/*   uchar *code; */
/*   struct cpu *c; */
/*   char *stack; */

/*   // Write entry code to unused memory at 0x7000. */
/*   // The linker has placed the image of entryother.S in */
/*   // _binary_entryother_start. */
/*   code = p2v(0x7000); */
/*   memmove(code, _binary_entryother_start, (uint)_binary_entryother_size); */

/*   for(c = cpus; c < cpus+ncpu; c++){ */
/*     if(c == cpus+cpunum())  // We've started already. */
/*       continue; */

/*     // Tell entryother.S what stack to use, where to enter, and what  */
/*     // pgdir to use. We cannot use kpgdir yet, because the AP processor */
/*     // is running in low  memory, so we use entrypgdir for the APs too. */
/*     stack = kalloc(); */
/*     *(void**)(code-4) = stack + KSTACKSIZE; */
/*     *(void**)(code-8) = mpenter; */
/*     *(int**)(code-12) = (void *) v2p(entrypgdir); */

/*     lapicstartap(c->id, v2p(code)); */

/*     // wait for cpu to finish mpmain() */
/*     while(c->started == 0) */
/*       ; */
/*   } */
/* } */



// Boot page table used in entry.S and entryother.S.
// Page directories (and page tables), must start on a page boundary,
// hence the "__aligned__" attribute.  
// Use PTE_PS in page directory entry to enable 4Mbyte pages.
/* __attribute__((__aligned__(PGSIZE)))                      //PGSIZE 4096 */
/* pde_t entrypgdir[NPDENTRIES] = {                          //NPDENTRIES 1024 */
/*   // Map VA's [0, 4MB) to PA's [0, 4MB) */
/*   [0] = (0) | PTE_P | PTE_W | PTE_PS,  */
/*   // Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB) */
/*   [KERNBASE>>PDXSHIFT] = (0) | PTE_P | PTE_W | PTE_PS,    //KERNBASE 80000000, PDXSHIFT 22 */
/* }; */


/*entryのためのページディレクトリ*/
// Boot page table used in entry.S and entryother.S.
// Page directories (and page tables), must start on a page boundary,
// hence the "__aligned__" attribute.  
// (p.6-39)

//1M sectionを使う ?
/* __attribute__((__aligned__(1024 * 16)))                             //PGSIZE 4096 */
/* pde_t entrypgdir[NTTENTRIES] = {                                    //Number of Translation table entries : 4096 */
/* 	[0] = 0b000000000000 << 20 | 0b00000001010000000010, */
/* 	[0x10100000 >> 20] = 0x10100000 | 0b00000001010000000010,    //UART0: 0x101f1000 */
/* 	[KERNBASE >> 20] = 0b000000000000 << 20 | 0b00000001010000000010, */
/* }; */

//1M sectionを使う(=>1-levelの変換)
//TTBRレジスタは下位14bitが0として参照されるので
//1-level Page Tableの先頭アドレスは16KB境界に整列する必要がある.
__attribute__((__aligned__(1024 * 16)))                           
pde_t EntryPageTable[NTTENTRIES] = {                 //Number of Translation table entries : 4096
	//0
	[0x000] = 0 | (0x000 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0x001] = 0 | (0x001 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0x002] = 0 | (0x002 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0x003] = 0 | (0x003 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,
	
	[0x004] = 0 | (0x004 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

        //UART0: 0x101f1000
	[0x101] = 0 | (0x101 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	//KERNBASE
	[0x800] = 0 | (0x000 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	//KERNBASE + 1M
	[0x801] = 0 | (0x001 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0x801] = 0 | (0x002 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0x801] = 0 | (0x003 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0x801] = 0 | (0x004 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2
};

 
//PAGEBREAK!
// Blank page.

