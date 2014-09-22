#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
/* struct gatedesc idt[256]; */
/* extern uint vectors[];  // in vectors.S: array of 256 entry pointers */
/* struct spinlock tickslock; */
/* uint ticks; */

// trap routine
void swi_handler (struct trapframe *r)
{
	uart_puts("Exception: Software Interrupt\n");
    /* proc->tf = r; */
    /* syscall (); */
}

// trap routine
void irq_handler (struct trapframe *r)
{
	uart_puts("Exception: IRQ\n");
    // proc points to the current process. If the kernel is
    // running scheduler, proc is NULL.
    /* if (proc != NULL) { */
    /*     proc->tf = r; */
    /* } */

    /* // pic_dispatch (r); */
}

// trap routine
void reset_handler (struct trapframe *r)
{
	uart_puts("Exception: Reset\n");
	//cli();
	// cprintf ("reset at: 0x%x \n", r->pc);
}

// trap routine
void und_handler (struct trapframe *r)
{
	uart_puts("Exception: Undefined Instruction\n");
	//cli();
	//cprintf ("und at: 0x%x \n", r->pc);
}

// trap routine
void dabort_handler (struct trapframe *r)
{
	uart_puts("Exception: Data Abort\n");
    /* uint dfs, fa; */

    /* //cli(); */

    /* // read data fault status register */
    /* asm("MRC p15, 0, %[r], c5, c0, 0": [r]"=r" (dfs)::); */

    /* // read the fault address register */
    /* asm("MRC p15, 0, %[r], c6, c0, 0": [r]"=r" (fa)::); */
    
    /* /\* cprintf ("data abort: instruction 0x%x, fault addr 0x%x, reason 0x%x \n", *\/ */
    /* /\*          r->pc, fa, dfs); *\/ */
    
    /* dump_trapframe (r); */
}

// trap routine
void pabort_handler (struct trapframe *r)
{
    /* uint ifs; */
	uart_puts("Prefetch Abort!!\n");
    /* // read fault status register */
    /* asm("MRC p15, 0, %[r], c5, c0, 0": [r]"=r" (ifs)::); */

    /* //cli(); */
    /* //cprintf ("prefetch abort at: 0x%x (reason: 0x%x)\n", r->pc, ifs); */
    /* dump_trapframe (r); */
}

// trap routine
void reserved_handler (struct trapframe *r)
{
	uart_puts("Exception: Reserved\n");
	//cli();
	//cprintf ("n/a at: 0x%x \n", r->pc);
}

// trap routine
void fiq_handler (struct trapframe *r)
{
	uart_puts("Exception: FIQ");
	//cli();
	//cprintf ("fiq at: 0x%x \n", r->pc);
}

void
trap_init(void)
{
	volatile unsigned int *vec_tbl = (unsigned int *)VEC_TBL;	
	static unsigned int const LDR_PCPC = 0xe59ff00u;       

	// Create the Exception Table
	vec_tbl[0] = LDR_PCPC | 0x18; // Reset (SVC)
	vec_tbl[1] = LDR_PCPC | 0x18; // Undefine Instruction (UND)
	vec_tbl[2] = LDR_PCPC | 0x18; // Software interrupt (SVC)
	vec_tbl[3] = LDR_PCPC | 0x18; // Prefetch abort (ABT)
	vec_tbl[4] = LDR_PCPC | 0x18; // Data abort (ABT)
	vec_tbl[5] = LDR_PCPC | 0x18; // Reserved (-)                                               
	vec_tbl[6] = LDR_PCPC | 0x18; // IRQ (IRQ)
	vec_tbl[7] = LDR_PCPC | 0x18; // FIQ (FIQ)

	vec_tbl[8]  = (unsigned int)trap_reset;
	vec_tbl[9]  = (unsigned int)trap_und;
	vec_tbl[10] = (unsigned int)trap_swi;
	vec_tbl[11] = (unsigned int)trap_pabort;
	vec_tbl[12] = (unsigned int)trap_dabort;
	vec_tbl[13] = (unsigned int)trap_reserved;
	vec_tbl[14] = (unsigned int)trap_irq;
	vec_tbl[15] = (unsigned int)trap_fiq;
	
	//スタックがいるのか。
	//initialize the stacks for different mode                                                       
	/* for (i = 0; i < sizeof(modes)/sizeof(uint); i++) { */
	/* 	stk = alloc_page (); */
		
	/* 	if (stk == NULL) { */
	/* 		panic("failed to alloc memory for irq stack"); */
	/* 	} */
		
	/* 	set_stk (modes[i], (unsigned int)stk); */
	/* } */
}

