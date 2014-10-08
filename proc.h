#ifndef PROC_INCLUDE_
#define PROC_INCLUDE_

// Segments in proc->gdt.
#define NSEGS     7

// Per-CPU state, now we only support one CPU
struct cpu {
    uchar           id;             // index into cpus[] below
    struct context*   scheduler;    // swtch() here to enter scheduler
    volatile uint   started;        // Has the CPU started?

    int             ncli;           // Depth of pushcli nesting.
    int             intena;         // Were interrupts enabled before pushcli?

    // Cpu-local storage variables; see below
    struct cpu*     cpu;
    struct proc*    proc;           // The currently-running process.
};

extern struct cpu cpus[NCPU];
extern int ncpu;


extern struct cpu* cpu;
extern struct proc* proc;

//PAGEBREAK: 17
// Saved registers for kernel context switches. The context switcher
// needs to save the callee save register, as usually. For ARM, it is
// also necessary to save the banked sp (r13) and lr (r14) registers.
// There is, however, no need to save the user space pc (r15) because
// pc has been saved on the stack somewhere. We only include it here
// for debugging purpose. It will not be restored for the next process.
// According to ARM calling convension, r0-r3 is caller saved. We do
// not need to save sp_svc, as it will be saved in the pcb, neither
// pc_svc, as it will be always be the same value.
//
// Keep it in sync with swtch.S
//
struct context {
    // svc mode registers
    uint    r4;
    uint    r5;
    uint    r6;
    uint    r7;
    uint    r8;
    uint    r9;
    uint    r10;
    uint    r11;
    uint    r12;
    uint    lr;
};


enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
    uint            sz;             // Size of process memory (bytes)
    pde_t*          pgdir;          // Page table
    char*           kstack;         // Bottom of kernel stack for this process
    enum procstate  state;          // Process state
    volatile int    pid;            // Process ID
    struct proc*    parent;         // Parent process
    struct trapframe*   tf;         // Trap frame for current syscall
    struct context* context;        // swtch() here to run process
    void*           chan;           // If non-zero, sleeping on chan
    int             killed;         // If non-zero, have been killed
    struct file*    ofile[NOFILE];  // Open files
    struct inode*   cwd;            // Current directory
    char            name[16];       // Process name (debugging)
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap
#endif





/* // Segments in proc->gdt. */
/* #define NSEGS     7 */

/* // Per-CPU state */
/* struct cpu { */
/*   uchar id;                    // Local APIC ID; index into cpus[] below */
/*   struct context *scheduler;   // swtch() here to enter scheduler */
/*   struct taskstate ts;         // Used by x86 to find stack for interrupt */
/*   struct segdesc gdt[NSEGS];   // x86 global descriptor table */
/*   volatile uint started;       // Has the CPU started? */
/*   int ncli;                    // Depth of pushcli nesting. */
/*   int intena;                  // Were interrupts enabled before pushcli? */
  
/*   // Cpu-local storage variables; see below */
/*   struct cpu *cpu; */
/*   struct proc *proc;           // The currently-running process. */
/* }; */

/* extern struct cpu cpus[NCPU]; */
/* extern int ncpu; */

/* // Per-CPU variables, holding pointers to the */
/* // current cpu and to the current process. */
/* // The asm suffix tells gcc to use "%gs:0" to refer to cpu */
/* // and "%gs:4" to refer to proc.  seginit sets up the */
/* // %gs segment register so that %gs refers to the memory */
/* // holding those two variables in the local cpu's struct cpu. */
/* // This is similar to how thread-local variables are implemented */
/* // in thread libraries such as Linux pthreads. */
/* extern struct cpu *cpu asm("%gs:0");       // &cpus[cpunum()] */
/* extern struct proc *proc asm("%gs:4");     // cpus[cpunum()].proc */

/* //PAGEBREAK: 17 */
/* // Saved registers for kernel context switches. */
/* // Don't need to save all the segment registers (%cs, etc), */
/* // because they are constant across kernel contexts. */
/* // Don't need to save %eax, %ecx, %edx, because the */
/* // x86 convention is that the caller has saved them. */
/* // Contexts are stored at the bottom of the stack they */
/* // describe; the stack pointer is the address of the context. */
/* // The layout of the context matches the layout of the stack in swtch.S */
/* // at the "Switch stacks" comment. Switch doesn't save eip explicitly, */
/* // but it is on the stack and allocproc() manipulates it. */
/* struct context { */
/*   uint edi; */
/*   uint esi; */
/*   uint ebx; */
/*   uint ebp; */
/*   uint eip; */
/* }; */

/* enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE }; */

/* // Per-process state */
/* struct proc { */
/*   uint sz;                     // Size of process memory (bytes) */
/*   pde_t* pgdir;                // Page table */
/*   char *kstack;                // Bottom of kernel stack for this process */
/*   enum procstate state;        // Process state */
/*   volatile int pid;            // Process ID */
/*   struct proc *parent;         // Parent process */
/*   struct trapframe *tf;        // Trap frame for current syscall */
/*   struct context *context;     // swtch() here to run process */
/*   void *chan;                  // If non-zero, sleeping on chan */
/*   int killed;                  // If non-zero, have been killed */
/*   struct file *ofile[NOFILE];  // Open files */
/*   struct inode *cwd;           // Current directory */
/*   char name[16];               // Process name (debugging) */
/* }; */

/* // Process memory is laid out contiguously, low addresses first: */
/* //   text */
/* //   original data and bss */
/* //   fixed-size stack */
/* //   expandable heap */

