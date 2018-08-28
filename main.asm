#############################################################################################
#
# Montek Singh
# COMP 541 Final Projects
# Apr 12, 2017
#
# This is a MIPS program that tests the MIPS processor and the VGA display,
# using a very simple animation.
#
# This program assumes the memory-IO map introduced in class specifically for the final
# projects.  In MARS, please select:  Settings ==> Memory Configuration ==> Default.
#
# NOTE:  MEMORY SIZES.
#
# Instruction memory:  This program has 103 instructions.  So, make instruction memory
# have a size of 128 locations.
#
# Data memory:  Make data memory 64 locations.  This program only uses two locations for data,
# and a handful more for the stack.  Top of the stack is set at the word address
# [0x100100fc - 0x100100ff], giving a total of 64 locations for data and stack together.
# If you need larger data memory than 64 words, you will have to move the top of the stack
# to a higher address.
#
#############################################################################################
#
# THIS VERSION HAS LONG PAUSES:  Suitable for board deployment, NOT for Vivado simulation
#
#############################################################################################


.data 0x10010000 			# Start of data memory
a_sqr:	.space 4
a:	.word 3
portals:.word 917,32,814,40,1162,50,205,775,95,82,166,167,374,185,386,149,960,148,1205,204,765,373,804,429,1524,556,737,590,387,736,392,815,1746,391,1687,420,721,450,1010,449,965,727,445,726,805,624,1804,415,1416,444,799,921,1686,760,1210,722,800,1417,1805,1470,1254,1157,1255,1156
portals_x: .word 4,14,4,34,5,34,34,15,4,4,14,13,14,23,13,8,12,14,14,29,22,24,23,24,28,39,29,34,33,9,35,14,13,35,14,34,15,18,14,20,24,19,23,10,29,25,9,34,9,38,18,19,19,33,19,34,39,20,39,35,29,29,28,30
portals_y: .word 3,28,4,5,4,13,4,4,8,9,3,4,4,3,3,19,4,29,5,19,4,14,5,15,4,15,4,3,4,18,4,13,14,23,14,23,14,19,15,24,13,24,14,19,5,14,19,25,20,14,24,20,19,24,18,14,13,19,14,24,18,20,19,19
.text 0x00400000			# Start of instruction memory
main:
	lui	$sp, 0x1001		# Initialize stack pointer to the 64th location above start of data
	ori 	$sp, $sp, 0x0100	# top of the stack is the word at address [0x100100fc - 0x100100ff]
	
	

	###############################################
	# ANIMATE character on screen                 #
	#                                             #
	# To eliminate pauses (for Vivado simulation) #
	# replace the two "jal pause" instructions    #
	# by nops.                                    #
	###############################################

	
	li	$a1, 23			# initialize to middle screen col (X=20)
	li	$a2, 4			# initialize to middle screen row (Y=15)
	
animate_loop:	
	jal	getChar_atXY
	bne	$v0, $0, not_portal
	li	$t3, 0			# t3=t0*t1, remain for comparing
	add	$t0, $a1, $a2		# t0=i
	addi	$t1, $t0, 1		#
	
multiply:
	add	$t3, $t3, $t1
	addi	$t0, $t0, -1
	bne	$t0, $0, multiply
	
check_portal:
	sll	$t1, $t0, 2		# t1=i
	lw	$t2, portals($t1)	# t2=portals[i]
	sub	$t2, $t2, $a1
	add	$t2, $t2, $t2
	addi	$t0, $t0, 1
	bne	$t2, $t3, check_portal
	
	lw	$a1, portals_x($t1)
	lw	$a2, portals_y($t1)
	li	$a0, 4
	jal	putChar_atXY
	j	draw_back_tell	
not_portal:
	bne	$v0, 2, not_goal
	li	$a0, 6
	jal	putChar_atXY
	j	end
not_goal:
	li	$a0, 1			# draw character 1 here
	jal	putChar_atXY 		# $a0 is char, $a1 is X, $a2 is Y
	
draw_back_tell:
	bne	$t8, $a1, draw_back
	beq	$t9, $a2, pause1

draw_back:				# draw back previous position
	add	$t6, $a1, $0
	add	$t7, $a2, $0
	add	$a1, $t8, $0
	add	$a2, $t9, $0
	jal	getChar_atXY
	bne	$v0, 4, not_portalc
	li	$a0, 0
	jal	putChar_atXY
	j	pause1
not_portalc:
	li	$a0, 3
	jal	putChar_atXY
pause1:	
	add	$a1, $t6, $0
	add	$a2, $t7, $0
	li	$a0, 25			# pause for 1/4 second
	jal	pause

	
key_loop:	
	jal 	get_key			# get a key (if available)
	beq	$v0, $0, key_loop	# 0 means no valid key
	add	$t8, $a1, $0
	add	$t9, $a2, $0
	
key1:
	bne	$v0, 1, key2
	addi	$a1, $a1, -1 		# move left
	jal	getChar_atXY
	bne	$v0, 5, not_wall1
	addi	$a1, $a1, 1
	j	animate_loop
not_wall1:
	slt	$1, $a1, $0		# make sure X >= 0
	beq	$1, $0, animate_loop
	li	$a1, 0			# else, set X to 0
	j	animate_loop

key2:
	bne	$v0, 2, key3
	addi	$a1, $a1, 1 		# move right
	jal	getChar_atXY
	bne	$v0, 5, not_wall2
	addi	$a1, $a1, -1
	j	animate_loop
not_wall2:
	slti	$1, $a1, 40		# make sure X < 40
	bne	$1, $0, animate_loop
	li	$a1, 39			# else, set X to 39
	j	animate_loop

key3:
	bne	$v0, 3, key4
	addi	$a2, $a2, -1 		# move up
	jal	getChar_atXY
	bne	$v0, 5, not_wall3
	addi	$a2, $a2, 1
	j	animate_loop
not_wall3:
	slt	$1, $a2, $0		# make sure Y >= 0
	beq	$1, $0, animate_loop
	li	$a2, 0			# else, set Y to 0
	j	animate_loop

key4:
	bne	$v0, 4, key_loop	# read key again
	addi	$a2, $a2, 1 		# move down
	jal	getChar_atXY
	bne	$v0, 5, not_wall4
	addi	$a2, $a2, -1
	j	animate_loop
not_wall4:
	slti	$1, $a2, 30		# make sure Y < 30
	bne	$1, $0, animate_loop
	li	$a2, 29			# else, set Y to 29
	j	animate_loop
		
	###############################
	# END using infinite loop     #
	###############################
	
				# program won't reach here, but have it for safety
end:
	j	end          	# infinite loop "trap" because we don't have syscalls to exit


######## END OF MAIN #################################################################################



.include "procs_board.asm"
