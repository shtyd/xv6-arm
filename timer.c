// ARM dual-timer module support (SP804)
// ARM Timer is based on ARM AP804
//SP804の説明読んでも意味不明なのでARM Timer(AP804)を使おう。

#include "types.h"
#include "param.h"
#include "mmu.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"

// A SP804 has two timers, we only use the first one, and as perodic timer

// define registers (in units of 4-bytes)
#define TIMER_LOAD     0	// load register, for perodic timer
#define TIMER_VALUE    1	// current value of the counter(Read Only)
#define TIMER_CONTROL  2	// control register
#define TIMER_IRQCLR   3	// clear (ack) the interrupt (any write clear it)(Write Only)
#define TIMER_RIRQ     4        // raw irq (Read Only)
#define TIMER_MIRQ     5	// masked interrupt status (Read Only)
#define TIMER_RELOAD   6        // Reload

// control register bit definitions
#define TIMER_ONESHOT  0x01	// wrap or one shot
#define TIMER_32BIT    0x02 // 16-bit/32-bit counter
#define TIMER_INTEN    0x20	// enable/disable interrupt
#define TIMER_PERIODIC 0x40	// enable periodic mode
#define TIMER_EN       0x80	// enable the timer


#define CLK_HZ          1000000     // the clock is 1MHZ

#define PIC_TIMER01     4
#define PIC_TIMER23     5

void isr_timer (struct trapframe *tp, int irq_idx);

struct spinlock timerlock;
uint ticks;

// acknowledge the timer, write any value to TIMER_INTCLR should do
/* static void ack_timer () */
/* { */
/*     volatile uint * timer = P2V(TIMER_BASE); */
/*     timer[TIMER_INTCLR] = 1; */
/* } */

// initialize the timer: perodical and interrupt based
void timer_init(void)
{
	int hz = 100; //?
	
	volatile uint *timer = TIMER_BASE;//P2V(TIMER_BASE);

	init_lock(&timerlock, "time");

	timer[0] = 1;
	timer[TIMER_LOAD] = CLK_HZ;// / hz;
	timer[TIMER_CONTROL] = TIMER_EN|TIMER_PERIODIC|TIMER_32BIT|TIMER_INTEN;

	pic_enable (PIC_TIMER01, isr_timer);
}

// interrupt service routine for the timer
void isr_timer (struct trapframe *tp, int irq_idx)
{
    /* acquire(&tickslock); */
    /* ticks++; */
    /* wakeup(&ticks); */
    /* release(&tickslock); */
    /* ack_timer(); */
}

// a short delay, use timer 1 as the source
void micro_delay (int us)
{
    /* volatile uint * timer1 = P2V(TIMER1); */

    /* // load the initial value to timer1, and configure it to be freerun */
    /* timer1[TIMER_CONTROL] = TIMER_EN | TIMER_32BIT; */
    /* timer1[TIMER_LOAD] = us; */

    /* // the register will wrap to 0xFFFFFFFF after decrement to 0 */
    /* while ((int)timer1[TIMER_CURVAL] > 0) { */

    /* } */

    /* // disable timer */
    /* timer1[TIMER_CONTROL] = 0; */
}
