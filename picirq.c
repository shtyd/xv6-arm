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

#define NUM_INTSRC		32 // numbers of interrupt source supported

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

// enable an interrupt (with the ISR)
void pic_enable (int n, ISR isr)
{
    if ((n<0) || (n >= NUM_INTSRC)) {
        panic ("invalid interrupt source");
    }

    // write 1 bit enable the interrupt, 0 bit has no effect
    isrs[n] = isr;
    vic_base[VIC_INTENABLE] = (1 << n);
}

// disable an interrupt
void pic_disable (int n)
{
    if ((n<0) || (n >= NUM_INTSRC)) {
        panic ("invalid interrupt source");
    }

    vic_base[VIC_INTENCLEAR] = (1 << n);
    isrs[n] = default_isr;
}

// dispatch the interrupt
void pic_dispatch (struct trapframe *tp)
{
    uint intstatus;
    int		i;

    intstatus = vic_base[VIC_IRQSTATUS];

    for (i = 0; i < NUM_INTSRC; i++) {
        if (intstatus & (1<<i)) {
            isrs[i](tp, i);
        }
    }

    intstatus = vic_base[VIC_IRQSTATUS];
}
