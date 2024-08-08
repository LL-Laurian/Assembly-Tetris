#####################################################################
# CSCB58 Summer 2024 Assembly Final Project - UTSC
# Student1: Name, Student Number, UTorID, official email
# Student2: Name, Student Number, UTorID, official email
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed) 
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved features have been implemented?
# (See the assignment handout for the list of features)
# Easy Features:
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# ... (add more if necessary)
# Hard Features:
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# ... (add more if necessary)
# How to play:
# (Include any instructions)
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

##############################################################################

    .data
##############################################################################
string: .asciiz "right loop is ran\n"
counter: .asciiz "current counter is "
newline: .asciiz "\n"
numbers: .word 0, 0, 0, 0    # Create an array with 4 numbers
row_to_delete: .word 0    # Create an array with 4 numbers
max_row: .word 30
timer_base: .word 0x10000000  # Example base address for sound timer
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Tetris game.
main:
    lw $t0, ADDR_DSPL      # Load the base address of the display into $t0
    jal init_walls_board   # Call the subroutine to initialize the walls and board

start:
    lw $t0, ADDR_DSPL
    
    jal random_shape
    
    addi $t6, $t0, 64      # intially set t6 to be in the middle
    li $t3, 16             # $t3 is x index of the left-most grid; intially 16
    j init_shape
##############################################################################  

##########################################################
init_shape: 
   li $t1, 1  
   beq $t1, 0, U_shape
   beq $t1, 1, I_shape
   beq $t1, 2, S_shape
   beq $t1, 3, Z_shape
   beq $t1, 4, L_shape
   beq $t1, 5, J_shape
   
   li $a0, 0x8D6E99
   subi $sp, $sp, 16
   
   addi $t9, $t6, 0
   sw $t9, 0($sp)
   
   addi $t9, $t6, 4
   sw $t9, 4($sp)
   
   addi $t9, $t6, 132
   sw $t9, 8($sp)
   
   addi $t9, $t6, 8
   sw $t9, 12($sp)
   j init_shape_done
   
    
U_shape:
    li $a0, 0xD9A867
    subi $sp, $sp, 16
   
    addi $t9, $t6, 0
    sw $t9, 0($sp)
   
    addi $t9, $t6, 128
    sw $t9, 4($sp)
   
    addi $t9, $t6, 4
    sw $t9, 8($sp)
   
    addi $t9, $t6, 132
    sw $t9, 12($sp)
    j init_shape_done 
       
I_shape:
    li $a0, 0x003D6B
    subi $sp, $sp, 16
   
    addi $t9, $t6, 0
    sw $t9, 0($sp)
   
    addi $t9, $t6, 128
    sw $t9, 4($sp)
   
    addi $t9, $t6, 256
    sw $t9, 8($sp)
   
    addi $t9, $t6, 384
    sw $t9, 12($sp)
    j init_shape_done
    
S_shape:
    li $a0, 0xB26666
    subi $sp, $sp, 16
   
    addi $t9, $t6, 128
    sw $t9, 0($sp)
   
    addi $t9, $t6, 4
    sw $t9, 4($sp)
   
    addi $t9, $t6, 8
    sw $t9, 8($sp)
   
   addi $t9, $t6, 132
   sw $t9, 12($sp)
   j init_shape_done
   
    
Z_shape:
   li $a0, 0x7C8A73
   
   subi $sp, $sp, 16
   
   addi $t9, $t6, 0
   sw $t9, 0($sp)
   
   addi $t9, $t6, 4
   sw $t9, 4($sp)
   
   addi $t9, $t6, 132
   sw $t9, 8($sp)
   
   addi $t9, $t6, 136
   sw $t9, 12($sp)
   j init_shape_done
      
       
L_shape:
   li $a0, 0xC97A53
   subi $sp, $sp, 16
   
   addi $t9, $t6, 0
   sw $t9, 0($sp)
   
   addi $t9, $t6, 128
   sw $t9, 4($sp)
   
   addi $t9, $t6, 256
   sw $t9, 8($sp)
   
   addi $t9, $t6, 260
   sw $t9, 12($sp)
   j init_shape_done
   
J_shape:
   li $a0, 0xE26B8A
   subi $sp, $sp, 16
   
   addi $t9, $t6, 256
   sw $t9, 0($sp)
   
   addi $t9, $t6, 4
   sw $t9, 4($sp)
   
   addi $t9, $t6, 132
   sw $t9, 8($sp)
   
   addi $t9, $t6, 260
   sw $t9, 12($sp)

init_shape_done:
   jal fill_color
   li $a2, 400

   #######################################################
   ###############################################################################
speed:
    	li 		$v0, 32
	move 		$a0, $a2
	syscall


keyboard:
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
    b Auto_drop

keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x71, Terminate        # Check if the key q was pressed
    beq $a0, 0x77, respond_to_W     # Check if the key w was pressed
    beq $a0, 0x61, respond_to_A     # Check if the key a was pressed
    beq $a0, 0x64, respond_to_D
    beq $a0, 0x73, respond_to_S

    b keyboard

respond_to_A:
    li $t9, 0x8A8F9A       # wall
    li $t5, 0xE4DCD1       # grey color
    li $t7, 0xC5CCD6       # white color
    lw $a1, 0($sp)
    lw $s0, 0($sp)
    lw $s4, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    li $t2, 1
    
check_left_obstacle:
    beq $t2, 4, left_movement_update    
    subi $s1, $a1, 4
    bne $s1, $s0, check_second_left
    j check_left_obstacle_update
    
check_second_left:
    bne $s1, $s4, check_third_left
    j check_left_obstacle_update
    
