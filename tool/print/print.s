.global _print
_print:
	LDR sp, =stack_top
	
	ldr r4, =0x101f1000
	mov r1, #0x41
	str r1, [r4]
	B .
