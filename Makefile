#* ************************************************************************** *#
#*                                                                            *#
#*                                                        :::      ::::::::   *#
#*   Makefile                                           :+:      :+:    :+:   *#
#*                                                    +:+ +:+         +:+     *#
#*   By: blukasho <bodik1w@gmail.com>               +#+  +:+       +#+        *#
#*                                                +#+#+#+#+#+   +#+           *#
#*   Created: 2020/04/06 18:38:14 by blukasho          #+#    #+#             *#
#*   Updated: 2020/04/06 20:25:23 by blukasho         ###   ########.fr       *#
#*                                                                            *#
#* ************************************************************************** *#

# general parameters 

OBJ_DIR = obj/

BIN_NAME = kernel.bin

GCC = gcc

# kernel parameters

SRCS_KERNEL = kernel.c printf.c

SRCS_KERNEL_DIR = srcs/kernel/

OBJ_KERNEL = $(addprefix $(OBJ_DIR), $(SRCS_KERNEL:.c=.o))

GCC_KERNEL_FLAGS = -Iinclude -m32 -nostdlib # -nostdlib not search std lib for linking, -nostinc not search header file in standart dirs

# asm parameters

SRCS_ASM = loader.s

SRCS_ASM_DIR = srcs/loader/

OBJ_ASM = $(addprefix $(OBJ_DIR), $(SRCS_ASM:.s=.o))

# linker parameters

SRCS_LINKER = linker.ld

SRCS_LINKER_DIR = srcs/linker/

# hdd.img parameters, need sudo rules

HDD_IMG = hdd.img

UNITS = M

HDD_SIZE = 10 #units M

START_SECTOR = 4096

END_SECTOR = 20479

SIZE_SECTOR = 512

FILE_SYSTEM = fat32 # file system inside hdd.img

DEV_LOOP0 = /dev/loop20 # block devise for img mounting 

DEV_LOOP1 = /dev/loop21 # block devise for part mounting 

DEV_NULL = /dev/null # null devise

#DEV_NULL = /dev/stdout # if need see debug info comment 63 line and uncommen 65

LABEL = msdos

TEMP_FOLDER = /mnt/tmp_hdd_img/

GRUB_FOLDER = ./boot

# general rules

all: $(BIN_NAME)

$(HDD_IMG): image

image: $(BIN_NAME)
	$(info Creating $(HDD_IMG))
	@dd if=/dev/zero of=./$(HDD_IMG) bs=1$(UNITS) count=$(HDD_SIZE) status=progress 2>$(DEV_NULL)
	$(info Mount $(HDD_IMG) to $(DEV_LOOP0))
	@losetup $(DEV_LOOP0) ./$(HDD_IMG)
	$(info Creating $(LABEL) label inside $(HDD_IMG))
	@parted $(DEV_LOOP0) mklabel $(LABEL) 2>$(DEV_NULL)
	$(info Creating $(FILE_SYSTEM) part, size $(HDD_SIZE) inside $(HDD_IMG))
	@parted $(DEV_LOOP0) mkpart primary $(FILE_SYSTEM) 2M $(HDD_SIZE) 2>$(DEV_NULL)
	$(info Set boot first part in $(HDD_IMG))
	@parted $(DEV_LOOP0) set 1 boot on 2>$(DEV_NULL)
	@losetup $(DEV_LOOP1) $(HDD_IMG) --offset `echo \`fdisk -l $(DEV_LOOP0) | sed -n 9p | awk '{print $$3}'\`*512 | bc` --sizelimit `echo \`fdisk -l $(DEV_LOOP0) | sed -n 9p | awk '{print $$4}'\`*512 | bc`
	$(info Umount $(DEV_LOOP0))
	@losetup -d $(DEV_LOOP0)
	$(info Creating $(FILE_SYSTEM) structure in part)
	@mkfs.vfat -F 32 $(DEV_LOOP1) 2>$(DEV_NULL)
	$(info Creating mount folder $(TEMP_FOLDER))
	@mkdir $(TEMP_FOLDER)
	$(info Mount $(DEV_LOOP1) to $(TEMP_FOLDER))
	@mount -o loop $(DEV_LOOP1) $(TEMP_FOLDER)
	$(info Copy files to image)	
	@cp -rvf $(GRUB_FOLDER) $(BIN_NAME) -t $(TEMP_FOLDER)
	$(info Install grub MBR to $(DEV_LOOP1))
	@echo "device (hd0) $(HDD_IMG)\n \
		root (hd0,0)\n \
		setup (hd0)\n \
		quit\n" | grub --batch
	$(info Umount $(DEV_LOOP1) from $(TEMP_FOLDER))
	@umount $(TEMP_FOLDER)
	$(info Remove $(TEMP_FOLDER))
	@rm -rf $(TEMP_FOLDER)
	$(info Umount $(DEV_LOOP1) from block device)
	@losetup -d $(DEV_LOOP1)

run: $(OBJ_DIR) $(BIN_NAME) $(HDD_IMG)
	@qemu-system-i386 -hda $(HDD_IMG)

$(BIN_NAME): $(OBJ_DIR) $(OBJ_KERNEL) $(OBJ_ASM)
	$(info Linked $(OBJ_KERNEL) to $(BIN_NAME))
	@cd $(OBJ_DIR) && ld -m elf_i386 -T ../$(SRCS_LINKER_DIR)$(SRCS_LINKER) -o ../$(BIN_NAME) *.o

$(OBJ_DIR):
	@mkdir $(OBJ_DIR)

$(OBJ_DIR)%.o: $(SRCS_KERNEL_DIR)%.c
	$(info Compile $< to $@)
	@$(GCC) $(GCC_KERNEL_FLAGS) -o $@ -c $<

$(OBJ_DIR)%.o: $(SRCS_ASM_DIR)%.s
	$(info Compile $< to $@)
	@as --32 -o $@ $<

clean:
	@rm -rf $(OBJ_DIR)

fclean: clean
	@rm -rf $(BIN_NAME)
	@rm -rf $(HDD_IMG)
	

force_fclean: fclean
	@umount $(TEMP_FOLDER) 2>$(DEV_NULL)
	@rm -rf $(TEMP_FOLDER) 2>$(DEV_NULL)
	@losetup -d $(DEV_LOOP0) $(DEV_LOOP1) 2>$(DEV_NULL)

re: fclean all

.PHONY: all clean fclean re force_fclean image
