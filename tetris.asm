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
string: .asciiz "$t2:"  # Define the string with a null terminator
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
    jal random_shape
    addi $t6, $t0, 64      # intially set t6 to be in the middle
    li $t3, 16             # $t3 is x index of the left-most grid; intially 16
    j init_shape

##############################################################################  

##########################################################
init_shape: 
   #li $t1, 6  
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
   j keyboard
    
###############################################################################
keyboard:
	li 		$v0, 32
	li 		$a0, 1
	syscall

    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
    b keyboard

keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x71, Terminate        # Check if the key q was pressed
    beq $a0, 0x77, respond_to_W     # Check if the key w was pressed
    beq $a0, 0x61, respond_to_A     # Check if the key a was pressed
    beq $a0, 0x73, respond_to_S
    #beq $a0, 0x20, respond_to_D

    li $v0, 1                       # ask system to print $a0
    syscall

    b keyboard

respond_to_W:
    li $t9, 0x8A8F9A       # wall
    
    lw $a1, 0($sp)
    subi $s1, $a1, 4
    lw $t4, 0($s1)
    beq $t4, $t9, keyboard    # check left most touches the wall
   
    
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

respond_to_A:
    li $t9, 0x8A8F9A       # wall
    
    lw $a1, 12($sp)
    addi $s1, $a1, 4
    lw $t4, 0($s1)
    beq $t4, $t9, keyboard    # check right most touches the wall
   
    
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
    
respond_to_S:
    li $t3, 0xD9A867 #U-shape
    lw $a1, 0($sp)
    lw $t4, 0($a1)
    beq $t4, $t3, keyboard

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

###################################

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
    beq $t4, $t9, keyboard    # check right most touches the wall
   
    
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
    beq $t4, $t9, keyboard    # check right most touches the wall
    
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
    beq $t4, $t9, keyboard    # check right most touches the wall
    
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
    beq $t4, $t9, keyboard    # check right most touches the wall
        
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
    beq $t4, $t9, keyboard    # check right most touches the wall
        
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
    beq $t4, $t9, keyboard    # check right most touches the wall
        
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
    beq $t4, $t9, keyboard    # check right most touches the wall
        
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
    beq $t4, $t9, keyboard    # check right most touches the wall
       
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
    beq $t4, $t9, keyboard    # check right most touches the wall  
     
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
    b keyboard
#####################################     
Terminate:
    li $v0, 10             # Terminate the program gracefully
    syscall
    
#####################################                                
#FUNCTIONS START HERE
##############################################################################                                                                        
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
  
############################################################################## 

delete_shape:
    li $t5, 0xE4DCD1       # gret color
    li $t7, 0xC5CCD6       # white color
    li $t9, 0x8A8F9A       # wall
    li $t2, 4
    
    lw $a0, 12($sp)
    
    lw $a1, 0($sp)
    subi $s1, $a1, 4
    lw $t4, 0($s1)      
    beq $t4, $t9, right_loop
    
left_loop: 
    beq $t2, 0, exit_deletetion
    lw $a1, 0($sp)
    subi $s1, $a1, 4 #check color on the left
    
    lw $t4, 0($s1)
    beq $t4, $t7, left_grey
    beq $t4, $t5, left_white
    
right_loop: 
    beq $t2, 0, right_exit_deletetion
    addi $s1, $a0, 4   #check color on the right
    lw $t4, 0($s1)
    beq $t4, $t7, right_grey
    beq $t4, $t5, right_white
    
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
           
right_grey:
    sw $t5, 0($a0)
    j right_update
    
right_white:
    sw $t7, 0($a0)
    j right_update
     
right_update: 
    subi $t2, $t2, 1
    mul $t9, $t2, 4
    add $a0, $sp, $t9
    j right_loop
    
exit_deletetion:
    jr $ra
         
right_exit_deletetion:
    addi $sp, $sp, 16
    jr $ra     
    
###############################
random_shape:
   li $v0, 42
   li $a0, 0
   li $a1, 7
   syscall
    
   move $t1, $a0 #random shape of Tetrominoes
   jr $ra
     
#####################################   


#####################################

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
    j update

wall:
    li $t1, 0x8A8F9A         # Set black color
    sw $t1, 0($t6)           # Store color at address
    j update

bg_white:
    li $t1, 0xE4DCD1         # Set white color
    sw $t1, 0($t6)           # Store color at address

update:
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
 ############################################################################################   
game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    b game_loop
