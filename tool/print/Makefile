print.bin: print.elf
	arm-none-eabi-objcopy -O binary print.elf print.bin

print.elf: print.ld print.o
	arm-none-eabi-ld -T print.ld print.o -o print.elf

print.o: print.s
	arm-none-eabi-as -mcpu=arm1176jzf-s print.s -o print.o

clean:
	rm -f print.bin print.elf print.o