struct buf;
struct context;
struct file;
struct inode;
struct pipe;
struct proc;
struct spinlock;
struct stat;
struct superblock;


// arm.c
void            set_stk(uint mode, uint addr);
void            cli (void);
void            sti (void);
uint            spsr_usr();
int             int_enabled();
void            pushcli(void);
void            popcli(void);
void            getcallerpcs(void *, uint*);
void*           get_fp (void);
void            show_callstk (char *);


// bio.c
void            b_init(void);
struct buf*     bread(uint, uint);
void            brelse(struct buf*);
void            bwrite(struct buf*);

// console.c
void            console_init(void);
void            cprintf(char*, ...);
void            consoleintr(int(*)(void));
void            panic(char*) __attribute__((noreturn));


// exec.c
int             exec(char*, char**);

// file.c
struct file*    filealloc(void);
void            fileclose(struct file*);
struct file*    filedup(struct file*);
void            file_init(void);
int             fileread(struct file*, char*, int n);
int             filestat(struct file*, struct stat*);
int             filewrite(struct file*, char*, int n);

// fs.c
void            readsb(int dev, struct superblock *sb);
int             dirlink(struct inode*, char*, uint);
struct inode*   dirlookup(struct inode*, char*, uint*);
struct inode*   ialloc(uint, short);
struct inode*   idup(struct inode*);
void            i_init(void);
void            ilock(struct inode*);
void            iput(struct inode*);
void            iunlock(struct inode*);
void            iunlockput(struct inode*);
void            iupdate(struct inode*);
int             namecmp(const char*, const char*);
struct inode*   namei(char*);
struct inode*   nameiparent(char*, char*);
int             readi(struct inode*, char*, uint, uint);
void            stati(struct inode*, struct stat*);
int             writei(struct inode*, char*, uint, uint);

// ide.c
void            ide_init(void);
void            ideintr(void);
void            iderw(struct buf*);

// ioapic.c
void            ioapicenable(int irq, int cpu);
extern uchar    ioapicid;
void            ioapicinit(void);

// kalloc.c
char*           kalloc(void);
char*           kalloc_pd(void);
void            kfree(char*);
void            kinit1(void*, void*);
void            kinit2(void*, void*);
void            check_fl(void);

// kbd.c
void            kbdintr(void);

// lapic.c
int             cpunum(void);
extern volatile uint*    lapic;
void            lapiceoi(void);
void            lapicinit(void);
void            lapicstartap(uchar, uint);
void            microdelay(int);

// log.c
void            initlog(void);
void            log_write(struct buf*);
void            begin_trans();
void            commit_trans();

// mp.c
extern int      ismp;
int             mpbcpu(void);
void            mpinit(void);
void            mpstartthem(void);

// picirq.c
void            pic_enable(int, ISR);
void            pic_init(void);

// pipe.c
int             pipealloc(struct file**, struct file**);
void            pipeclose(struct pipe*, int);
int             piperead(struct pipe*, char*, int);
int             pipewrite(struct pipe*, char*, int);

//PAGEBREAK: 16
// proc.c
struct proc*    copyproc(struct proc*);
void            exit(void);
int             fork(void);
int             growproc(int);
int             kill(int);
void            p_init(void);
void            procdump(void);
void            scheduler(void) __attribute__((noreturn));
void            sched(void);
void            sleep(void*, struct spinlock*);
void            userinit(void);
int             wait(void);
void            wakeup(void*);
void            yield(void);

// swtch.S
void            swtch(struct context**, struct context*);

// spinlock.c
void            acquire(struct spinlock*);
void            getcallerpcs(void*, uint*);
int             holding(struct spinlock*);
void            init_lock(struct spinlock*, char*);
void            release(struct spinlock*);
void            pushcli(void);
void            popcli(void);

// string.c
int             memcmp(const void*, const void*, uint);
void*           memmove(void*, const void*, uint);
void*           memset(void*, int, uint);
char*           safestrcpy(char*, const char*, int);
int             strlen(const char*);
int             strncmp(const char*, const char*, uint);
char*           strncpy(char*, const char*, int);

// syscall.c
int             argint(int, int*);
int             argptr(int, char**, int);
int             argstr(int, char**);
int             fetchint(uint, int*);
int             fetchstr(uint, char**);
void            syscall(void);

// timer.c
void            timer_init(void);

// trap.c
void            idtinit(void);
extern uint     ticks;
void            trap_init(void);
void            dump_trapframe(struct trapframe *tr);
extern struct spinlock tickslock;
void            swi_handler(struct trapframe *r);
void            irq_handler(struct trapframe *r);
void            reset_handler(struct trapframe *r);
void            und_handler(struct trapframe *r);
void            dabort_handler(struct trapframe *r);
void            pabort_handler(struct trapframe *r);
void            reserved_handler(struct trapframe *r);
void            fiq_handler(struct trapframe *r);

// trap_asm.S
void            trap_reset(void);
void            trap_und(void);
void            trap_swi(void);
void            trap_pabort(void);
void            trap_dabort(void);
void            trap_reserved(void);
void            trap_irq(void);
void            trap_fiq(void);


// uart.c
void            uartinit(void);
void            uartintr(void);
void            uart_putc(char byte);
void            uart_puts(char *str);

// vm.c
void            seginit(void);
void            kvmalloc(void);
void            vmenable(void);
pde_t*          setupkvm(void);
char*           uva2ka(pde_t*, char*);
int             allocuvm(pde_t*, uint, uint);
int             deallocuvm(pde_t*, uint, uint);
void            freevm(pde_t*);
void            inituvm(pde_t*, char*, uint);
int             loaduvm(pde_t*, char*, struct inode*, uint, uint);
pde_t*          copyuvm(pde_t*, uint);
void            switchuvm(struct proc*);
void            switchkvm(void);
int             copyout(pde_t*, uint, void*, uint);
void            clearpteu(pde_t *pgdir, char *uva);

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))