check_third_left:
    bne $s1, $s2, check_fourth_left
    j check_left_obstacle_update
    
check_fourth_left:
    bne $s1, $s3, check_left_color
    j check_left_obstacle_update
    
check_left_color:                    
    lw $t4, 0($s1)
    bne $t4, $t5, left_move_further_check
    j check_left_obstacle_update
    
left_move_further_check:   
    bne $t4, $t7, Auto_drop    # check left most touches the wall

check_left_obstacle_update:
    mul $s1, $t2, 4
    add $a1, $sp, $s1
    addi $t2, $t2, 1
    lw $a1, 0($a1)
    j check_left_obstacle   

left_movement_update:    
    lw $s0, 0($sp)      # Store address at 0($sp)
    lw $t3, 0($s0)      # store color
    subi $s0, $s0, 4    # move left
    
    lw $s4, 4($sp)      # move left
    subi $s4, $s4, 4     # Store address at 4($sp)
    
    lw $s2, 8($sp)      # Store address at 8($sp)
    subi $s2, $s2, 4    # move left
    
    lw $s3, 12($sp)     # Store address at 12($sp)
    subi $s3, $s3, 4    # move left
   
    j keyboard_update

respond_to_D:
    li $t9, 0x8A8F9A       # wall
    li $t5, 0xE4DCD1       # grey color
    li $t7, 0xC5CCD6       # white color
    lw $a1, 12($sp)
    lw $s0, 0($sp)
    lw $s4, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    li $t2, 2
    
check_right_obstacle:
    beq $t2, -1, right_movement_update    
    addi $s1, $a1, 4
    bne $s1, $s0, check_second_right
    j check_right_obstacle_update
    
check_second_right:
    bne $s1, $s4, check_third_right
    j check_right_obstacle_update
    
check_third_right:
    bne $s1, $s2, check_fourth_right
    j check_right_obstacle_update
    
check_fourth_right:
    bne $s1, $s3, check_right_color
    j check_right_obstacle_update
    
check_right_color:                    
    lw $t4, 0($s1)
    bne $t4, $t5, right_move_further_check
    j check_right_obstacle_update
    
right_move_further_check:   
    bne $t4, $t7, Auto_drop    # check left most touches the wall

check_right_obstacle_update:
    mul $s1, $t2, 4
    add $a1, $sp, $s1
    subi $t2, $t2, 1
    lw $a1, 0($a1)
    j check_right_obstacle   

right_movement_update:  
    lw $s0, 0($sp)      # Store address at 0($sp)
    lw $t3, 0($s0)      # store color
    addi $s0, $s0, 4    # move left
    
    lw $s4, 4($sp)      # move left
    addi $s4, $s4, 4     # Store address at 4($sp)
    
    lw $s2, 8($sp)      # Store address at 8($sp)
    addi $s2, $s2, 4    # move left
    
    lw $s3, 12($sp)     # Store address at 12($sp)
    addi $s3, $s3, 4    # move left
    
    j keyboard_update
    
respond_to_W:
    li $t3, 0xD9A867 #U-shape
    lw $a1, 0($sp)
    lw $t4, 0($a1)
    beq $t4, $t3, speed

    li $t3, 0x003D6B  #I-shape
    beq $t4, $t3, I_shape_rot

    li $t3, 0xB26666  #S-shape
    beq $t4, $t3, S_shape_rot
 
    li $t3, 0x7C8A73  #Z-shape
    beq $t4, $t3, Z_shape_rot
    
    li $t3, 0xC97A53  #L-shape
    beq $t4, $t3, L_shape_rot
    
    li $t3, 0xE26B8A  #J-shape
    beq $t4, $t3, J_shape_rot
    
    li $t3, 0x8D6E99
    j T_shape_rot

respond_to_S:
    addi $a2, $a2, -100
    bge $a2, 100, Auto_drop
    addi $a2, $a2, 100
    j Auto_drop
    
Terminate:
    li $v0, 10             # Terminate the program gracefully
    syscall    

###################################
#ROTATION
I_shape_rot:
    li $t9, 0x8A8F9A       # wall
    lw $a1, 0($sp)
    addi $s1, $a1, 128
    lw $t4, 0($s1)
    beq $t4, $t3, I_pos_1
    j I_pos_2
    
I_pos_1:    
    addi $s1, $a1, 12
    lw $t4, 0($s1)
    beq $t4, $t9, Auto_drop    # check right most touches the wall
   
    
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s4, $s0, 4
    addi $s2, $s0, 8    
    addi $s3, $s0, 12    
    j keyboard_update               
                              
I_pos_2:    
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s4, $s0, 128
    addi $s2, $s0, 256    
    addi $s3, $s0, 384   
    j keyboard_update
    
######################################

S_shape_rot:
    li $t9, 0x8A8F9A       # wall
    lw $a1, 0($sp)
    addi $s1, $a1, 128
    lw $t4, 0($s1)
    beq $t4, $t3, S_pos_2
    
S_pos_1:    
    lw $s0, 0($sp)      # Store address at 0($sp)
    subi $s0, $s0, 128
    addi $s4, $s0, 128
    addi $s2, $s0, 132    
    addi $s3, $s0, 260    
    j keyboard_update               
                              
S_pos_2:    
    addi $s1, $a1, 8
    lw $t4, 0($s1)
    beq $t4, $t9, Auto_drop    # check right most touches the wall
    
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s0, $s0, 128
    subi $s4, $s0, 124
    addi $s2, $s0, 4    
    subi $s3, $s0, 120   
    j keyboard_update
    
