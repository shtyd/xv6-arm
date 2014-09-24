typedef unsigned int uint;
typedef unsigned short ushort;
typedef unsigned char uchar;
typedef uint pde_t;

#ifndef NULL
#define NULL ((void*)0)
#endif

struct trapframe {
    uint    sp_usr;     // user mode sp
    uint    lr_usr;     // user mode lr
    uint    r14_svc;    // r14_svc (r14_svc == pc if SWI)
    uint    spsr;
    uint    r0;
    uint    r1;
    uint    r2;
    uint    r3;
    uint    r4;
    uint    r5;
    uint    r6;
    uint    r7;
    uint    r8;
    uint    r9;
    uint    r10;
    uint    r11;
    uint    r12;
    uint    pc;         // (lr on entry) instruction to resume execution
};

typedef void (*ISR) (struct trapframe *tf, int n);
