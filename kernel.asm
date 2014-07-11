
kernel:     file format elf32-littlearm


Disassembly of section .text:

80100000 <entry>:
_start = entry - 0x80000000
	
# Entering xv6 on boot processor, with paging off.
#.globl entry
entry:
	B	.
80100000:	eafffffe 	b	80100000 <entry>