######################################### 
Z_shape_rot:
    li $t9, 0x8A8F9A       # wall
    lw $a1, 0($sp)
    addi $s1, $a1, 128
    lw $t4, 0($s1)
    beq $t4, $t3, Z_pos_2
    
Z_pos_1:    
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s0, $s0, 128
    addi $s4, $s0, 128
    subi $s2, $s0, 124    
    addi $s3, $s0, 4    
    j keyboard_update               
                              
Z_pos_2:    
    addi $s1, $a1, 8
    lw $t4, 0($s1)
    beq $t4, $t9, Auto_drop    # check right most touches the wall
    
    lw $s0, 0($sp)      # Store address at 0($sp)
    subi $s0, $s0, 128
    addi $s4, $s0, 4
    addi $s2, $s0, 132    
    addi $s3, $s0, 136   
    j keyboard_update
    
##########################################

L_shape_rot:
    li $t9, 0x8A8F9A       # wall
    lw $a1, 0($sp)
    addi $s1, $a1, 128     # check if below is still part of tetris
    lw $t4, 0($s1)
    beq $t4, $t3, L_pos_1_2
    
    addi $s1, $a1, 132     # check if below is still part of tetris
    lw $t4, 0($s1)
    beq $t4, $t3, L_pos_3
    j L_pos_4
    
L_pos_1_2:
    addi $s1, $a1, 4     # check if right is still part of tetris
    lw $t4, 0($s1)
    beq $t4, $t3, L_pos_2
    j L_pos_1
    
L_pos_1:
    addi $s1, $a1, 8
    lw $t4, 0($s1)
    beq $t4, $t9, Auto_drop    # check right most touches the wall
        
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s4, $s0, 128
    addi $s2, $s0, 4    
    addi $s3, $s0, 8    
    j keyboard_update               
                              
L_pos_2:   
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s4, $s0, 4
    addi $s2, $s0, 132    
    addi $s3, $s0, 260   
    j keyboard_update
        
L_pos_3:
    addi $s1, $a1, 8
    lw $t4, 0($s1)
    beq $t4, $t9, Auto_drop    # check right most touches the wall
        
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s0, $s0, 128
    addi $s4, $s0, 4
    subi $s2, $s0, 120    
    addi $s3, $s0, 8    
    j keyboard_update 
    
L_pos_4:   
    lw $s0, 0($sp)      # Store address at 0($sp)
    subi $s0, $s0, 128
    addi $s4, $s0, 128
    addi $s2, $s0, 256    
    addi $s3, $s0, 260   
    j keyboard_update          

##########################################

J_shape_rot:
    li $t9, 0x8A8F9A       # wall
    lw $a1, 0($sp)
    addi $s1, $a1, 128     # check if below is still part of tetris
    lw $t4, 0($s1)
    beq $t4, $t3, J_pos_2_3
    
    addi $s1, $a1, 136     # check if below is still part of tetris
    lw $t4, 0($s1)
    beq $t4, $t3, J_pos_4
    j J_pos_1
    
J_pos_2_3:
    addi $s1, $a1, 4     # check if right is still part of tetris
    lw $t4, 0($s1)
    beq $t4, $t3, J_pos_3
    j J_pos_2
    
J_pos_1:
    addi $s1, $a1, 8
    lw $t4, 0($s1)
    beq $t4, $t9, Auto_drop    # check right most touches the wall
        
    lw $s0, 0($sp)      # Store address at 0($sp)
    subi $s0, $s0, 256
    addi $s4, $s0, 128
    addi $s2, $s0, 132    
    addi $s3, $s0, 136    
    j keyboard_update               
                              
J_pos_2:   
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s4, $s0, 128
    addi $s2, $s0, 256    
    addi $s3, $s0, 4   
    j keyboard_update
        
J_pos_3:
    addi $s1, $a1, 8
    lw $t4, 0($s1)
    beq $t4, $t9, Auto_drop    # check right most touches the wall
        
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s4, $s0, 4
    addi $s2, $s0, 8    
    addi $s3, $s0, 136    
    j keyboard_update 
    
J_pos_4:   
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s0, $s0, 256
    subi $s4, $s0, 252
    subi $s2, $s0, 124    
    addi $s3, $s0, 4   
    j keyboard_update   
    
##########################################

T_shape_rot:
    li $t9, 0x8A8F9A       # wall
    lw $a1, 0($sp)
    addi $s1, $a1, 132     # check if right down is still part of tetris
    lw $t4, 0($s1)
    bne $t4, $t3, T_pos_3
    
    addi $s1, $a1, 4     # check if below is still part of tetris
    lw $t4, 0($s1)
    bne $t4, $t3, T_pos_4
    
    addi $s1, $a1, 8     # check if right is still part of tetris
    lw $t4, 0($s1)
    beq $t4, $t3, T_pos_1
    j T_pos_2
    
T_pos_1:
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s0, $s0, 128
    subi $s4, $s0, 124
    addi $s2, $s0, 4    
    addi $s3, $s0, 132 
    j keyboard_update               
                              
T_pos_2:
    addi $s1, $a1, 8
    lw $t4, 0($s1)
    beq $t4, $t9, Auto_drop    # check right most touches the wall
       
    lw $s0, 0($sp)      # Store address at 0($sp)
    subi $s4, $s0, 124
    addi $s2, $s0, 4    
    addi $s3, $s0, 8   
    j keyboard_update
        
T_pos_3:     
    lw $s0, 0($sp)      # Store address at 0($sp)
    subi $s0, $s0, 128
    addi $s4, $s0, 128
    addi $s2, $s0, 256    
    addi $s3, $s0, 132    
    j keyboard_update 
    
