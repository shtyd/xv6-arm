#ifndef INCLUDED_PICIRQ_H

#define INCLUDED_PICIRQ_H

/*offsetでアクセスするから、0からのindexだけで表す。*/
#define VIC_IRQSTATUS      0
#define VIC_FIQSTATUS      1
#define VIC_RAWINTR        2
#define VIC_INTSELECT      3
#define VIC_INTENABLE      4
#define VIC_INTENCLEAR     5
#define VIC_SOFTINT        6
#define VIC_SOFTINTCLEAR   7

#define VIC_VECTADDR0      64
#define VIC_VECTADDR1      65
#define VIC_VECTADDR2      66
#define VIC_VECTADDR3      67
#define VIC_VECTADDR4      68

#define VIC_VECTPRIORITY0  128
#define VIC_VECTPRIORITY1  129
#define VIC_VECTPRIORITY2  130
#define VIC_VECTPRIORITY3  131
#define VIC_VECTPRIORITY4  132


#define NUM_ISR            32

#endif


