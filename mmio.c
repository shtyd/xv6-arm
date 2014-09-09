//mmio.c access to MMI/O registers

// write to MMIO register
inline void mmio_write(unsigned int reg, unsigned int data) {
	unsigned int *ptr = (unsigned int *)reg;
	asm volatile("str %[data], [%[reg]]"
		     : : [reg]"r"(ptr), [data]"r"(data));
}
 
// read from MMIO register
inline unsigned int mmio_read(unsigned int reg) {
	unsigned int *ptr = (unsigned int *)reg;
	unsigned int data;
	asm volatile("ldr %[data], [%[reg]]"
		     : [data]"=r"(data) : [reg]"r"(ptr));
	return data;
}