T_pos_4:
    addi $s1, $a1, 8
    lw $t4, 0($s1)
    beq $t4, $t9, Auto_drop    # check right most touches the wall  
     
    lw $s0, 0($sp)      # Store address at 0($sp)
    addi $s4, $s0, 4
    addi $s2, $s0, 132    
    addi $s3, $s0, 8   
    j keyboard_update      

#########################################        
keyboard_update:  
    jal delete_shape
    
    subi $sp, $sp, 16   # Allocate 16 bytes on the stack
    sw $s0, 0($sp)      
    sw $s4, 4($sp)      
    sw $s2, 8($sp)      
    sw $s3, 12($sp)     
    move $a0, $t3
    jal fill_color
    
 #############################################   
Auto_drop:
    li $t5, 0xE4DCD1       # grey color
    li $t7, 0xC5CCD6       # white color
    
    li $t3, 0xD9A867 #U-shape
    lw $a1, 0($sp)
    lw $t4, 0($a1)
    beq $t4, $t3, U_shape_drop

    li $t3, 0x003D6B  #I-shape
    beq $t4, $t3, I_shape_drop

    li $t3, 0xB26666  #S-shape
    beq $t4, $t3, S_shape_drop
 
    li $t3, 0x7C8A73  #Z-shape
    beq $t4, $t3, Z_shape_drop
    
    li $t3, 0xC97A53  #L-shape
    beq $t4, $t3, L_shape_drop
    
    li $t3, 0xE26B8A  #J-shape
    beq $t4, $t3, J_shape_drop
    
    li $t3, 0x8D6E99
    j T_shape_drop    
###############################################################################
#DROP/COLLISION

U_shape_drop:
    lw $v0, 4($sp)
    lw $v1, 12($sp)
    j base_2_drop                
#################################
    
I_shape_drop:
    lw $a1, 0($sp)
    addi $s1, $a1, 128
    lw $t4, 4($sp)
    beq $t4, $s1, I_pos_1_drop
    j I_pos_2_drop
    
I_pos_1_drop:    
    lw $v1, 12($sp)
    j base_1_drop 
                               
I_pos_2_drop:    
    lw $v0, 0($sp)
    lw $v1, 4($sp)
    lw $s5, 8($sp)
    lw $s6, 12($sp)
    j base_4_drop              

######################################

S_shape_drop:
    lw $a1, 0($sp)
    addi $s1, $a1, 128
    lw $t4, 4($sp)
    beq $t4, $s1, S_pos_2_drop
    
S_pos_1_drop:    
    lw $v0, 0($sp)      # Store address at 0($sp)
    lw $v1, 8($sp)      # Store address at 0($sp)              
    lw $s5, 12($sp)
    j base_3_drop              

                            
S_pos_2_drop:    
    lw $v0, 4($sp)      # Store address at 0($sp)
    lw $v1, 12($sp)      # Store address at 0($sp)              
    j base_2_drop  

######################################### 
Z_shape_drop:
    lw $a1, 0($sp)
    addi $s1, $a1, 128
    lw $t4, 4($sp)
    beq $t4, $s1, Z_pos_2_drop
    
Z_pos_1_drop:    
    lw $v0, 0($sp)      # Store address at 0($sp)
    lw $v1, 8($sp)      # Store address at 0($sp)              
    lw $s5, 12($sp)
    j base_3_drop              
   
                              
Z_pos_2_drop:    
    lw $v1, 4($sp)      # Store address at 0($sp)
    lw $v0, 12($sp)      # Store address at 0($sp)              
    j base_2_drop
    
##########################################

L_shape_drop:
    lw $a1, 0($sp)
    addi $s1, $a1, 128
    lw $t4, 4($sp)
    beq $t4, $s1, L_pos_1_2_drop
    
    addi $s1, $a1, 132     # check if below is still part of tetris
    lw $t4, 8($sp)
    beq $t4, $s1, L_pos_3_drop
    j L_pos_4_drop
    
L_pos_1_2_drop:
    addi $s1, $a1, 4     # check if right is still part of tetris
    lw $t4, 8($sp)
    beq $t4, $s1, L_pos_2_drop
    j L_pos_1_drop
    
L_pos_1_drop:
    lw $v0, 8($sp)      # Store address at 0($sp)
    lw $v1, 12($sp)      # Store address at 0($sp)              
    j base_2_drop              
             
                      
L_pos_2_drop:   
    lw $v0, 4($sp)      # Store address at 0($sp)
    lw $v1, 8($sp)      # Store address at 0($sp) 
    lw $s5, 12($sp)      # Store address at 0($sp)                
    j base_3_drop              
 
L_pos_3_drop:
    lw $v0, 0($sp)      # Store address at 0($sp)
    lw $v1, 4($sp)      # Store address at 0($sp)              
    j base_2_drop              


L_pos_4_drop:   
    lw $v0, 0($sp)      # Store address at 0($sp)
    lw $v1, 4($sp)      # Store address at 0($sp) 
    lw $s5, 8($sp)      # Store address at 0($sp)                
    j base_3_drop              

     
##########################################

J_shape_drop:
    lw $a1, 0($sp)
    addi $s1, $a1, 128     # check if below is still part of tetris
    lw $t4, 4($sp)
    beq $t4, $s1, J_pos_2_3_drop
    
    addi $s1, $a1, 136     # check if below is still part of tetris
    lw $t4, 12($sp)
    beq $t4, $s1, J_pos_4_drop
    j J_pos_1_drop
    
