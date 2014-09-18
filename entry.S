#include "asm.h"
#include "memlayout.h"
#include "mmu.h"
#include "param.h"	
#include "uart.h"
	
# By convention, the _start symbol specifies the ELF entry point.
# Since we haven't set up virtual memory yet, our entry point is
# the physical address of 'entry'.
.globl _start
_start = V2P_WO(entry)

	
# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
	#physical printf (for debug)
	ldr r4, =UART0_BASE_P
	mov r1, #0x41
	str r1, [r4]	

	@ Setup the stack pointer(これでいいのか？ まぁよさそう)
	mov sp, #0x2000

	@ Subpage AP bits disable.(CP15 c1[23](XP bit) = 1)
	MRC p15, 0, r1, c1, c0, 0   @ Read Control Register configuration data
	ldr r2, =0x00800000
	orr r1, r1, r2
	MCR p15, 0, r1, c1, c0, 0   @ Write Control Register configuration data		

	@ set Translation Table Base Register 0(TTBR0)
	ldr r1, =(V2P_WO(EntryPageTable))
	ldr r2, =0xffffc000
	and r1, r1, r2
	MCR p15, 0, r1, c2, c0, 0
	
	@ set Translation Table Base Control Register (TTBCR)
	@ Use TTBR0.
	ldr r1, =0x0
	MCR p15, 0, r1, c2, c0, 2

	@ Domain Access Control とりあえず全部managerにする。
	ldr r1, =0xffffffff
	MCR p15, 0, r1, c3, c0, 0
	
	@ disable Instruction Cache (p.3-46)
	MRC p15, 0, r2, c1, c0, 0   @ Read Control Register configuration data
        ldr r3, =0xffffefff	    @ set 0 to 12bit : Instruction Cache disable
	and r2, r2, r3              @ r2 = r2 & r3
	MCR p15, 0, r2, c1, c0, 0   @ Write Control Register configuration data
	
	@ invalidate Instruction Cache (p.3-70)
	ldr r2, =0
	MCR p15, 0, r2, c7, c5, 0   @ Invalidate Entire Instruction Cache

	@ turn on paging  (p.3-47)
	MRC p15, 0, r2, c1, c0, 0   @ Read Control Register configuration data
	ldr r3, =0x1                @ set 1 to 0bit : MMU enable
	orr r2, r2, r3              @ r2 = r2 | r3
	MCR p15, 0, r2, c1, c0, 0   @ Write Control Register configuration data

	nop
	nop
	nop

	// flush all TLB  書き方違う
	ldr r2, =0x0
	MCR p15, 0, r2, c8, c7, 0

	// invalid entire data and instruction cache
	MCR p15, 0, r2, c7, c5, 0
	MCR p15 ,0, r2, c7, c6, 0

	@ Address Translation Test
	@ldr r1, =0x00201000
	@ldr r2, =0x46
	@str r2, [r1]
	
	@ldr r1, =0xc0201000
	@ldr r3, [r1]	
	@ldr r4, =UART0ADDR
	@str r3, [r4]

	@ jump to main()
	@ bは相対ジャンプ。高い仮想アドレスにジャンプしなくてはならないから
	@ b mainではダメ。プログラムカウンタの値を直接変更することで
	@ 関数にジャンプする。
	@ b main
	ldr pc, =main

	