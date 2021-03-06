#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "uart.h"

struct cpu cpus[NCPU];
struct cpu *cpu;

extern pde_t *kpgdir;
extern char end[]; // first address after kernel loaded from ELF file

unsigned int test_end;

int main(void){

	cpu = &cpu[0];

	kinit1(end, P2V(4*1024*1024));  /*end(0xc0014040あたり)のページサイズ分の切り上げ ~ */
	                                /* 0xc0400000 をfreelistにする*/
	uart_puts("\nkinit1 OK\n");

	kvmalloc();                     // kernel page table
	uart_puts("\nkvmalloc OK\n");

	//initialize Exception Vector Table(p.2-36 Exceptions)
	trap_init();
	uart_puts("\ntrap_init OK\n");

	pic_init();
	uart_puts("\npic_init OK\n");

	/* init console*/
	/*use locking*/
	console_init();
	uart_puts("\nconsole_init OK\n");

	char *a = "Hello Console\n";
	//cprintf("%s\n",a);


	//process table
	p_init();
	uart_puts("pinit OK\n\n");

	//buffer cachae
	b_init();
	uart_puts("binit OK\n");

	//file init
	file_init();
	uart_puts("file init OK\n\n");

	//inode cache init
	i_init();
	uart_puts("inode init OK\n\n");

	//IDE init
	ide_init();
	uart_puts("IDE disk unit Ok \n\n");

	//timer init
	timer_init();
	uart_puts("timer init OK\n\n");


	kinit2(P2V(4*1024*1024), P2V(PHYSTOP));
	uart_puts("kinit2 OK\n\n");

	// first user process
	//userinit();

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


/*entryのための(page)section table*/
//1M sectionを使う(=>1-levelの変換)
//TTBRレジスタは下位14bitが0として参照されるので
//1-level Page Tableの先頭アドレスは16KB境界に整列する必要がある.
__attribute__((__aligned__(1024 * 16)))                           
pde_t EntryPageTable[NTTENTRIES] = {         //Number of Translation table entries : 4096
	//0
	[0x000] = 0 | (0x000 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0x001] = 0 | (0x001 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0x002] = 0 | (0x002 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0x003] = 0 | (0x003 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,


        //I/O Peripherals
	[PDX(GPIO_BASE_P)] = 0 | ((GPIO_BASE_P >> 20) << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[PDX(GPIO_BASE_V)] = 0 | ((GPIO_BASE_P >> 20) << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[PDX(UART0_BASE_V)] = 0 | ((UART0_BASE_P >> 20) << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,


	//KERNBASE
	[0xc00] = 0 | (0x000 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0xc01] = 0 | (0x001 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0xc02] = 0 | (0x002 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,

	[0xc03] = 0 | (0x003 << 20) | (NS << 19) | (nG << 17) | (S << 16) | (APX << 15) | (TEX <<12)
	| (AP << 10) | (P << 9) | (DOMAIN << 5) | (XN << 4) | (C << 3) | (B << 2) | 0x2,


};