J_pos_2_3_drop:
    addi $s1, $a1, 4     # check if right is still part of tetris
    lw $t4, 12($sp)
    beq $t4, $s1, J_pos_3_drop
    j J_pos_2_drop
    
J_pos_1_drop:
    lw $v0, 0($sp)      # Store address at 0($sp)
    lw $v1, 12($sp)      # Store address at 0($sp)              
    j base_2_drop              

                              
J_pos_2_drop:   
    lw $v0, 4($sp)      # Store address at 0($sp)
    lw $v1, 8($sp)      # Store address at 0($sp) 
    lw $s5, 12($sp)      # Store address at 0($sp)                
    j base_3_drop              
    
J_pos_3_drop:
    lw $v0, 8($sp)      # Store address at 0($sp)
    lw $v1, 12($sp)      # Store address at 0($sp)              
    j base_2_drop              

J_pos_4_drop:   
    lw $v0, 0($sp)      # Store address at 0($sp)
    lw $v1, 4($sp)      # Store address at 0($sp) 
    lw $s5, 12($sp)      # Store address at 0($sp)                
    j base_3_drop              

    
##########################################

T_shape_drop:
    li $t9, 0x8A8F9A       # wall
    lw $a1, 0($sp)
    
    addi $s1, $a1, 128     # check if right is still part of tetris
    lw $t4, 4($sp)
    bne $t4, $s1, T_pos_4_drop
    
    addi $s1, $a1, 4     # check if right down is still part of tetris
    lw $t4, 4($sp)
    bne $t4, $s1, T_pos_1_drop
    
    addi $s1, $a1, 132     # check if right is still part of tetris
    lw $t4, 12($sp)
    beq $t4, $s1, T_pos_2_drop
    j T_pos_3_drop
    
T_pos_1_drop:
    lw $v0, 0($sp)      # Store address at 0($sp)
    lw $v1, 8($sp)      # Store address at 0($sp) 
    lw $s5, 12($sp)      # Store address at 0($sp)                
    j base_3_drop              
   
                            
T_pos_2_drop:
    lw $v0, 0($sp)      # Store address at 0($sp)
    lw $v1, 12($sp)      # Store address at 0($sp)              
    j base_2_drop              

      
T_pos_3_drop:     
    lw $v0, 0($sp)      # Store address at 0($sp)
    lw $v1, 8($sp)      # Store address at 0($sp) 
    lw $s5, 12($sp)      # Store address at 0($sp)                
    j base_3_drop              

    
T_pos_4_drop:
    lw $v0, 0($sp)      # Store address at 0($sp)
    lw $v1, 12($sp)      # Store address at 0($sp)              
    j base_2_drop              
          
########################################
base_1_drop:
    addi $v1, $v1, 128
    lw $t1, 0($v1)
    bne $t1, $t5, base_1_further_check1
    j base_1_update
    
base_1_further_check1:
    bne $t1, $t7, exit_drop 

base_1_update:
    lw $s0, 0($sp)      # Store address at 0($sp)
    lw $t3, 0($s0)      # store color
    addi $s0, $s0, 128    # move down
    
    lw $s4, 4($sp)      # move down
    addi $s4, $s4, 128     # Store address at 4($sp)
    
    lw $s2, 8($sp)      # Store address at 8($sp)
    addi $s2, $s2, 128    # move down
    
    lw $s3, 12($sp)     # Store address at 12($sp)
    addi $s3, $s3, 128    # move down
    
    jal delete_shape
    
    subi $sp, $sp, 16   # Allocate 16 bytes on the stack
    sw $s0, 0($sp)      
    sw $s4, 4($sp)      
    sw $s2, 8($sp)      
    sw $s3, 12($sp)  
    move $a0, $t3
    
    jal fill_color
    j speed
    
    
######################################
base_2_drop:
    addi $v1, $v1, 128
    addi $v0, $v0, 128
    lw $t1, 0($v1)
    lw $t2, 0($v0)
    bne $t1, $t5, base_2_further_check1
    j base_2_update
    
base_2_further_check1:
    bne $t1, $t7, exit_drop   
    bne $t2, $t5, base_2_further_check3
    j base_2_update
    
base_2_further_check3:    
    bne $t2, $t7, exit_drop
    
base_2_update:
    lw $s0, 0($sp)      # Store address at 0($sp)
    lw $t3, 0($s0)      # store color
    addi $s0, $s0, 128    # move down
    
    lw $s4, 4($sp)      # move down
    addi $s4, $s4, 128     # Store address at 4($sp)
    
    lw $s2, 8($sp)      # Store address at 8($sp)
    addi $s2, $s2, 128    # move down
    
    lw $s3, 12($sp)     # Store address at 12($sp)
    addi $s3, $s3, 128    # move down
    
    jal delete_shape
    
    
    subi $sp, $sp, 16   # Allocate 16 bytes on the stack
    sw $s0, 0($sp)      
    sw $s4, 4($sp)      
    sw $s2, 8($sp)      
    sw $s3, 12($sp)  
    move $a0, $t3
    
    jal fill_color
    j speed
    
                                                                                                                                                                                  
#########################################

base_3_drop:
    addi $v1, $v1, 128
    addi $v0, $v0, 128
    addi $s5, $s5, 128
    lw $t1, 0($v1)
    lw $t2, 0($v0)
    lw $t3, 0($s5)
    bne $t1, $t5, base_3_further_check1
    j base_3_further_check2
    
base_3_further_check1:
    bne $t1, $t7, exit_drop
    
base_3_further_check2:       
    bne $t2, $t5, base_3_further_check3
    j base_3_further_check4
    
