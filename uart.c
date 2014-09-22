//uart initialization (for REAL) and communication

#include "types.h"
#include "mmu.h"
#include "memlayout.h"
#include "uart.h"

extern inline void mmio_write(unsigned int reg, unsigned int data);
extern inline unsigned int mmio_read(unsigned int reg);

/*
 * countサイクル待つ
 * ループを最適化しない
 * 00000030 <__delay_16>:
 * 30:   e2533001        subs    r3, r3, #1
 * 34:   1afffffd        bne     30 <__delay_16>
 */
static void delay(int count) {
	asm volatile("__delay_%=: subs %[count], %[count], #1; bne __delay_%=\n"
		     : : [count]"r"(count) : "cc");
}

void uart_init() {
	// Disable UART0.
	mmio_write(UART0_CR, 0x00000000);

	// Flash the transmit FIFO
	mmio_write(UART0_LCRH, 0x00000000);

	// Setup the GPIO pin 14 && 15. 
	// Disable pull up/down for all GPIO pins & delay for 150 cycles.
	mmio_write(GPPUD, 0x00000000);
	delay(150);
 
	// Disable pull up/down for pin 14,15 & delay for 150 cycles.
	mmio_write(GPPUDCLK0, (1 << 14) | (1 << 15));
	delay(150);

 	// Write 0 to GPPUD to make it take effect. ?
	mmio_write(GPPUD, 0x00000000);

	// Write 0 to GPPUDCLK0 to make it take effect. ?
	mmio_write(GPPUDCLK0, 0x00000000);
 
	// Clear pending interrupts. ?
	mmio_write(UART0_ICR, 0xFFFF);
 
	// Set integer & fractional part of baud rate. ?
	// Divider = UART_CLOCK/(16 * Baud)
	// Fraction part register = (Fractional part * 64) + 0.5
	// UART_CLOCK = 3000000; Baud = 115200.
 
	// Divider = 3000000/(16 * 115200) = 1.627 = ~1.
	// Fractional part register = (.627 * 64) + 0.5 = 40.6 = ~40.
	mmio_write(UART0_IBRD, 1);
	mmio_write(UART0_FBRD, 40);
 
	// Enable FIFO & 8 bit data transmissio (1 stop bit, no parity).
	mmio_write(UART0_LCRH, (1 << 4) | (1 << 5) | (1 << 6));
 
	// Mask all interrupts. ?
	mmio_write(UART0_IMSC, (1 << 1) | (1 << 4) | (1 << 5) |
		   (1 << 6) | (1 << 7) | (1 << 8) |
		   (1 << 9) | (1 << 10));
 
	// Enable UART0, receive & transfer part of UART.
	mmio_write(UART0_CR, (1 << 0) | (1 << 8) | (1 << 9));
}

/*
 * Transmit a byte via UART0.
 * uint8_t Byte: byte to send.
 */
void uart_putc(char byte) {
	// wait for UART to become ready to transmit
	/* while (1) { */
	/* 	if (!(mmio_read(UART0_FR) & (1 << 5))) { */
	/* 		break; */
	/* 	} */
	/* } */
	mmio_write(UART0ADDR, byte);
}
 
/*
 * print a string to the UART one character at a time
 * const char *str: 0-terminated string
 */
void uart_puts(char *str) {
	while (*str) {
		uart_putc(*str++);
	}
}
 
	