void dump_trapframe (struct trapframe *tf)
{
    /* cprintf ("r14_svc: 0x%x\n", tf->r14_svc); */
    /* cprintf ("   spsr: 0x%x\n", tf->spsr); */
    /* cprintf ("     r0: 0x%x\n", tf->r0); */
    /* cprintf ("     r1: 0x%x\n", tf->r1); */
    /* cprintf ("     r2: 0x%x\n", tf->r2); */
    /* cprintf ("     r3: 0x%x\n", tf->r3); */
    /* cprintf ("     r4: 0x%x\n", tf->r4); */
    /* cprintf ("     r5: 0x%x\n", tf->r5); */
    /* cprintf ("     r6: 0x%x\n", tf->r6); */
    /* cprintf ("     r7: 0x%x\n", tf->r7); */
    /* cprintf ("     r8: 0x%x\n", tf->r8); */
    /* cprintf ("     r9: 0x%x\n", tf->r9); */
    /* cprintf ("    r10: 0x%x\n", tf->r10); */
    /* cprintf ("    r11: 0x%x\n", tf->r11); */
    /* cprintf ("    r12: 0x%x\n", tf->r12); */
    /* cprintf ("     pc: 0x%x\n", tf->pc); */
}
	
/* void */
/* trap_init(void) */
/* { */
/*   int i; */

/*   for(i = 0; i < 256; i++) */
/*     SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0); */
/*   SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER); */
  
/*   initlock(&tickslock, "time"); */
/* } */

/* void */
/* idtinit(void) */
/* { */
/*   lidt(idt, sizeof(idt)); */
/* } */

/* //PAGEBREAK: 41 */
/* void */
/* trap(struct trapframe *tf) */
/* { */
/*   if(tf->trapno == T_SYSCALL){ */
/*     if(proc->killed) */
/*       exit(); */
/*     proc->tf = tf; */
/*     syscall(); */
/*     if(proc->killed) */
/*       exit(); */
/*     return; */
/*   } */

/*   switch(tf->trapno){ */
/*   case T_IRQ0 + IRQ_TIMER: */
/*     if(cpu->id == 0){ */
/*       acquire(&tickslock); */
/*       ticks++; */
/*       wakeup(&ticks); */
/*       release(&tickslock); */
/*     } */
/*     lapiceoi(); */
/*     break; */
/*   case T_IRQ0 + IRQ_IDE: */
/*     ideintr(); */
/*     lapiceoi(); */
/*     break; */
/*   case T_IRQ0 + IRQ_IDE+1: */
/*     // Bochs generates spurious IDE1 interrupts. */
/*     break; */
/*   case T_IRQ0 + IRQ_KBD: */
/*     kbdintr(); */
/*     lapiceoi(); */
/*     break; */
/*   case T_IRQ0 + IRQ_COM1: */
/*     uartintr(); */
/*     lapiceoi(); */
/*     break; */
/*   case T_IRQ0 + 7: */
/*   case T_IRQ0 + IRQ_SPURIOUS: */
/*     cprintf("cpu%d: spurious interrupt at %x:%x\n", */
/*             cpu->id, tf->cs, tf->eip); */
/*     lapiceoi(); */
/*     break; */
   
/*   //PAGEBREAK: 13 */
/*   default: */
/*     if(proc == 0 || (tf->cs&3) == 0){ */
/*       // In kernel, it must be our mistake. */
/*       cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n", */
/*               tf->trapno, cpu->id, tf->eip, rcr2()); */
/*       panic("trap"); */
/*     } */
/*     // In user space, assume process misbehaved. */
/*     cprintf("pid %d %s: trap %d err %d on cpu %d " */
/*             "eip 0x%x addr 0x%x--kill proc\n", */
/*             proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,  */
/*             rcr2()); */
/*     proc->killed = 1; */
/*   } */

/*   // Force process exit if it has been killed and is in user space. */
/*   // (If it is still executing in the kernel, let it keep running  */
/*   // until it gets to the regular system call return.) */
/*   if(proc && proc->killed && (tf->cs&3) == DPL_USER) */
/*     exit(); */

/*   // Force process to give up CPU on clock tick. */
/*   // If interrupts were on while locks held, would need to check nlock. */
/*   if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) */
/*     yield(); */

/*   // Check if the process has been killed since we yielded */
/*   if(proc && proc->killed && (tf->cs&3) == DPL_USER) */
/*     exit(); */
/* } */