base_3_further_check3:    
    bne $t2, $t7, exit_drop
    
base_3_further_check4:           
    bne $t3, $t5, base_3_further_check5
    j base_3_update
    
base_3_further_check5:    
    bne $t3, $t7, exit_drop
    
base_3_update:
    lw $s0, 0($sp)      # Store address at 0($sp)
    lw $t3, 0($s0)      # store color
    addi $s0, $s0, 128    # move down
    
    lw $s4, 4($sp)      # move down
    addi $s4, $s4, 128     # Store address at 4($sp)
    
    lw $s2, 8($sp)      # Store address at 8($sp)
    addi $s2, $s2, 128    # move down
    
    lw $s3, 12($sp)     # Store address at 12($sp)
    addi $s3, $s3, 128    # move down
    
    jal delete_shape
    
    
    subi $sp, $sp, 16   # Allocate 16 bytes on the stack
    sw $s0, 0($sp)      
    sw $s4, 4($sp)      
    sw $s2, 8($sp)      
    sw $s3, 12($sp)  
    move $a0, $t3
    
    jal fill_color
    j speed
                                                                                              
#########################################  
base_4_drop:
    addi $v1, $v1, 128
    addi $v0, $v0, 128
    addi $s5, $s5, 128
    addi $s6, $s6, 128
    lw $t1, 0($v1)
    lw $t2, 0($v0)
    lw $t3, 0($s5)
    lw $t4, 0($s6)
    bne $t1, $t5, base_4_further_check1
    j base_4_further_check2
    
base_4_further_check1:
    bne $t1, $t7, exit_drop
    
base_4_further_check2:       
    bne $t2, $t5, base_4_further_check3
    j base_4_further_check4
    
base_4_further_check3:    
    bne $t2, $t7, exit_drop
    
base_4_further_check4:           
    bne $t3, $t5, base_4_further_check5
    j base_4_further_check6
    
base_4_further_check5:    
    bne $t3, $t7, exit_drop
    
base_4_further_check6:           
    bne $t4, $t5, base_4_further_check7
    j base_4_update
    
base_4_further_check7:    
    bne $t4, $t7, exit_drop    
    
base_4_update:
    lw $s0, 0($sp)      # Store address at 0($sp)
    lw $t3, 0($s0)      # store color
    addi $s0, $s0, 128    # move down
    
    lw $s4, 4($sp)      # move down
    addi $s4, $s4, 128     # Store address at 4($sp)
    
    lw $s2, 8($sp)      # Store address at 8($sp)
    addi $s2, $s2, 128    # move down
    
    lw $s3, 12($sp)     # Store address at 12($sp)
    addi $s3, $s3, 128    # move down
    
    jal delete_shape
    
    
    subi $sp, $sp, 16   # Allocate 16 bytes on the stack
    sw $s0, 0($sp)      
    sw $s4, 4($sp)      
    sw $s2, 8($sp)      
    sw $s3, 12($sp)  
    move $a0, $t3
    
    jal fill_color
    j speed
    
exit_drop:
    jal calculate_row
    addi $sp, $sp, 16
    jal sorted_rows
    jal remove_duplicate
    la $s0, numbers
    addi $s0, $s0, 16
    la $s7, row_to_delete
    li $s3, 0
    
check_row_loop:
    beq $t4, 0, start   
    lw $a1, 0($sp)
    add $a1, $a1, $s3
    li $v0, 1
    move $a0, $a1
    syscall
    
    
    li $v0, 4
    la $a0, newline
    syscall
    
    jal Row_check
    addi $sp, $sp, 4
    subi $t4, $t4, 1
    la $s7, row_to_delete
    lw $a1, 0($s7)
    
    li $v0, 1
    move $a0, $a1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
                                                   
    beq $a1, -1, Terminate_program
    beq $a1, 0, check_row_loop
    jal Delete_row
    la $s7, row_to_delete
    la $s5, max_row
    lw $s4, 0($s5)
    addi $s4, $s4, 1
    lw $s4, 0($s5)
    
    addi $s3, $s3, 1
    li $a1, 0
    sw $a1, 0($s7)
    j check_row_loop

Terminate_program:
    la $s7, row_to_delete
    la $s5, max_row
    addi $s7, $s7, 4
    addi $s5, $s5, 4
    mul $t4, $t4, 4
    add $sp, $sp, $t4
    j Terminate         
    
    #li $v0, 10             # Terminate the program gracefully
    #syscall
    
##############################################################
#FUNCTION START HERE
##############################################################################
Delete_row:
    lw $t0, ADDR_DSPL
    li $t5, 0xE4DCD1       # grey color
    li $t7, 0xC5CCD6       # white color
    la $s5, max_row
    lw $s5, 0($s5)
    la $s7, row_to_delete
    lw $s7, 0($s7)
    
    #li $v0, 1
    #move $a0, $s5
    #syscall
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    #li $v0, 1
    #move $a0, $s7
    #syscall
    
    mul $t6, $s7, 128
    addi $t6, $t6, 12
    add $t6, $t0, $t6
    
    addi $t8, $t6, 100

Delete_row_outer_loop:
    bgt $s5, $s7, exit_delete_row
    
Delete_row_inner_loop:        
    subi $t9, $t6, 128
    lw $t9, 0($t9)
    bgt $t6, $t8, exit_delete_row_inner_loop
    beq $t9, $t5, color_white
    beq $t9, $t7, color_grey
    sw $t9, 0($t6)
    j delete_row_inner_update
color_white:
    sw $t7, 0($t6)
    j delete_row_inner_update
color_grey:
    sw $t5, 0($t6)    
