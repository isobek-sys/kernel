.text
.global loader						# making entry point visible to linker

# setting up the Multiboot header - see GRUB docs for details
.set FLAGS, 0x0						# this is the Muliboot 'flag' field
.set MAGIC, 0x1BADB002				# 'magic number' lets bootloader find the header
.set CHECKSUM, -(MAGIC + FLAGS)		# checksum required

.align 4							# выравнивание последующих данных по 4 байта
.long MAGIC
.long FLAGS
.long CHECKSUM

# reserve initial kernel stack space
.set STACKSIZE, 0x4000				# setting up stack size, that is, 16k (16384 bytes)
.lcomm stack, STACKSIZE				# reserve 16k stack
.comm mbd, 4						# we will use this in kmain
.comm magic, 4						# we will use this in kmain

loader:
	movl $(stack + STACKSIZE), %esp	# set up the stack, сохранение верхушки стека 
									# в регистре esp
	movl %eax, magic				# save eax to magic (Multiboot magic number)
	movl %ebx, mbd					# save ebx to mbd (Multiboot data structure)
	call main						# call C code
	cli

hang:
	hlt								# halt machine should kernel return
	jmp hang
