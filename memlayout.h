// Memory layout
#ifdef QEMU
#define EXTMEM  0x100000            // Start of extended memory(QEMU)
#endif

#ifdef REAL
#define EXTMEM  0x8000            // Start of extended memory(REAL)
#endif

#define PHYSTOP 0xE000000           // Top physical memory
#define DEVSPACE 0xFE000000         // Other devices are at high addresses

// MMI/O layout (GPI/O and UART)

#ifdef QEMU
#define GPIO_BASE_P 0x101e4000
#define UART0_BASE_P 0x101f1000
#define GPIO_BASE_V 0xf2200000
#define UART0_BASE_V 0xf22f1000
#endif

#ifdef REAL
#define GPIO_BASE_P 0x20200000
#define UART0_BASE_P 0x20201000
#define GPIO_BASE_V 0xf2200000
#define UART0_BASE_V 0xf2201000
#endif

// Key addresses for address space layout (see kmap in vm.c for layout)
#define KERNBASE 0xc0000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }

#endif

#define V2P(a) (((uint) (a)) - KERNBASE)
#define P2V(a) (((void *) (a)) + KERNBASE)

#define V2P_WO(x) ((x) - KERNBASE)    // same as V2P, but without casts
#define P2V_WO(x) ((x) + KERNBASE)    // same as V2P, but without casts