delete_row_inner_update:
    addi $t6, $t6, 4
    j Delete_row_inner_loop
    
exit_delete_row_inner_loop:
    subi $s7, $s7, 1
    mul $t6, $s7, 128
    addi $t6, $t6, 12
    add $t6, $t0, $t6
    
    addi $t8, $t6, 100
    j Delete_row_outer_loop
    
exit_delete_row:
    jr $ra                        
#########################################
Row_check:
    lw $t0, ADDR_DSPL
    move $t6, $a1 # assume we have the row number in $a1
    la $s7, row_to_delete
    
    mul $t6, $t6, 128
    addi $t6, $t6, 12
    add $t6, $t0, $t6
    lw $t9, 0($t6)
    
    addi $t8, $t6, 100
    

    li $t5, 0xE4DCD1       # grey color
    li $t7, 0xC5CCD6       # white color
    
    blt $a1, 5, End_game  #If the row is less than 5, we end the game
    
check_rows_inner_loop:
    lw $t9, 0($t6)
    bgt $t6, $t8, Full
    beq $t9, $t5, Not_full
    
further_check_row_color: 
    beq $t9, $t7, Not_full
    
check_rows_inner_loop_update:
    addi $t6, $t6, 4
    j check_rows_inner_loop
    
Not_full:
    #lw $a1, 0($s7)
    #li $v0, 1
    #move $a0, $a1
    #syscall
    
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    
    jr $ra
    
Full:
    la $s7, row_to_delete
    sw $a1, 0($s7)
    
    #li $v0, 1
    #move $a0, $a1
    #syscall
    
    jr $ra
    
End_game:
    li $t6, -1
    sw $t6, 0($s7)
    
    #lw $a1, 0($s7)
    #li $v0, 1
    #move $a0, $a1
    #syscall
    
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    jr $ra           
######################################### 

##############################################################################
sorted_rows:
    la $s7, numbers                # Load address of numbers into $s7
    lw $s0, 0($s7)
    lw $s1, 4($s7)
    lw $s2, 8($s7)
    lw $s3, 12($s7) 
    lw $a0, 0($s7)
    

    li $s0, 0                      # Initialize counter 1 for outer loop
    li $s6, 3                      # n - 1, where n = number of elements - 1


sort_loop:
    li $s1, 0                      # Reset inner loop counter

inner_loop:
    sll $t7, $s1, 2                # Multiply $s1 by 4 (word size)
    add $t7, $s7, $t7              # Address of numbers[s1]
    
    lw $t0, 0($t7)                 # Load numbers[s1] into $t0
    lw $t1, 4($t7)                 # Load numbers[s1 + 1] into $t1

    sgt $t2, $t1, $t0              # If $t1 > $t0 (next element > current element)
    beq $t2, $zero, no_swap        # If $t2 == 0, no swap needed

    # Swap elements
    sw $t1, 0($t7)                 # Store numbers[s1 + 1] in numbers[s1]
    sw $t0, 4($t7)                 # Store numbers[s1] in numbers[s1 + 1]

no_swap:
    addi $s1, $s1, 1               # Increment inner loop counter
    sub $s5, $s6, $s0              # Calculate remaining iterations
    bne $s1, $s5, inner_loop       # If $s1 != $s5, continue inner loop

    addi $s0, $s0, 1               # Increment outer loop counter
    li $s1, 0                      # Reset inner loop counter
    bne $s0, $s6, sort_loop        # If $s0 != $s6, continue outer loop


final:
    lw $a0, 12($s7)
    la $a1, max_row
    lw $a2, 0($a1)
    ble $a0, $a2, update_max_row
    j update_final
    
update_max_row:
    sw $a0, 0($a1)
    
    #li $v0, 1
    #syscall
    
    #li $v0, 4
    #la $a0, newline
    #syscall
    
update_final: 
    lw $a0, 0($s7)           
    lw $a1, 12($s7)
    sw $a0, 12($s7)
    sw $a1, 0($s7)
    
    lw $a0, 4($s7)
    lw $a1, 8($s7)
    sw $a0, 8($s7)
    sw $a1, 4($s7)
    
    #lw $a0, 0($s7)
    
    #li $v0, 1
    #syscall
    
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    #lw $a0, 4($s7)
    
    #li $v0, 1
    #syscall
    
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    #lw $a0, 8($s7)
    
    #li $v0, 1
    #syscall
    
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    #lw $a0, 12($s7)
    
    #li $v0, 1
    #syscall
    
    #li $v0, 4
    #la $a0, newline
    #syscall  
      
    jr $ra                     # Make the syscall to exit the program

                                                                                   
##############################################################################
##############################################################################
remove_duplicate:
    li $t2, 0
    li $t4, 0
    la $s7, numbers
    lw $v1, 0($s7)
    lw $s6, 4($s7) 
    
check_loop:
    bgt $t2, 2, exit_duplicate_loop
    beq $v1, $s6, update
    subi $sp, $sp, 4
    sw $v1, 0($sp)
    
    #li $v0, 1
    #move $a0, $v1
    #syscall
   
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    addi $t4, $t4, 1
    
update:
   addi $t2, $t2, 1
   mul $t3, $t2, 4
   add $v1, $s7, $t3
   lw $v1, 0($v1)
   addi $t3, $t3, 4 
   add $s6, $s7, $t3
   lw $s6, 0($s6)
   j check_loop
       
exit_duplicate_loop: 
    subi $sp, $sp, 4
    lw $s6, 12($s7) 
    sw $s6, 0($sp)
    addi $t4, $t4, 1
    
    #li $v0, 1
    #move $a0, $s6
    #syscall
    
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    #mul $t4, $t4, 4
    #add $sp, $sp, $t4
    
    jr $ra                                                                     
