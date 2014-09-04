# Multiboot header, for multiboot boot loaders like GNU Grub.
# http://www.gnu.org/software/grub/manual/multiboot/multiboot.html
#
# Using GRUB 2, you can boot xv6 from a file stored in a
# Linux file system by copying kernel or kernelmemfs to /boot
# and then adding this menu entry:
#
# menuentry "xv6" {
# 	insmod ext2
# 	set root='(hd0,msdos1)'
# 	set kernel='/boot/kernel'
# 	echo "Loading ${kernel}..."
# 	multiboot ${kernel} ${kernel}
# 	boot
# }

#include "asm.h"
#include "memlayout.h"
#include "mmu.h"
#include "param.h"

# Multiboot header.  Data to direct multiboot loader.
#.p2align 2
#.text
#.globl multiboot_header
multiboot_header:
  #define magic 0x1badb002
  #define flags 0
#  .long magic
#  .long flags
#  .long (-magic-flags)

# By convention, the _start symbol specifies the ELF entry point.
# Since we haven't set up virtual memory yet, our entry point is
# the physical address of 'entry'.
.globl _start
# _start = V2P_WO(entry)

	
# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
	#physical printf (for debug)
	#ldr r4, =0x101f1000
	#mov r1, #0x41
	#str r1, [r4]		
	
	@ Setup the stack pointer(これでいいのか？)
	mov sp, #0x100000
	
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
	MRC p15, 0, r1, c3, c0, 0	
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

	@ jump to main()
	b main