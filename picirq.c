// Support of ARM PrimeCell Vectored Interrrupt Controller (PL190)
#include "types.h"
#include "traps.h"
#include "defs.h"
#include "memlayout.h"
#include "picirq.h"

// PL190 supports the vectored interrupts and non-vectored interrupts.
// In this code, we use non-vected interrupts (aka. simple interrupt).
// The flow to handle simple interrupts is as the following:
//		1. an interrupt (IRQ) occurs, trap.c branches to our IRQ handler
//		2. read the VICIRQStatus register, for each source generating
//		   the interrrupt:
//			2.1 locate the correct ISR
//			2.2 execute the ISR
//			2.3 clear the interrupt
//		3 return to trap.c, which will resume interrupted routines
// Note: must not read VICVectorAddr

static volatile unsigned int *vic_base;
static ISR isrs[NUM_ISR]; //Interrupt Service Routine



static void default_isr (struct trapframe *tf, int n)
{
    /* cprintf ("unhandled interrupt: %d\n", n); */
    uart_puts("unhandled interrupt");
}


// initialize the PL190 VIC
// Vectored IRQ interrupt using VIC port
void pic_init(void)
{
	int i;

	//Enables the VIC interface to determine interrupt vectors.
	asm volatile("MRC p15, 0, r2, c1, c0, 0"); //Read Control Register
	asm volatile("ldr r3, =0x1000000");
	asm volatile("orr r2, r3");
	asm volatile("MCR p15, 0, r2, c1, c0, 0"); //Write Control Register

	
	vic_base = (unsigned int*)VIC_BASE; 

	//disable all interrupts
	vic_base[VIC_INTENCLEAR] = 0xffffffff;
	
	for (i = 0; i < NUM_ISR; i++)
	{
		isrs[i] = default_isr;
	}    
}