##############################################################################
##############################################################################
calculate_row:
    lw $t0, ADDR_DSPL
    la $s0, numbers
    li $t1, 128
     
    lw $a0, 0($sp)
    sub $a0, $a0, $t0    #calculate address
    
    #li $v0, 1
    #syscall
    
    div $a0, $t1
    mflo $a0
    
    #li $v0, 1
    #syscall
    
    sw $a0, 0($s0)
    
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    lw $a0, 4($sp)
    sub $a0, $a0, $t0    #calculate address
    #li $v0, 1
    #syscall
    
    div $a0, $t1
    mflo $a0
    
    #li $v0, 1
    #syscall
    sw $a0, 4($s0)
    
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    lw $a0, 8($sp)
    sub $a0, $a0, $t0    #calculate address
    #li $v0, 1
    #syscall
    div $a0, $t1
    mflo $a0
    
    #li $v0, 1
    #syscall
    sw $a0, 8($s0)
    #li $v0, 4
    #la $a0, newline
    #syscall
    
    lw $a0, 12($sp)
    sub $a0, $a0, $t0    #calculate address
    #li $v0, 1
    #syscall
    div $a0, $t1
    mflo $a0
    
    #li $v0, 1
    #syscall
    sw $a0, 12($s0)
    
    #li $v0, 4
    #la $a0, newline
    #syscall    
    
    
    jr $ra
##############################################################
delete_shape:
    li $t5, 0xE4DCD1       # gret color
    li $t7, 0xC5CCD6       # white color
    li $t9, 0x8A8F9A       # wall
    li $t2, 4
    
    li $t6, 1
    lw $a1, 0($sp)
    subi $s1, $a1, 4
    lw $t4, 0($s1)      
    bne $t4, $t9, left_loop

    li $t6, 0
    lw $t9, 12($sp)
    sw $a1, 12($sp)
    sw $t9, 0($sp)
    
    lw $a1, 4($sp)
    lw $t9, 8($sp)
    sw $a1, 8($sp)
    sw $t9, 4($sp)
    lw $a1, 0($sp)
       
left_loop: 
    beq $t2, 0, exit_deletetion
    lw $a1, 0($sp)
    
    beq $t6, 1, check_left
    addi $s1, $a1, 4 #check color on the right
    j check_color
    
check_left:
    subi $s1, $a1, 4 #check color on the left
    
check_color:    
    lw $t4, 0($s1)
    beq $t4, $t7, left_grey
    beq $t4, $t5, left_white
    
left_grey:
    sw $t5, 0($a1)
    j left_update
    
left_white:
    sw $t7, 0($a1)
    j left_update
     
left_update:  
    addi $sp, $sp, 4
    subi $t2, $t2, 1
    j left_loop
        
exit_deletetion:
    jr $ra
#############################################################                                                                                                                                                                                                                                                                                                                                                                                                                                            
fill_color:
    li $t2, 1            # Initialize counter (starting value)
    lw $t6, 0($sp)       # Load base address from stack into $t6

fill_loop:
    beq $t2, 5, exit_fill_color  # Exit loop when counter equals 5
    sw $a0, 0($t6)      # Store value in $a0 at address $t5

fill_color_update:
    mul $t3, $t2, 4     # Compute offset (4 bytes per element)
    add $t3, $sp, $t3   # Update address in $t6
    lw $t6, 0($t3)
    addi $t2, $t2, 1    # Increment counter
    j fill_loop         # Repeat loop

exit_fill_color:
    jr $ra              # Return from function
###############################################################
random_shape:
   li $v0, 42
   li $a0, 0
   li $a1, 7
   syscall
    
   move $t1, $a0 #random shape of Tetrominoes
   jr $ra
##################################################################################             
init_walls_board:
    li $t2, 0              # t2 = y (row index)
    li $t3, 0              # t3 = x (column index)
    li $t4, 0              # t4 = address offset (in bytes)
    #li $t5, 128            # offset per row
    lw $t6, ADDR_DSPL

Loop:
    bge $t2, 32, end_loop    # End loop when y >= 32 (row index)

    # Determine if we are in a wall area
    ble  $t3, 2, wall       # If x is 0 (first column), draw wall
    bge $t3, 29, wall         # If x == 255 (last column), draw wall
    bge $t2, 29, wall         # If y == 255 (last row), draw wall

    # Determine background color
    andi $t7, $t2, 1          # $t7 = y % 2 (check if y is odd)
    andi $t8, $t3, 1          # $t8 = x % 2 (check if x is odd)
    xor $t7, $t7, $t8        # $t7 = y % 2 XOR x % 2
    beq $t7, $zero, bg_white # If both x and y are even or both are odd, set white background

    li $t1, 0xC5CCD6         # Set grey color
    sw $t1, 0($t6)           # Store color at address
    j init_walls_update

wall:
    li $t1, 0x8A8F9A         # Set black color
    sw $t1, 0($t6)           # Store color at address
    j init_walls_update

bg_white:
    li $t1, 0xE4DCD1         # Set white color
    sw $t1, 0($t6)           # Store color at address

init_walls_update:
    addi $t3, $t3, 1         # Increment x position
    addi $t4, $t4, 4
    add $t6, $t0, $t4
    bge $t3, 32, first_column  # If x >= 256, reset to first column
    j Loop

first_column:
    li $t3, 0                # Reset x to 0
    addi $t2, $t2, 1         # Increment y position
    j Loop

end_loop:
    jr $ra    
   
