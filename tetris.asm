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
# - Milestone 1/2/3/4/5 (choose the one the applies): 5
#
# Which approved features have been implemented?
# (See the assignment handout for the list of features)
# Easy Features:
# 1. Gravity and auto drop
# 2. Speed increase once the row is less than 8, 12 and 30. Speed increase gradually.
# 3. Implemented pause: First time press "p", there is a "P" for "Pause" in the bottom middle of the screen. For the second time, 
# P disappear and the game resumes.
# 4. There are 3 chances to change shapes during the game. The remaining number of chances is the white number in the bottom right.
# To change shape, Press 'c'.
# 5. If the height of the tetris is less than or equal row 5, the game is over, and there is a big red cross in the middle of the screen.
# To retry, press 'r'.
# 6. If you completed 4 lines, you gain 4 points (bottom left) and you win. There is a big red "W" in the middle of the screen. To retry, 
# press 'r'.
# 7. Implemented 7 shapes with 7 different colors.

# Hard Features:
# 1. Store marks. Completing one row, you gain 1 mark. You win once you get 4 points.
# 2. Implemented 7 shapes with 7 different colors. They can all do rotations. In total, implemented 19 shapes (included rotated shape)

#####################################################################
# How to play:
# (Include any instructions)
# 1. Once the game has started, a random shape will be dropped from the top of the screen.
# 2. You can use 'w' for rotation, 'a' for left movement, 'd' for right movement, 's' for acceleration, 'q' for quitting the game, 'p' for
# pausing. Note that if the speed less than or equal to 50, 's' will not be affective.
# 3. Once you have filled a full row of tetris, that row is removed and you gain one point.
# 4. If the height of the tetris is less than or equal row 5, the game is over, and there is a big red cross in the middle of the screen.
# To retry, press 'r'.
# 5. If you completed 4 lines, you gain 4 points (bottom left) and you win. There is a big red "W" in the middle of the screen. To retry, 
# press 'r'.

# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes
#
# Any additional information that the TA needs to know:
# - I completed this project on my own since my partner uses different algorithm. I implemented 7 shapes with 7 different colors. They can 
# all do rotations. In total, implemented 19 shapes (included rotated shape). This is extremely difficult since there are too many variation
# and too many factors to consider when doing rotation an collision detection. I did a lot of debugging and fixing during my implementation.
#
#####################################################################

##############################################################################

    .data
##############################################################################
numbers: .word 0, 0, 0, 0    # Create an array with 4 numbers
row_to_delete: .word 0    # Create an array with 4 numbers
max_row: .word 30
change_shape_chance: .word 3
Mark: .word 0
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
    li $a0, 0xE4DCD1       # Load color value (Morandi Pink) into $a0
    li $a1, 3568           # Set position offset for drawing '3' into $a1
    jal draw_3             # Call the subroutine to draw '3'
    
    li $a0, 0xF5C6C6       # Load color value (another shade of Morandi Pink) into $a0
    li $a1, 3460           # Set position offset for drawing '0' into $a1
    jal draw_0             # Call the subroutine to draw '0'

start:
    lw $t0, ADDR_DSPL      # Load the base address of the display into $t0
    
    jal random_shape       # Call the subroutine to select a random shape
    
    addi $t6, $t0, 64      # Initially set $t6 to be in the middle of the display
    li $t3, 16             # Set $t3 as x index of the left-most grid; initially 16
    j init_shape           # Jump to the subroutine to initialize the selected shape

##########################################################

init_shape: 
    #li $t1, 5
    beq $t1, 0, U_shape    # Branch to U_shape if $t1 is 0
    beq $t1, 1, I_shape    # Branch to I_shape if $t1 is 1
    beq $t1, 2, S_shape    # Branch to S_shape if $t1 is 2
    beq $t1, 3, Z_shape    # Branch to Z_shape if $t1 is 3
    beq $t1, 4, L_shape    # Branch to L_shape if $t1 is 4
    beq $t1, 5, J_shape    # Branch to J_shape if $t1 is 5
   
    li $a0, 0x8D6E99       # Load color value into $a0
    subi $sp, $sp, 16      # Adjust stack pointer

    # Store the coordinates of the shape in memory
    addi $t9, $t6, 0
    sw $t9, 0($sp)
    addi $t9, $t6, 4
    sw $t9, 4($sp)
    addi $t9, $t6, 132
    sw $t9, 8($sp)
    addi $t9, $t6, 8
    sw $t9, 12($sp)
    j init_shape_done      # Jump to the completion section

U_shape:
    li $a0, 0xD9A867       # Load color value for U shape
    subi $sp, $sp, 16      # Adjust stack pointer
    
    # Store the coordinates of the U shape in memory
    addi $t9, $t6, 0
    sw $t9, 0($sp)
    addi $t9, $t6, 128
    sw $t9, 4($sp)
    addi $t9, $t6, 4
    sw $t9, 8($sp)
    addi $t9, $t6, 132
    sw $t9, 12($sp)
    j init_shape_done      # Jump to the completion section

I_shape:
    li $a0, 0x003D6B       # Load color value for I shape
    subi $sp, $sp, 16      # Adjust stack pointer
    
    # Store the coordinates of the I shape in memory
    addi $t9, $t6, 0
    sw $t9, 0($sp)
    addi $t9, $t6, 128
    sw $t9, 4($sp)
    addi $t9, $t6, 256
    sw $t9, 8($sp)
    addi $t9, $t6, 384
    sw $t9, 12($sp)
    j init_shape_done      # Jump to the completion section

S_shape:
    li $a0, 0xB26666       # Load color value for S shape
    subi $sp, $sp, 16      # Adjust stack pointer
    
    # Store the coordinates of the S shape in memory
    addi $t9, $t6, 128
    sw $t9, 0($sp)
    addi $t9, $t6, 4
    sw $t9, 4($sp)
    addi $t9, $t6, 8
    sw $t9, 8($sp)
    addi $t9, $t6, 132
    sw $t9, 12($sp)
    j init_shape_done      # Jump to the completion section

Z_shape:
    li $a0, 0x7C8A73       # Load color value for Z shape
    subi $sp, $sp, 16      # Adjust stack pointer
    
    # Store the coordinates of the Z shape in memory
    addi $t9, $t6, 0
    sw $t9, 0($sp)
    addi $t9, $t6, 4
    sw $t9, 4($sp)
    addi $t9, $t6, 132
    sw $t9, 8($sp)
    addi $t9, $t6, 136
    sw $t9, 12($sp)
    j init_shape_done      # Jump to the completion section

L_shape:
    li $a0, 0xC97A53       # Load color value for L shape
    subi $sp, $sp, 16      # Adjust stack pointer
    
    # Store the coordinates of the L shape in memory
    addi $t9, $t6, 0
    sw $t9, 0($sp)
    addi $t9, $t6, 128
    sw $t9, 4($sp)
    addi $t9, $t6, 256
    sw $t9, 8($sp)
    addi $t9, $t6, 260
    sw $t9, 12($sp)
    j init_shape_done      # Jump to the completion section

J_shape:
    li $a0, 0xE26B8A       # Load color value for J shape
    subi $sp, $sp, 16      # Adjust stack pointer
    
    # Store the coordinates of the J shape in memory
    addi $t9, $t6, 256
    sw $t9, 0($sp)
    addi $t9, $t6, 4
    sw $t9, 4($sp)
    addi $t9, $t6, 132
    sw $t9, 8($sp)
    addi $t9, $t6, 260
    sw $t9, 12($sp)

init_shape_done:
    jal fill_color          # Call the subroutine to fill the shape with the specified color
    la $s7, max_row         # Load the address of max_row into $s7
    lw $s7, 0($s7)          # Load the value of max_row into $s7
    ble $s7, 8, set_50_speed    # Set speed to 50 if max_row is less than or equal to 8
    ble $s7, 12, set_100_speed  # Set speed to 100 if max_row is less than or equal to 12
    ble $s7, 20, set_150_speed  # Set speed to 150 if max_row is less than or equal to 20
    li $a2, 200             # Default speed value
    j speed                 # Jump to speed section

set_50_speed:
    li $a2, 50              # Set speed to 50
    j speed                 # Jump to speed section

set_100_speed:
    li $a2, 100             # Set speed to 100
    j speed                 # Jump to speed section

set_150_speed:
    li $a2, 150             # Set speed to 150
    j speed                 # Jump to speed section
       
#######################################################
###############################################################################
speed:
    li $v0, 32            # Set the system call code for sleep
    move $a0, $a2         # Move the sleep duration into $a0
    syscall               # Make the system call to sleep

keyboard:
    lw $t0, ADDR_KBRD               # Load the base address for the keyboard into $t0
    lw $t8, 0($t0)                  # Load the first word from the keyboard address into $t8
    beq $t8, 1, keyboard_input      # If $t8 is 1, a key is pressed, jump to keyboard_input
    b Auto_drop                     # Otherwise, jump to Auto_drop

keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load the second word from the keyboard address into $a0
    beq $a0, 0x71, Terminate        # If 'q' key is pressed, jump to Terminate
    beq $a0, 0x77, respond_to_W     # If 'w' key is pressed, jump to respond_to_W
    beq $a0, 0x61, respond_to_A     # If 'a' key is pressed, jump to respond_to_A
    beq $a0, 0x64, respond_to_D     # If 'd' key is pressed, jump to respond_to_D
    beq $a0, 0x73, respond_to_S     # If 's' key is pressed, jump to respond_to_S
    beq $a0, 0x70, respond_to_P     # If 'p' key is pressed, jump to respond_to_P
    beq $a0, 0x63, respond_to_C     # If 'c' key is pressed, jump to respond_to_C
    b Auto_drop                     # Otherwise, jump to Auto_drop

respond_to_A:
    li $t9, 0x8A8F9A       # Wall color
    li $t5, 0xE4DCD1       # Grey color
    li $t7, 0xC5CCD6       # White color
    lw $a1, 0($sp)         # Load the first word from stack into $a1
    lw $s0, 0($sp)         # Load the first word from stack into $s0
    lw $s4, 4($sp)         # Load the second word from stack into $s4
    lw $s2, 8($sp)         # Load the third word from stack into $s2
    lw $s3, 12($sp)        # Load the fourth word from stack into $s3
    li $t2, 1              # Initialize $t2 to 1

check_left_obstacle:
    beq $t2, 4, left_movement_update    # If $t2 == 4, jump to left_movement_update
    subi $s1, $a1, 4                    # Subtract 4 from $a1 and store in $s1
    bne $s1, $s0, check_second_left     # If $s1 != $s0, jump to check_second_left
    j check_left_obstacle_update        # Otherwise, jump to check_left_obstacle_update

check_second_left:
    bne $s1, $s4, check_third_left      # If $s1 != $s4, jump to check_third_left
    j check_left_obstacle_update        # Otherwise, jump to check_left_obstacle_update

check_third_left:
    bne $s1, $s2, check_fourth_left     # If $s1 != $s2, jump to check_fourth_left
    j check_left_obstacle_update        # Otherwise, jump to check_left_obstacle_update

check_fourth_left:
    bne $s1, $s3, check_left_color      # If $s1 != $s3, jump to check_left_color
    j check_left_obstacle_update        # Otherwise, jump to check_left_obstacle_update

check_left_color:                    
    lw $t4, 0($s1)                      # Load the word from address $s1 into $t4
    bne $t4, $t5, left_move_further_check  # If $t4 != $t5, jump to left_move_further_check
    j check_left_obstacle_update        # Otherwise, jump to check_left_obstacle_update

left_move_further_check:   
    bne $t4, $t7, Auto_drop             # If $t4 != $t7, jump to Auto_drop

check_left_obstacle_update:
    mul $s1, $t2, 4                     # Multiply $t2 by 4 and store in $s1
    add $a1, $sp, $s1                   # Add $sp and $s1 and store in $a1
    addi $t2, $t2, 1                    # Increment $t2 by 1
    lw $a1, 0($a1)                      # Load the word from address $a1 into $a1
    j check_left_obstacle               # Jump to check_left_obstacle   

left_movement_update:    
    lw $s0, 0($sp)      # Load the first word from stack into $s0
    lw $t3, 0($s0)      # Load the word from address $s0 into $t3
    subi $s0, $s0, 4    # Subtract 4 from $s0
    
    lw $s4, 4($sp)      # Load the second word from stack into $s4
    subi $s4, $s4, 4    # Subtract 4 from $s4
    
    lw $s2, 8($sp)      # Load the third word from stack into $s2
    subi $s2, $s2, 4    # Subtract 4 from $s2
    
    lw $s3, 12($sp)     # Load the fourth word from stack into $s3
    subi $s3, $s3, 4    # Subtract 4 from $s3
   
    j keyboard_update   # Jump to keyboard_update

respond_to_D:
    li $t9, 0x8A8F9A       # Wall color
    li $t5, 0xE4DCD1       # Grey color
    li $t7, 0xC5CCD6       # White color
    lw $a1, 12($sp)        # Load the fourth word from stack into $a1
    lw $s0, 0($sp)         # Load the first word from stack into $s0
    lw $s4, 4($sp)         # Load the second word from stack into $s4
    lw $s2, 8($sp)         # Load the third word from stack into $s2
    lw $s3, 12($sp)        # Load the fourth word from stack into $s3
    li $t2, 2              # Initialize $t2 to 2

check_right_obstacle:
    beq $t2, -1, right_movement_update    # If $t2 == -1, jump to right_movement_update
    addi $s1, $a1, 4                      # Add 4 to $a1 and store in $s1
    bne $s1, $s0, check_second_right      # If $s1 != $s0, jump to check_second_right
    j check_right_obstacle_update         # Otherwise, jump to check_right_obstacle_update

check_second_right:
    bne $s1, $s4, check_third_right       # If $s1 != $s4, jump to check_third_right
    j check_right_obstacle_update         # Otherwise, jump to check_right_obstacle_update

check_third_right:
    bne $s1, $s2, check_fourth_right      # If $s1 != $s2, jump to check_fourth_right
    j check_right_obstacle_update         # Otherwise, jump to check_right_obstacle_update

check_fourth_right:
    bne $s1, $s3, check_right_color       # If $s1 != $s3, jump to check_right_color
    j check_right_obstacle_update         # Otherwise, jump to check_right_obstacle_update

check_right_color:                    
    lw $t4, 0($s1)                        # Load the word from address $s1 into $t4
    bne $t4, $t5, right_move_further_check  # If $t4 != $t5, jump to right_move_further_check
    j check_right_obstacle_update         # Otherwise, jump to check_right_obstacle_update

right_move_further_check:   
    bne $t4, $t7, Auto_drop               # If $t4 != $t7, jump to Auto_drop

check_right_obstacle_update:
    mul $s1, $t2, 4                       # Multiply $t2 by 4 and store in $s1
    add $a1, $sp, $s1                     # Add $sp and $s1 and store in $a1
    addi $t2, $t2, -1                     # Decrement $t2 by 1
    lw $a1, 0($a1)                        # Load the word from address $a1 into $a1
    j check_right_obstacle                # Jump to check_right_obstacle   

right_movement_update:    
    lw $s0, 0($sp)      # Load the first word from stack into $s0
    lw $t3, 0($s0)      # Load the word from address $s0 into $t3
    addi $s0, $s0, 4    # Add 4 to $s0
    
    lw $s4, 4($sp)      # Load the second word from stack into $s4
    addi $s4, $s4, 4    # Add 4 to $s4
    
    lw $s2, 8($sp)      # Load the third word from stack into $s2
    addi $s2, $s2, 4    # Add 4 to $s2
    
    lw $s3, 12($sp)     # Load the fourth word from stack into $s3
    addi $s3, $s3, 4    # Add 4 to $s3
   
    j keyboard_update   # Jump to keyboard_update
    
respond_to_W:
    li $t3, 0xD9A867         # Load the U-shape color code into $t3
    lw $a1, 0($sp)           # Load the first word from stack into $a1
    lw $t4, 0($a1)           # Load the word from address $a1 into $t4
    beq $t4, $t3, Auto_drop      # If $t4 equals U-shape color, jump to speed

    li $t3, 0x003D6B         # Load the I-shape color code into $t3
    beq $t4, $t3, I_shape_rot # If $t4 equals I-shape color, jump to I_shape_rot

    li $t3, 0xB26666         # Load the S-shape color code into $t3
    beq $t4, $t3, S_shape_rot # If $t4 equals S-shape color, jump to S_shape_rot

    li $t3, 0x7C8A73         # Load the Z-shape color code into $t3
    beq $t4, $t3, Z_shape_rot # If $t4 equals Z-shape color, jump to Z_shape_rot

    li $t3, 0xC97A53         # Load the L-shape color code into $t3
    beq $t4, $t3, L_shape_rot # If $t4 equals L-shape color, jump to L_shape_rot

    li $t3, 0xE26B8A         # Load the J-shape color code into $t3
    beq $t4, $t3, J_shape_rot # If $t4 equals J-shape color, jump to J_shape_rot

    li $t3, 0x8D6E99         # Load the T-shape color code into $t3
    j T_shape_rot            # Jump to T_shape_rot

respond_to_S:
    addi $a2, $a2, -50       # Decrease the sleep duration by 50
    bge $a2, 50, Auto_drop   # If $a2 is greater than or equal to 50, jump to Auto_drop
    addi $a2, $a2, 50        # Restore the original sleep duration
    j Auto_drop              # Jump to Auto_drop

respond_to_P:
    li $a1, 3512             # Load value 3512 into $a1
    li $a0, 0x00000          # Load value 0x00000 into $a0
    jal draw_p               # Jump and link to draw_p
    lw $t0, ADDR_KBRD        # Load the base address for the keyboard into $t0
    lw $t8, 0($t0)           # Load the first word from the keyboard address into $t8
    beq $t8, 1, check_P      # If $t8 is 1, a key is pressed, jump to check_P
    j respond_to_P           # Otherwise, jump to respond_to_P

check_P:
    lw $a0, 4($t0)           # Load the second word from the keyboard address into $a0
    beq $a0, 0x70, resume    # If 'p' key is pressed, jump to resume
    beq $a0, 0x71, Terminate # If 'q' key is pressed, jump to Terminate
    j respond_to_P           # Otherwise, jump to respond_to_P

resume:
    li $a1, 3512             # Load value 3512 into $a1
    li $a0, 0x8A8F9A         # Load wall color into $a0
    jal draw_p               # Jump and link to draw_p
    j Auto_drop              # Jump to Auto_drop

respond_to_C:
    la $s7, change_shape_chance # Load address of change_shape_chance into $s7
    lw $t1, 0($s7)           # Load the value of change_shape_chance into $t1

    beq $t1, 0, Auto_drop    # If $t1 is 0, jump to Auto_drop
    jal delete_shape         # Jump and link to delete_shape
    addi $sp, $sp, 16        # Add 16 to the stack pointer
    beq $t1, 1, change_to_0  # If $t1 is 1, jump to change_to_0
    beq $t1, 2, change_to_1  # If $t1 is 2, jump to change_to_1
    li $a1, 3568             # Load value 3568 into $a1
    li $a0, 0x8A8F9A         # Load wall color into $a0
    jal draw_3               # Jump and link to draw_3
    li $a0, 0xE4DCD1         # Load grey color into $a0
    jal draw_2               # Jump and link to draw_2

    j update_drop_chance     # Jump to update_drop_chance

change_to_0:
    li $a1, 3568             # Load value 3568 into $a1
    li $a0, 0x8A8F9A         # Load wall color into $a0
    jal draw_1               # Jump and link to draw_1
    li $a0, 0xE4DCD1         # Load grey color into $a0
    jal draw_0               # Jump and link to draw_0
    j update_drop_chance     # Jump to update_drop_chance

change_to_1:
    li $a1, 3568             # Load value 3568 into $a1
    li $a0, 0x8A8F9A         # Load wall color into $a0
    jal draw_2               # Jump and link to draw_2
    li $a0, 0xE4DCD1         # Load grey color into $a0
    jal draw_1               # Jump and link to draw_1

update_drop_chance:
    li $a1, 3568             # Load value 3568 into $a1
    la $s7, change_shape_chance # Load address of change_shape_chance into $s7
    lw $t1, 0($s7)           # Load the value of change_shape_chance into $t1
    subi $t1, $t1, 1         # Subtract 1 from $t1
    sw $t1, 0($s7)           # Store the updated value back to change_shape_chance
    j start                  # Jump to start

Terminate:
    la $s0, numbers          # Load address of numbers into $s0
    addi $s0, $s0, 16        # Add 16 to $s0

    la $s0, row_to_delete    # Load address of row_to_delete into $s0
    addi $s0, $s0, 4         # Add 4 to $s0

    la $s0, max_row          # Load address of max_row into $s0
    addi $s0, $s0, 4         # Add 4 to $s0

    la $s0, change_shape_chance # Load address of change_shape_chance into $s0
    addi $s0, $s0, 4         # Add 4 to $s0

    la $s0, Mark             # Load address of Mark into $s0
    addi $s0, $s0, 4         # Add 4 to $s0

    li $v0, 10               # Load system call code for exit into $v0
    syscall                  # Make the system call to terminate the program

###################################
#ROTATION
# I-shape rotation handling
I_shape_rot:
    li $t9, 0x8A8F9A       # Wall color code
    lw $a1, 0($sp)         # Load the current shape's address
    addi $s1, $a1, 128     # Calculate address for the next position
    lw $t4, 0($s1)         # Load value at the calculated position
    beq $t4, $t3, I_pos_1  # If the value matches, go to position 1
    j I_pos_2              # Otherwise, go to position 2

I_pos_1:
    addi $s1, $a1, 12      # Calculate address for the rightmost position
    lw $t4, 0($s1)         # Load value at the rightmost position
    beq $t4, $t9, Auto_drop # If the value matches the wall, drop the shape

    lw $s0, 0($sp)         # Store address at 0($sp)
    addi $s4, $s0, 4       # Update positions
    addi $s2, $s0, 8
    addi $s3, $s0, 12
    j keyboard_update      # Update the game state

I_pos_2:
    lw $s0, 0($sp)         # Store address at 0($sp)
    addi $s4, $s0, 128     # Update positions
    addi $s2, $s0, 256
    addi $s3, $s0, 384
    j keyboard_update      # Update the game state

######################################

# S-shape rotation handling
S_shape_rot:
    li $t9, 0x8A8F9A       # Wall color code
    lw $a1, 0($sp)         # Load the current shape's address
    addi $s1, $a1, 128     # Calculate address for the next position
    lw $t4, 0($s1)         # Load value at the calculated position
    beq $t4, $t3, S_pos_2  # If the value matches, go to position 2

S_pos_1:
    lw $s0, 0($sp)         # Store address at 0($sp)
    subi $s0, $s0, 128     # Calculate address for the next position
    addi $s4, $s0, 128     # Update positions
    addi $s2, $s0, 132
    addi $s3, $s0, 260
    j keyboard_update      # Update the game state

S_pos_2:
    addi $s1, $a1, 8       # Calculate address for the next position
    lw $t4, 0($s1)         # Load value at the calculated position
    beq $t4, $t9, Auto_drop # If the value matches the wall, drop the shape

    lw $s0, 0($sp)         # Store address at 0($sp)
    addi $s0, $s0, 128     # Update positions
    subi $s4, $s0, 124
    addi $s2, $s0, 4
    subi $s3, $s0, 120
    j keyboard_update      # Update the game state

######################################### 

# Z-shape rotation handling
Z_shape_rot:
    li $t9, 0x8A8F9A       # Wall color code
    lw $a1, 0($sp)         # Load the current shape's address
    addi $s1, $a1, 128     # Calculate address for the next position
    lw $t4, 0($s1)         # Load value at the calculated position
    beq $t4, $t3, Z_pos_2  # If the value matches, go to position 2

Z_pos_1:
    lw $s0, 0($sp)         # Store address at 0($sp)
    addi $s0, $s0, 128     # Calculate address for the next position
    addi $s4, $s0, 128     # Update positions
    subi $s2, $s0, 124
    addi $s3, $s0, 4
    j keyboard_update      # Update the game state

Z_pos_2:
    addi $s1, $a1, 8       # Calculate address for the next position
    lw $t4, 0($s1)         # Load value at the calculated position
    beq $t4, $t9, Auto_drop # If the value matches the wall, drop the shape

    lw $s0, 0($sp)         # Store address at 0($sp)
    subi $s0, $s0, 128     # Update positions
    addi $s4, $s0, 4
    addi $s2, $s0, 132
    addi $s3, $s0, 136
    j keyboard_update      # Update the game state

##########################################

# L-shape rotation handling
L_shape_rot:
    li $t9, 0x8A8F9A       # Wall color code
    lw $a1, 0($sp)         # Load the current shape's address
    addi $s1, $a1, 128     # Calculate address for the next position
    lw $t4, 0($s1)         # Check if below is still part of Tetris
    beq $t4, $t3, L_pos_1_2

    addi $s1, $a1, 132     # Check if below is still part of Tetris
    lw $t4, 0($s1)         # Load value at the calculated position
    beq $t4, $t3, L_pos_3
    j L_pos_4              # Otherwise, go to position 4

L_pos_1_2:
    addi $s1, $a1, 4       # Check if right is still part of Tetris
    lw $t4, 0($s1)         # Load value at the calculated position
    beq $t4, $t3, L_pos_2
    j L_pos_1              # Otherwise, go to position 1

L_pos_1:
    addi $s1, $a1, 8       # Calculate address for the next position
    lw $t4, 0($s1)         # Load value at the calculated position
    beq $t4, $t9, Auto_drop # If the value matches the wall, drop the shape

    lw $s0, 0($sp)         # Store address at 0($sp)
    addi $s4, $s0, 128     # Update positions
    addi $s2, $s0, 4
    addi $s3, $s0, 8
    j keyboard_update      # Update the game state

L_pos_2:
    lw $s0, 0($sp)         # Store address at 0($sp)
    addi $s4, $s0, 4       # Update positions
    addi $s2, $s0, 132
    addi $s3, $s0, 260
    j keyboard_update      # Update the game state

L_pos_3:
    addi $s1, $a1, 8       # Calculate address for the next position
    lw $t4, 0($s1)         # Load value at the calculated position
    beq $t4, $t9, Auto_drop # If the value matches the wall, drop the shape

    lw $s0, 0($sp)         # Store address at 0($sp)
    addi $s0, $s0, 128     # Update positions
    addi $s4, $s0, 4
    subi $s2, $s0, 120
    addi $s3, $s0, 8
    j keyboard_update      # Update the game state

L_pos_4:
    lw $s0, 0($sp)         # Store address at 0($sp)
    subi $s0, $s0, 128     # Update positions
    addi $s4, $s0, 128
    addi $s2, $s0, 256
    addi $s3, $s0, 260
    j keyboard_update      # Update the game state
         

##########################################

# J-shape rotation handling
J_shape_rot:
    li $t9, 0x8A8F9A       # Load wall color code
    lw $a1, 0($sp)         # Load the current shape's address
    addi $s1, $a1, 128     # Calculate address to check below the shape
    lw $t4, 0($s1)         # Load value from the calculated address
    beq $t4, $t3, J_pos_2_3 # If the value matches, go to position 2/3

    addi $s1, $a1, 136     # Calculate address to check another position below the shape
    lw $t4, 0($s1)         # Load value from the calculated address
    beq $t4, $t3, J_pos_4 # If the value matches, go to position 4
    j J_pos_1              # Otherwise, go to position 1

J_pos_2_3:
    addi $s1, $a1, 4       # Calculate address to check the right side of the shape
    lw $t4, 0($s1)         # Load value from the calculated address
    beq $t4, $t3, J_pos_3 # If the value matches, go to position 3
    j J_pos_2              # Otherwise, go to position 2

J_pos_1:
    addi $s1, $a1, 8       # Calculate address to check the rightmost part of the shape
    lw $t4, 0($s1)         # Load value from the calculated address
    beq $t4, $t9, Auto_drop # If the value matches the wall, drop the shape

    lw $s0, 0($sp)         # Store the base address at 0($sp)
    subi $s0, $s0, 256     # Update base address for new positions
    addi $s4, $s0, 128     # Update position for part 4 of the shape
    addi $s2, $s0, 132     # Update position for part 2 of the shape
    addi $s3, $s0, 136     # Update position for part 3 of the shape
    j keyboard_update      # Update the game state

J_pos_2:
    lw $s0, 0($sp)         # Store the base address at 0($sp)
    addi $s4, $s0, 128     # Update position for part 4 of the shape
    addi $s2, $s0, 256     # Update position for part 2 of the shape
    addi $s3, $s0, 4       # Update position for part 3 of the shape
    j keyboard_update      # Update the game state

J_pos_3:
    addi $s1, $a1, 8       # Calculate address to check the rightmost part of the shape
    lw $t4, 0($s1)         # Load value from the calculated address
    beq $t4, $t9, Auto_drop # If the value matches the wall, drop the shape

    lw $s0, 0($sp)         # Store the base address at 0($sp)
    addi $s4, $s0, 4       # Update position for part 4 of the shape
    addi $s2, $s0, 8       # Update position for part 2 of the shape
    addi $s3, $s0, 136     # Update position for part 3 of the shape
    j keyboard_update      # Update the game state

J_pos_4:
    lw $s0, 0($sp)         # Store the base address at 0($sp)
    addi $s0, $s0, 256     # Update base address for new positions
    subi $s4, $s0, 252     # Update position for part 4 of the shape
    subi $s2, $s0, 124     # Update position for part 2 of the shape
    addi $s3, $s0, 4       # Update position for part 3 of the shape
    j keyboard_update      # Update the game state

##########################################

# T-shape rotation handling
T_shape_rot:
    li $t9, 0x8A8F9A       # Load wall color code
    lw $a1, 0($sp)         # Load the current shape's address
    addi $s1, $a1, 132     # Calculate address to check the right down position of the shape
    lw $t4, 0($s1)         # Load value from the calculated address
    bne $t4, $t3, T_pos_3 # If the value does not match, go to position 3

    addi $s1, $a1, 4       # Calculate address to check the position below the shape
    lw $t4, 0($s1)         # Load value from the calculated address
    bne $t4, $t3, T_pos_4 # If the value does not match, go to position 4

    addi $s1, $a1, 8       # Calculate address to check the right side of the shape
    lw $t4, 0($s1)         # Load value from the calculated address
    beq $t4, $t3, T_pos_1 # If the value matches, go to position 1
    j T_pos_2              # Otherwise, go to position 2

T_pos_1:
    lw $s0, 0($sp)         # Store the base address at 0($sp)
    addi $s0, $s0, 128     # Update base address for new positions
    subi $s4, $s0, 124     # Update position for part 4 of the shape
    addi $s2, $s0, 4       # Update position for part 2 of the shape
    addi $s3, $s0, 132     # Update position for part 3 of the shape
    j keyboard_update      # Update the game state

T_pos_2:
    addi $s1, $a1, 8       # Calculate address to check the rightmost part of the shape
    lw $t4, 0($s1)         # Load value from the calculated address
    beq $t4, $t9, Auto_drop # If the value matches the wall, drop the shape

    lw $s0, 0($sp)         # Store the base address at 0($sp)
    subi $s4, $s0, 124     # Update position for part 4 of the shape
    addi $s2, $s0, 4       # Update position for part 2 of the shape
    addi $s3, $s0, 8       # Update position for part 3 of the shape
    j keyboard_update      # Update the game state

T_pos_3:
    lw $s0, 0($sp)         # Store the base address at 0($sp)
    subi $s0, $s0, 128     # Update base address for new positions
    addi $s4, $s0, 128     # Update position for part 4 of the shape
    addi $s2, $s0, 256     # Update position for part 2 of the shape
    addi $s3, $s0, 132     # Update position for part 3 of the shape
    j keyboard_update      # Update the game state

T_pos_4:
    addi $s1, $a1, 8       # Calculate address to check the rightmost part of the shape
    lw $t4, 0($s1)         # Load value from the calculated address
    beq $t4, $t9, Auto_drop # If the value matches the wall, drop the shape

    lw $s0, 0($sp)         # Store the base address at 0($sp)
    addi $s4, $s0, 4       # Update position for part 4 of the shape
    addi $s2, $s0, 132     # Update position for part 2 of the shape
    addi $s3, $s0, 8       # Update position for part 3 of the shape
    j keyboard_update      # Update the game state

#########################################

# keyboard_update function
keyboard_update:
    jal delete_shape      # Call function to delete the current shape

    subi $sp, $sp, 16     # Allocate 16 bytes on the stack
    sw $s0, 0($sp)        # Save the base address
    sw $s4, 4($sp)        # Save position for part 4
    sw $s2, 8($sp)        # Save position for part 2
    sw $s3, 12($sp)       # Save position for part 3
    move $a0, $t3         # Move the shape color to $a0
    jal fill_color        # Call function to fill the new shape color
    
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
# DROP/COLLISION HANDLING

U_shape_drop:   
    lw $v0, 4($sp)         # Load value from stack address for U-shape drop handling
    lw $v1, 12($sp)        # Load another value from stack address for U-shape drop handling
    j base_2_drop          # Jump to base_2_drop for further processing

#################################

# I-shape drop handling
I_shape_drop:
    lw $a1, 0($sp)         # Load the address of the I-shape from the stack
    addi $s1, $a1, 128     # Calculate the address to check if below the shape is valid
    lw $t4, 4($sp)         # Load value from stack for comparison
    beq $t4, $s1, I_pos_1_drop # If value matches, go to I_pos_1_drop
    j I_pos_2_drop        # Otherwise, go to I_pos_2_drop

I_pos_1_drop:    
    lw $v1, 12($sp)        # Load value from stack for position 1 drop handling
    j base_1_drop         # Jump to base_1_drop for further processing

I_pos_2_drop:    
    lw $v0, 0($sp)         # Load value from stack for position 2 drop handling
    lw $v1, 4($sp)         # Load another value from stack for position 2 drop handling
    lw $s5, 8($sp)         # Load another value from stack for position 2 drop handling
    lw $s6, 12($sp)        # Load another value from stack for position 2 drop handling
    j base_4_drop         # Jump to base_4_drop for further processing

######################################

# S-shape drop handling
S_shape_drop:
    lw $a1, 0($sp)         # Load the address of the S-shape from the stack
    addi $s1, $a1, 128     # Calculate address to check if below the shape is valid
    lw $t4, 4($sp)         # Load value from stack for comparison
    beq $t4, $s1, S_pos_2_drop # If value matches, go to S_pos_2_drop
    
S_pos_1_drop:    
    lw $v0, 0($sp)         # Load value from stack for position 1 drop handling
    lw $v1, 8($sp)         # Load another value from stack for position 1 drop handling
    lw $s5, 12($sp)        # Load another value from stack for position 1 drop handling
    j base_3_drop         # Jump to base_3_drop for further processing

S_pos_2_drop:    
    lw $v0, 4($sp)         # Load value from stack for position 2 drop handling
    lw $v1, 12($sp)        # Load another value from stack for position 2 drop handling
    j base_2_drop         # Jump to base_2_drop for further processing

######################################### 

# Z-shape drop handling
Z_shape_drop:
    lw $a1, 0($sp)         # Load the address of the Z-shape from the stack
    addi $s1, $a1, 128     # Calculate address to check if below the shape is valid
    lw $t4, 4($sp)         # Load value from stack for comparison
    beq $t4, $s1, Z_pos_2_drop # If value matches, go to Z_pos_2_drop
    
Z_pos_1_drop:    
    lw $v0, 0($sp)         # Load value from stack for position 1 drop handling
    lw $v1, 8($sp)         # Load another value from stack for position 1 drop handling
    lw $s5, 12($sp)        # Load another value from stack for position 1 drop handling
    j base_3_drop         # Jump to base_3_drop for further processing
   
Z_pos_2_drop:    
    lw $v1, 4($sp)         # Load value from stack for position 2 drop handling
    lw $v0, 12($sp)        # Load another value from stack for position 2 drop handling
    j base_2_drop         # Jump to base_2_drop for further processing

##########################################

# L-shape drop handling
L_shape_drop:
    lw $a1, 0($sp)         # Load the address of the L-shape from the stack
    addi $s1, $a1, 128     # Calculate address to check if below the shape is valid
    lw $t4, 4($sp)         # Load value from stack for comparison
    beq $t4, $s1, L_pos_1_2_drop # If value matches, go to L_pos_1_2_drop

    addi $s1, $a1, 132     # Calculate another address to check if below the shape is valid
    lw $t4, 8($sp)         # Load value from stack for comparison
    beq $t4, $s1, L_pos_3_drop # If value matches, go to L_pos_3_drop
    j L_pos_4_drop        # Otherwise, go to L_pos_4_drop

L_pos_1_2_drop:
    addi $s1, $a1, 4       # Calculate address to check if right side of shape is valid
    lw $t4, 8($sp)         # Load value from stack for comparison
    beq $t4, $s1, L_pos_2_drop # If value matches, go to L_pos_2_drop
    j L_pos_1_drop        # Otherwise, go to L_pos_1_drop

L_pos_1_drop:
    lw $v0, 8($sp)         # Load value from stack for position 1 drop handling
    lw $v1, 12($sp)        # Load another value from stack for position 1 drop handling
    j base_2_drop         # Jump to base_2_drop for further processing

L_pos_2_drop:   
    lw $v0, 4($sp)         # Load value from stack for position 2 drop handling
    lw $v1, 8($sp)         # Load another value from stack for position 2 drop handling
    lw $s5, 12($sp)        # Load another value from stack for position 2 drop handling
    j base_3_drop         # Jump to base_3_drop for further processing

L_pos_3_drop:
    lw $v0, 0($sp)         # Load value from stack for position 3 drop handling
    lw $v1, 12($sp)        # Load another value from stack for position 3 drop handling
    j base_2_drop         # Jump to base_2_drop for further processing

L_pos_4_drop:   
    lw $v0, 0($sp)         # Load value from stack for position 4 drop handling
    lw $v1, 4($sp)         # Load another value from stack for position 4 drop handling
    lw $s5, 12($sp)        # Load another value from stack for position 4 drop handling
    j base_3_drop         # Jump to base_3_drop for further processing

     
##########################################
# J-shape drop handling
J_shape_drop:
    lw $a1, 0($sp)         # Load the address of the J-shape from the stack
    addi $s1, $a1, 128     # Calculate address to check if below the shape is valid
    lw $t4, 4($sp)         # Load value from stack for comparison
    beq $t4, $s1, J_pos_2_3_drop # If value matches, go to J_pos_2_3_drop
    
    addi $s1, $a1, 136     # Calculate another address to check if below the shape is valid
    lw $t4, 12($sp)        # Load value from stack for comparison
    beq $t4, $s1, J_pos_4_drop # If value matches, go to J_pos_4_drop
    j J_pos_1_drop        # Otherwise, go to J_pos_1_drop

J_pos_2_3_drop:
    addi $s1, $a1, 4       # Calculate address to check if right side of shape is valid
    lw $t4, 12($sp)        # Load value from stack for comparison
    beq $t4, $s1, J_pos_3_drop # If value matches, go to J_pos_3_drop
    j J_pos_2_drop        # Otherwise, go to J_pos_2_drop

J_pos_1_drop: 
    lw $v0, 0($sp)         # Load value from stack for position 1 drop handling
    lw $v1, 12($sp)        # Load another value from stack for position 1 drop handling
    j base_2_drop         # Jump to base_2_drop for further processing

J_pos_2_drop:   
    lw $v0, 4($sp)         # Load value from stack for position 2 drop handling
    lw $v1, 8($sp)         # Load another value from stack for position 2 drop handling
    lw $s5, 12($sp)        # Load another value from stack for position 2 drop handling
    j base_3_drop         # Jump to base_3_drop for further processing

J_pos_3_drop:
    lw $v0, 8($sp)         # Load value from stack for position 3 drop handling
    lw $v1, 12($sp)        # Load another value from stack for position 3 drop handling
    j base_2_drop         # Jump to base_2_drop for further processing

J_pos_4_drop:   
    lw $v0, 0($sp)         # Load value from stack for position 4 drop handling
    lw $v1, 4($sp)         # Load another value from stack for position 4 drop handling
    lw $s5, 12($sp)        # Load another value from stack for position 4 drop handling
    j base_3_drop         # Jump to base_3_drop for further processing

##########################################

# T-shape drop handling
T_shape_drop:
    li $t9, 0x8A8F9A       # Load wall identifier
    lw $a1, 0($sp)         # Load the address of the T-shape from the stack
    
    addi $s1, $a1, 256     # Calculate address to check if right side of shape is valid
    lw $t4, 8($sp)         # Load value from stack for comparison
    beq $t4, $s1, T_pos_4_drop # If value matches, go to T_pos_4_drop
    
    addi $s1, $a1, 4       # Calculate address to check if right down of shape is valid
    lw $t4, 4($sp)         # Load value from stack for comparison
    beq $t4, $s1, T_pos_1_drop # If value matches, go to T_pos_1_drop
    
    addi $s1, $a1, 132     # Calculate address to check if right side of shape is valid
    lw $t4, 12($sp)        # Load value from stack for comparison
    beq $t4, $s1, T_pos_2_drop # If value matches, go to T_pos_2_drop
    j T_pos_3_drop        # Otherwise, go to T_pos_3_drop

T_pos_1_drop:
    lw $v0, 0($sp)         # Load value from stack for position 1 drop handling
    lw $v1, 8($sp)         # Load another value from stack for position 1 drop handling
    lw $s5, 12($sp)        # Load another value from stack for position 1 drop handling
    j base_3_drop         # Jump to base_3_drop for further processing
   
T_pos_2_drop:
    lw $v0, 0($sp)         # Load value from stack for position 2 drop handling
    lw $v1, 12($sp)        # Load another value from stack for position 2 drop handling
    j base_2_drop         # Jump to base_2_drop for further processing

T_pos_3_drop:
    lw $v0, 0($sp)         # Load value from stack for position 3 drop handling
    lw $v1, 8($sp)         # Load another value from stack for position 3 drop handling
    lw $s5, 12($sp)        # Load another value from stack for position 3 drop handling
    j base_3_drop         # Jump to base_3_drop for further processing

T_pos_4_drop:
    lw $v0, 8($sp)         # Load value from stack for position 4 drop handling
    lw $v1, 12($sp)        # Load another value from stack for position 4 drop handling
    j base_2_drop         # Jump to base_2_drop for further processing

########################################
base_1_drop:
    addi $v1, $v1, 128        # Increment $v1 to point to the next row in the display
    lw $t1, 0($v1)           # Load value from the new position in $v1 into $t1
    bne $t1, $t5, base_1_further_check1 # If $t1 is not equal to $t5, jump to further check
    j base_1_update           # Otherwise, jump to base_1_update

base_1_further_check1:
    bne $t1, $t7, exit_drop  # If $t1 is not equal to $t7, jump to exit_drop

base_1_update:
    lw $s0, 0($sp)           # Load address from stack position 0 into $s0
    lw $t3, 0($s0)           # Load color from the address in $s0 into $t3
    addi $s0, $s0, 128       # Move the address in $s0 down by 128 bytes
    
    lw $s4, 4($sp)           # Load address from stack position 4 into $s4
    addi $s4, $s4, 128       # Move the address in $s4 down by 128 bytes
    
    lw $s2, 8($sp)           # Load address from stack position 8 into $s2
    addi $s2, $s2, 128       # Move the address in $s2 down by 128 bytes
    
    lw $s3, 12($sp)          # Load address from stack position 12 into $s3
    addi $s3, $s3, 128       # Move the address in $s3 down by 128 bytes
    
    jal delete_shape         # Call delete_shape subroutine to remove the shape
    
    subi $sp, $sp, 16        # Allocate 16 bytes on the stack for saving state
    sw $s0, 0($sp)           # Save $s0 (address) on the stack
    sw $s4, 4($sp)           # Save $s4 (address) on the stack
    sw $s2, 8($sp)           # Save $s2 (address) on the stack
    sw $s3, 12($sp)          # Save $s3 (address) on the stack
    move $a0, $t3            # Move color into $a0 for use by fill_color
    
    jal fill_color           # Call fill_color subroutine to update the display with color
    j speed                  # Jump to speed for the next operation

######################################
base_2_drop:
    addi $v1, $v1, 128        # Increment $v1 to point to the next row in the display
    addi $v0, $v0, 128        # Increment $v0 to point to the next row in the display
    lw $t1, 0($v1)           # Load value from the new position in $v1 into $t1
    lw $t2, 0($v0)           # Load value from the new position in $v0 into $t2
    bne $t1, $t5, base_2_further_check1 # If $t1 is not equal to $t5, jump to further check
    j base_2_further_check2  # Otherwise, jump to base_2_further_check2

base_2_further_check1:
    bne $t1, $t7, exit_drop  # If $t1 is not equal to $t7, jump to exit_drop   

base_2_further_check2:    
    bne $t2, $t5, base_2_further_check3 # If $t2 is not equal to $t5, jump to further check
    j base_2_update          # Otherwise, jump to base_2_update

base_2_further_check3:    
    bne $t2, $t7, exit_drop  # If $t2 is not equal to $t7, jump to exit_drop

base_2_update:
    lw $s0, 0($sp)           # Load address from stack position 0 into $s0
    lw $t3, 0($s0)           # Load color from the address in $s0 into $t3
    addi $s0, $s0, 128       # Move the address in $s0 down by 128 bytes
    
    lw $s4, 4($sp)           # Load address from stack position 4 into $s4
    addi $s4, $s4, 128       # Move the address in $s4 down by 128 bytes
    
    lw $s2, 8($sp)           # Load address from stack position 8 into $s2
    addi $s2, $s2, 128       # Move the address in $s2 down by 128 bytes
    
    lw $s3, 12($sp)          # Load address from stack position 12 into $s3
    addi $s3, $s3, 128       # Move the address in $s3 down by 128 bytes
    
    jal delete_shape         # Call delete_shape subroutine to remove the shape
    
    subi $sp, $sp, 16        # Allocate 16 bytes on the stack for saving state
    sw $s0, 0($sp)           # Save $s0 (address) on the stack
    sw $s4, 4($sp)           # Save $s4 (address) on the stack
    sw $s2, 8($sp)           # Save $s2 (address) on the stack
    sw $s3, 12($sp)          # Save $s3 (address) on the stack
    move $a0, $t3            # Move color into $a0 for use by fill_color
    
    jal fill_color           # Call fill_color subroutine to update the display with color
    j speed                  # Jump to speed for the next operation
    
                                                                                                                                                                                  
#########################################
base_3_drop:
    addi $v1, $v1, 128        # Increment $v1 to point to the next row in the display
    addi $v0, $v0, 128        # Increment $v0 to point to the next row in the display
    addi $s5, $s5, 128        # Increment $s5 to point to the next row in the display
    lw $t1, 0($v1)           # Load value from the new position in $v1 into $t1
    lw $t2, 0($v0)           # Load value from the new position in $v0 into $t2
    lw $t3, 0($s5)           # Load value from the new position in $s5 into $t3
    bne $t1, $t5, base_3_further_check1 # If $t1 is not equal to $t5, jump to further check
    j base_3_further_check2  # Otherwise, jump to base_3_further_check2
    
base_3_further_check1:
    bne $t1, $t7, exit_drop  # If $t1 is not equal to $t7, jump to exit_drop
    
base_3_further_check2:       
    bne $t2, $t5, base_3_further_check3 # If $t2 is not equal to $t5, jump to further check
    j base_3_further_check4  # Otherwise, jump to base_3_further_check4
    
base_3_further_check3:    
    bne $t2, $t7, exit_drop  # If $t2 is not equal to $t7, jump to exit_drop
    
base_3_further_check4:           
    bne $t3, $t5, base_3_further_check5 # If $t3 is not equal to $t5, jump to further check
    j base_3_update          # Otherwise, jump to base_3_update
    
base_3_further_check5:    
    bne $t3, $t7, exit_drop  # If $t3 is not equal to $t7, jump to exit_drop
    
base_3_update:
    lw $s0, 0($sp)           # Load address from stack position 0 into $s0
    lw $t3, 0($s0)           # Load color from the address in $s0 into $t3
    addi $s0, $s0, 128       # Move the address in $s0 down by 128 bytes
    
    lw $s4, 4($sp)           # Load address from stack position 4 into $s4
    addi $s4, $s4, 128       # Move the address in $s4 down by 128 bytes
    
    lw $s2, 8($sp)           # Load address from stack position 8 into $s2
    addi $s2, $s2, 128       # Move the address in $s2 down by 128 bytes
    
    lw $s3, 12($sp)          # Load address from stack position 12 into $s3
    addi $s3, $s3, 128       # Move the address in $s3 down by 128 bytes
    
    jal delete_shape         # Call delete_shape subroutine to remove the shape
    
    subi $sp, $sp, 16        # Allocate 16 bytes on the stack for saving state
    sw $s0, 0($sp)           # Save $s0 (address) on the stack
    sw $s4, 4($sp)           # Save $s4 (address) on the stack
    sw $s2, 8($sp)           # Save $s2 (address) on the stack
    sw $s3, 12($sp)          # Save $s3 (address) on the stack
    move $a0, $t3            # Move color into $a0 for use by fill_color
    
    jal fill_color           # Call fill_color subroutine to update the display with color
    j speed                  # Jump to speed for the next operation
                                                                                              
#########################################  
base_4_drop:
    addi $v1, $v1, 128        # Increment $v1 to point to the next row in the display
    addi $v0, $v0, 128        # Increment $v0 to point to the next row in the display
    addi $s5, $s5, 128        # Increment $s5 to point to the next row in the display
    addi $s6, $s6, 128        # Increment $s6 to point to the next row in the display
    lw $t1, 0($v1)           # Load value from the new position in $v1 into $t1
    lw $t2, 0($v0)           # Load value from the new position in $v0 into $t2
    lw $t3, 0($s5)           # Load value from the new position in $s5 into $t3
    lw $t4, 0($s6)           # Load value from the new position in $s6 into $t4
    bne $t1, $t5, base_4_further_check1 # If $t1 is not equal to $t5, jump to further check
    j base_4_further_check2  # Otherwise, jump to base_4_further_check2
    
base_4_further_check1:
    bne $t1, $t7, exit_drop  # If $t1 is not equal to $t7, jump to exit_drop
    
base_4_further_check2:       
    bne $t2, $t5, base_4_further_check3 # If $t2 is not equal to $t5, jump to further check
    j base_4_further_check4  # Otherwise, jump to base_4_further_check4
    
base_4_further_check3:    
    bne $t2, $t7, exit_drop  # If $t2 is not equal to $t7, jump to exit_drop
    
base_4_further_check4:           
    bne $t3, $t5, base_4_further_check5 # If $t3 is not equal to $t5, jump to further check
    j base_4_further_check6  # Otherwise, jump to base_4_further_check6
    
base_4_further_check5:    
    bne $t3, $t7, exit_drop  # If $t3 is not equal to $t7, jump to exit_drop
    
base_4_further_check6:           
    bne $t4, $t5, base_4_further_check7 # If $t4 is not equal to $t5, jump to further check
    j base_4_update          # Otherwise, jump to base_4_update
    
base_4_further_check7:    
    bne $t4, $t7, exit_drop  # If $t4 is not equal to $t7, jump to exit_drop    
    
base_4_update:
    lw $s0, 0($sp)           # Load address from stack position 0 into $s0
    lw $t3, 0($s0)           # Load color from the address in $s0 into $t3
    addi $s0, $s0, 128       # Move the address in $s0 down by 128 bytes
    
    lw $s4, 4($sp)           # Load address from stack position 4 into $s4
    addi $s4, $s4, 128       # Move the address in $s4 down by 128 bytes
    
    lw $s2, 8($sp)           # Load address from stack position 8 into $s2
    addi $s2, $s2, 128       # Move the address in $s2 down by 128 bytes
    
    lw $s3, 12($sp)          # Load address from stack position 12 into $s3
    addi $s3, $s3, 128       # Move the address in $s3 down by 128 bytes
    
    jal delete_shape         # Call delete_shape subroutine to remove the shape
    
    subi $sp, $sp, 16        # Allocate 16 bytes on the stack for saving state
    sw $s0, 0($sp)           # Save $s0 (address) on the stack
    sw $s4, 4($sp)           # Save $s4 (address) on the stack
    sw $s2, 8($sp)           # Save $s2 (address) on the stack
    sw $s3, 12($sp)          # Save $s3 (address) on the stack
    move $a0, $t3            # Move color into $a0 for use by fill_color
    
    jal fill_color           # Call fill_color subroutine to update the display with color
    j speed                  # Jump to speed for the next operation

exit_drop:
    jal calculate_row        # Call calculate_row subroutine to compute row information
    addi $sp, $sp, 16        # Deallocate 16 bytes from the stack
    jal sorted_rows          # Call sorted_rows subroutine to sort rows
    jal remove_duplicate     # Call remove_duplicate subroutine to remove duplicates
    la $s7, row_to_delete    # Load address of row_to_delete into $s7
    li $s3, 0                # Initialize $s3 to 0
    
check_row_loop:
    beq $t4, 0, start       # If $t4 is 0, jump to start
    lw $a1, 0($sp)          # Load address from stack into $a1
    add $a1, $a1, $s3       # Add offset to $a1
    
    jal Row_check           # Call Row_check subroutine to check the row
    addi $sp, $sp, 4        # Move stack pointer down by 4 bytes
    subi $t4, $t4, 1        # Decrement $t4 by 1
    la $s7, row_to_delete   # Load address of row_to_delete into $s7
    lw $a1, 0($s7)         # Load value from row_to_delete into $a1

    beq $a1, -1, cross     # If $a1 is -1, jump to cross
    beq $a1, 0, check_row_loop # If $a1 is 0, repeat check_row_loop
    jal Delete_row          # Call Delete_row subroutine to delete the row
    
    la $s7, Mark            # Load address of Mark into $s7
    lw $t1, 0($s7)          # Load value of Mark into $t1

cross:
    li $a1, 1584            # Load value 1584 into $a1
    li $a0, 0xFF0000        # Load red color value into $a0
    jal draw_x              # Call draw_x subroutine to draw an X
    j Terminate_program     # Jump to Terminate_program
    
check_mark:
    beq $t1, 0, mark_to_1  # If $t1 is 0, jump to mark_to_1
    beq $t1, 1, mark_to_2  # If $t1 is 1, jump to mark_to_2
    beq $t1, 2, mark_to_3  # If $t1 is 2, jump to mark_to_3
    beq $t1, 3, mark_to_4  # If $t1 is 3, jump to mark_to_4
    j delete_update        # Otherwise, jump to delete_update

mark_to_1:
    li $a1, 3460            # Load value 3460 into $a1
    li $a0, 0x8A8F9A        # Load color value into $a0
    jal draw_0              # Call draw_0 subroutine
    li $a0, 0xF5C6C6        # Load color value into $a0
    jal draw_1              # Call draw_1 subroutine
    j delete_update         # Jump to delete_update

mark_to_2:
    li $a1, 3460            # Load value 3460 into $a1
    li $a0, 0x8A8F9A        # Load color value into $a0
    jal draw_1              # Call draw_1 subroutine
    li $a0, 0xF5C6C6        # Load color value into $a0
    jal draw_2              # Call draw_2 subroutine
    j delete_update         # Jump to delete_update

mark_to_3:    
    li $a1, 3460            # Load value 3460 into $a1
    li $a0, 0x8A8F9A        # Load color value into $a0
    jal draw_2              # Call draw_2 subroutine
    li $a0, 0xF5C6C6        # Load color value into $a0
    jal draw_3              # Call draw_3 subroutine
    j delete_update         # Jump to delete_update

mark_to_4:    
    li $a1, 3460            # Load value 3460 into $a1
    li $a0, 0x8A8F9A        # Load color value into $a0
    jal draw_3              # Call draw_3 subroutine
    li $a0, 0xF5C6C6        # Load color value into $a0
    jal draw_4              # Call draw_4 subroutine
    li $a1, 1592            # Load value 1592 into $a1
    li $a0, 0xFF0000        # Load red color value into $a0
    jal draw_w              # Call draw_w subroutine to draw a W
    j Terminate_program     # Jump to Terminate_program
    
delete_update:
    la $s7, Mark            # Load address of Mark into $s7
    lw $a0, 0($s7)          # Load value of Mark into $a0
    addi $a0, $a0, 1        # Increment $a0
    sw $a0, 0($s7)          # Store updated value back to Mark
    
    la $s7, row_to_delete   # Load address of row_to_delete into $s7
    la $s5, max_row         # Load address of max_row into $s5
    lw $s4, 0($s5)          # Load value from max_row into $s4
    addi $s4, $s4, 1        # Increment $s4
    lw $s4, 0($s5)          # Store incremented value back to max_row
    
    addi $s3, $s3, 1        # Increment $s3
    li $a1, 0               # Load 0 into $a1
    sw $a1, 0($s7)          # Store 0 into row_to_delete
    j check_row_loop        # Jump to check_row_loop

Terminate_program:
    la $s7, row_to_delete   # Load address of row_to_delete into $s7
    la $s5, max_row         # Load address of max_row into $s5
    li $t1, 0               # Load 0 into $t1
    sw $t1, 0($s7)          # Store 0 into row_to_delete
    li $t1, 30              # Load 30 into $t1
    sw $t1, 0($s5)          # Store 30 into max_row
    la $s7, change_shape_chance # Load address of change_shape_chance into $s7
    la $s5, Mark            # Load address of Mark into $s5
    li $t1, 0               # Load 0 into $t1
    sw $t1, 0($s5)          # Store 0 into Mark
    li $t1, 3               # Load 3 into $t1
    sw $t1, 0($s7)          # Store 3 into change_shape_chance
    mul $t4, $t4, 4         # Multiply $t4 by 4
    add $sp, $sp, $t4       # Deallocate stack space
    
check_reset:    
    lw $t0, ADDR_KBRD       # Load base address for keyboard into $t0
    lw $t8, 0($t0)          # Load first word from keyboard into $t8
    beq $t8, 1, check_r    # If $t8 equals 1, jump to check_r
    j check_reset          # Otherwise, repeat check_reset

check_r:
    lw $a0, 4($t0)          # Load second word from keyboard into $a0
    beq $a0, 0x72, reset   # If $a0 equals 0x72, jump to reset
    beq $a0, 0x71, Terminate # If $a0 equals 0x71, jump to Terminate
    j check_reset          # Otherwise, repeat check_reset

reset:
    j main                 # Jump to main to reset the program
    
##############################################################
#FUNCTION START HERE
##############################################################################
Delete_row:
    lw $t0, ADDR_DSPL                # Load the base address of the display
    li $t5, 0xE4DCD1                 # Define grey color
    li $t7, 0xC5CCD6                 # Define white color
    la $s5, max_row                  # Load the address of max_row
    lw $s5, 0($s5)                   # Load the value of max_row into $s5
    la $s7, row_to_delete            # Load the address of row_to_delete
    lw $s7, 0($s7)                   # Load the row number to delete into $s7
    
    mul $t6, $s7, 128                # Calculate the base address of the row to delete
    addi $t6, $t6, 12                # Offset to the start of the row data
    add $t6, $t0, $t6                # Calculate the address of the row in the display
    
    addi $t8, $t6, 100               # Calculate the end address of the row (100 pixels ahead)

Delete_row_outer_loop:
    bgt $s5, $s7, exit_delete_row   # If current row ($s5) > row_to_delete ($s7), exit loop
    
Delete_row_inner_loop:        
    subi $t9, $t6, 128              # Move to the previous pixel in the row
    lw $t9, 0($t9)                  # Load the color of the pixel
    bgt $t6, $t8, exit_delete_row_inner_loop  # If address > end address, exit inner loop
    beq $t9, $t5, color_white       # If pixel is grey, go to color_white
    beq $t9, $t7, color_grey        # If pixel is white, go to color_grey
    sw $t9, 0($t6)                  # Store the color of the pixel (no change)
    j delete_row_inner_update       # Update and continue
    
color_white:
    sw $t7, 0($t6)                  # Change pixel to white
    j delete_row_inner_update       # Update and continue
    
color_grey:
    sw $t5, 0($t6)                  # Change pixel to grey
    
delete_row_inner_update:
    addi $t6, $t6, 4                # Move to the next pixel
    j Delete_row_inner_loop         # Continue inner loop
    
exit_delete_row_inner_loop:
    subi $s7, $s7, 1                # Decrease the row to delete counter
    mul $t6, $s7, 128              # Recalculate the base address for the next row
    addi $t6, $t6, 12                # Offset to the start of the row data
    add $t6, $t0, $t6                # Calculate the address of the row in the display
    
    addi $t8, $t6, 100               # Recalculate the end address of the row
    j Delete_row_outer_loop         # Continue outer loop
    
exit_delete_row:
    jr $ra                          # Return from function

#########################################

Row_check:
    lw $t0, ADDR_DSPL                # Load the base address of the display
    move $t6, $a1                    # Move the row number (argument) to $t6
    la $s7, row_to_delete            # Load the address of row_to_delete
    
    mul $t6, $t6, 128                # Calculate the base address of the row
    addi $t6, $t6, 12                # Offset to the start of the row data
    add $t6, $t0, $t6                # Calculate the address of the row in the display
    lw $t9, 0($t6)                  # Load the first pixel of the row
    
    addi $t8, $t6, 100               # Calculate the end address of the row (100 pixels ahead)

    li $t5, 0xE4DCD1                 # Define grey color
    li $t7, 0xC5CCD6                 # Define white color
    
    blt $a1, 5, End_game            # If the row number < 5, end the game
    
check_rows_inner_loop:
    lw $t9, 0($t6)                  # Load the color of the pixel
    bgt $t6, $t8, Full              # If address > end address, row is full
    beq $t9, $t5, Not_full         # If pixel is grey, row is not full
    
further_check_row_color: 
    beq $t9, $t7, Not_full         # If pixel is white, row is not full
    
check_rows_inner_loop_update:
    addi $t6, $t6, 4                # Move to the next pixel
    j check_rows_inner_loop         # Continue checking

Not_full:
    jr $ra                          # Return if the row is not full
    
Full:
    la $s7, row_to_delete            # Load the address of row_to_delete
    sw $a1, 0($s7)                   # Store the row number as full
    
    jr $ra                          # Return
    
End_game:
    li $t6, -1                       # Set the flag to indicate end of game
    sw $t6, 0($s7)                  # Store the flag in row_to_delete
    
    jr $ra                          # Return


##############################################################################
sorted_rows:
    la $s7, numbers                # Load the base address of the numbers array into $s7
    lw $s0, 0($s7)                 # Load numbers[0] into $s0
    lw $s1, 4($s7)                 # Load numbers[1] into $s1
    lw $s2, 8($s7)                 # Load numbers[2] into $s2
    lw $s3, 12($s7)                # Load numbers[3] into $s3
    lw $a0, 0($s7)                 # Load the first element into $a0
    
    li $s0, 0                      # Initialize outer loop counter to 0
    li $s6, 3                      # Set loop limit for outer loop (n - 1, where n = 4 elements)

sort_loop:
    li $s1, 0                      # Reset inner loop counter

inner_loop:
    sll $t7, $s1, 2                # Calculate the address offset (s1 * 4)
    add $t7, $s7, $t7              # Address of numbers[s1]
    
    lw $t0, 0($t7)                 # Load numbers[s1] into $t0
    lw $t1, 4($t7)                 # Load numbers[s1 + 1] into $t1

    sgt $t2, $t1, $t0              # Check if $t1 > $t0 (next element > current element)
    beq $t2, $zero, no_swap        # If $t2 == 0, no swap needed

    # Swap elements
    sw $t1, 0($t7)                 # Store numbers[s1 + 1] in numbers[s1]
    sw $t0, 4($t7)                 # Store numbers[s1] in numbers[s1 + 1]

no_swap:
    addi $s1, $s1, 1               # Increment inner loop counter
    sub $s5, $s6, $s0              # Calculate the remaining iterations for inner loop
    bne $s1, $s5, inner_loop       # If $s1 != $s5, continue inner loop

    addi $s0, $s0, 1               # Increment outer loop counter
    li $s1, 0                      # Reset inner loop counter
    bne $s0, $s6, sort_loop        # If $s0 != $s6, continue outer loop

final:
    lw $a0, 12($s7)                # Load the last element into $a0
    la $a1, max_row                # Load the address of max_row into $a1
    lw $a2, 0($a1)                 # Load the value of max_row into $a2
    ble $a0, $a2, update_max_row   # If $a0 <= $a2, go to update_max_row
    j update_final                 # Otherwise, go to update_final
    
update_max_row:
    sw $a0, 0($a1)                 # Update max_row with $a0
    
update_final: 
    lw $a0, 0($s7)                 # Load the first element into $a0
    lw $a1, 12($s7)                # Load the last element into $a1
    sw $a0, 12($s7)                # Swap first and last elements
    sw $a1, 0($s7)                 # Swap first and last elements
    
    lw $a0, 4($s7)                 # Load the second element into $a0
    lw $a1, 8($s7)                 # Load the third element into $a1
    sw $a0, 8($s7)                 # Swap second and third elements
    sw $a1, 4($s7)                 # Swap second and third elements
      
    jr $ra                         # Return from function

##############################################################################
##############################################################################

remove_duplicate:
    li $t2, 0                      # Initialize counter for unique values
    li $t4, 0                      # Initialize counter for processed values
    la $s7, numbers                # Load the base address of the numbers array into $s7
    lw $v1, 0($s7)                 # Load the first element into $v1
    lw $s6, 4($s7)                 # Load the second element into $s6 
    
check_loop:
    bgt $t2, 2, exit_duplicate_loop # If counter $t2 > 2, exit the loop
    beq $v1, $s6, update            # If current element == next element, go to update
    subi $sp, $sp, 4                # Allocate space on stack for unique value
    sw $v1, 0($sp)                  # Save the unique value to stack
    
    addi $t4, $t4, 1                # Increment processed value counter
    
update:
   addi $t2, $t2, 1                # Increment unique value counter
   mul $t3, $t2, 4                 # Calculate offset for the next element
   add $v1, $s7, $t3              # Address of the next element
   lw $v1, 0($v1)                 # Load the next element into $v1
   addi $t3, $t3, 4               # Increment offset
   add $s6, $s7, $t3              # Address of the element after the next
   lw $s6, 0($s6)                 # Load the element after the next into $s6
   j check_loop                   # Continue checking loop
       
exit_duplicate_loop: 
    subi $sp, $sp, 4                # Allocate space on stack for remaining values
    lw $s6, 12($s7)                # Load the last element into $s6
    sw $s6, 0($sp)                 # Save the last element to stack
    addi $t4, $t4, 1               # Increment counter for processed values
    
    jr $ra                         # Return from function
                                                                   
##############################################################################
##############################################################################
calculate_row:
    lw $t0, ADDR_DSPL          # Load base address of display into $t0
    la $s0, numbers            # Load address of numbers array into $s0
    li $t1, 128                # Set divisor for calculating row numbers

    lw $a0, 0($sp)             # Load address value from stack
    sub $a0, $a0, $t0          # Calculate address offset from base address
    div $a0, $t1               # Divide by 128 to get row number
    mflo $a0                   # Get quotient (row number)
    sw $a0, 0($s0)             # Store result in numbers[0]

    lw $a0, 4($sp)             # Load next address value from stack
    sub $a0, $a0, $t0          # Calculate address offset from base address
    div $a0, $t1               # Divide by 128 to get row number
    mflo $a0                   # Get quotient (row number)
    sw $a0, 4($s0)             # Store result in numbers[1]

    lw $a0, 8($sp)             # Load next address value from stack
    sub $a0, $a0, $t0          # Calculate address offset from base address
    div $a0, $t1               # Divide by 128 to get row number
    mflo $a0                   # Get quotient (row number)
    sw $a0, 8($s0)             # Store result in numbers[2]

    lw $a0, 12($sp)            # Load next address value from stack
    sub $a0, $a0, $t0          # Calculate address offset from base address
    div $a0, $t1               # Divide by 128 to get row number
    mflo $a0                   # Get quotient (row number)
    sw $a0, 12($s0)            # Store result in numbers[3]

    jr $ra                     # Return from function

##############################################################
delete_shape:
    li $t5, 0xE4DCD1           # Define grey color
    li $t7, 0xC5CCD6           # Define white color
    li $t9, 0x8A8F9A           # Define wall color
    li $t2, 4                  # Set initial counter value
    
    li $t6, 1                  # Initialize flag for left checking
    lw $a1, 0($sp)             # Load address from stack
    subi $s1, $a1, 4           # Calculate address of the element to the left
    lw $t4, 0($s1)             # Load the value at the calculated address
    bne $t4, $t9, left_loop    # If not wall color, proceed to left_loop

    li $t6, 0                  # Reset flag for left checking
    lw $t9, 12($sp)            # Load address of the element at the end
    sw $a1, 12($sp)            # Swap addresses
    sw $t9, 0($sp)             # Swap addresses
    
    lw $a1, 4($sp)             # Load address of the next element
    lw $t9, 8($sp)             # Load address of the element to the right
    sw $a1, 8($sp)             # Swap addresses
    sw $t9, 4($sp)             # Swap addresses
    lw $a1, 0($sp)             # Reload address

left_loop: 
    beq $t2, 0, exit_deletetion # If counter is 0, exit the loop
    lw $a1, 0($sp)             # Load address from stack
    
    beq $t6, 1, check_left    # If flag is 1, check left
    addi $s1, $a1, 4          # Otherwise, check color on the right
    j check_color
    
check_left:
    subi $s1, $a1, 4          # Check color on the left
    
check_color:    
    lw $t4, 0($s1)            # Load color value at the left address
    beq $t4, $t7, left_grey   # If grey color, go to left_grey
    beq $t4, $t5, left_white  # If white color, go to left_white
    
left_grey:
    sw $t5, 0($a1)            # Set color to grey
    j left_update
    
left_white:
    sw $t7, 0($a1)            # Set color to white
    j left_update
     
left_update:  
    addi $sp, $sp, 4          # Deallocate stack space
    subi $t2, $t2, 1          # Decrement counter
    j left_loop               # Continue left_loop
        
exit_deletetion:
    jr $ra                    # Return from function

#############################################################                                                                                                                                                                                                                                                                                                                                                                                                                                            
fill_color:
    li $t2, 1            # Initialize counter (starting value)
    lw $t6, 0($sp)       # Load base address from stack into $t6

fill_loop:
    beq $t2, 5, exit_fill_color  # Exit loop when counter equals 5
    sw $a0, 0($t6)      # Store value in $a0 at address $t6

fill_color_update:
    mul $t3, $t2, 4     # Compute offset (4 bytes per element)
    add $t3, $sp, $t3   # Update address in $t6
    lw $t6, 0($t3)      # Load the next address from the updated address
    addi $t2, $t2, 1    # Increment counter
    j fill_loop         # Repeat loop

exit_fill_color:
    jr $ra              # Return from function

###############################################################
random_shape:
   li $v0, 42          # Set up syscall number for random number generation
   li $a0, 0           # Set lower bound of random number range
   li $a1, 7           # Set upper bound of random number range
   syscall             # Generate random number within the range
    
   move $t1, $a0       # Move the generated random number into $t1 (random shape of Tetrominoes)
   jr $ra              # Return from function

##################################################################################
draw_x:
    lw $t0, ADDR_DSPL  # Load the base address of the display
    add $t6, $t0, $a1  # Calculate the starting address based on input offset ($a1)
    move $t1, $a0      # Color value in $a0

    # First diagonal (\)
    sw $t1, 0($t6)         # (0, 0)
    addi $t7, $t6, 132     # (1, 1)
    sw $t1, 0($t7)
    addi $t7, $t7, 132     # (2, 2)
    sw $t1, 0($t7)
    addi $t7, $t7, 132     # (3, 3)
    sw $t1, 0($t7)
    addi $t7, $t7, 132     # (4, 4)
    sw $t1, 0($t7)
    addi $t7, $t7, 132     # (5, 5)
    sw $t1, 0($t7)
    addi $t7, $t7, 132     # (6, 6)
    sw $t1, 0($t7)
    addi $t7, $t7, 132     # (7, 7)
    sw $t1, 0($t7)

    # Second diagonal (/)
    lw $t0, ADDR_DSPL  # Load the base address of the display
    add $t6, $t0, $a1
    addi $t6, $t6, 28      # (7, 0)
    sw $t1, 0($t6)
    addi $t7, $t6, 124     # (6, 1)
    sw $t1, 0($t7)
    addi $t7, $t7, 124     # (5, 2)
    sw $t1, 0($t7)
    addi $t7, $t7, 124     # (4, 3)
    sw $t1, 0($t7)
    addi $t7, $t7, 124     # (3, 4)
    sw $t1, 0($t7)
    addi $t7, $t7, 124     # (2, 5)
    sw $t1, 0($t7)
    addi $t7, $t7, 124     # (1, 6)
    sw $t1, 0($t7)
    addi $t7, $t7, 124     # (0, 7)
    sw $t1, 0($t7)

    jr $ra                # Return from the function

##################################################################################    
draw_p:
    lw $t0, ADDR_DSPL
    add $t6, $t0, $a1
    move $t1, $a0
    sw $t1, 0($t6)
    addi $t7, $t6, 4
    sw $t1, 0($t7)
    addi $t7, $t6, 128
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)
    addi $t7, $t6, 260
    sw $t1, 0($t7)
    addi $t7, $t6, 384
    sw $t1, 0($t7)
    addi $t7, $t6, 512
    sw $t1, 0($t7)
    
    addi $t6, $t6, 8
    sw $t1, 0($t6)
    addi $t7, $t6, 128
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)

    jr $ra
##################################################################################
draw_w:
    lw $t0, ADDR_DSPL
    add $t6, $t0, $a1
    move $t1, $a0
    sw $t1, 0($t6)
    addi $t7, $t6, 128
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)
    addi $t7, $t6, 384
    sw $t1, 0($t7)
    addi $t7, $t6, 388
    sw $t1, 0($t7)
    addi $t7, $t6, 392
    sw $t1, 0($t7)
    addi $t7, $t6, 396
    sw $t1, 0($t7)
    addi $t7, $t6, 264
    sw $t1, 0($t7)
    
    addi $t6, $t6, 16
    sw $t1, 0($t6)
    addi $t7, $t6, 128
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)
    addi $t7, $t6, 384
    sw $t1, 0($t7)

    jr $ra
################################################################################## 
draw_4:
    lw $t0, ADDR_DSPL
    add $t6, $t0, $a1
    move $t1, $a0
    sw $t1, 0($t6)
    addi $t7, $t6, 128
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)
    addi $t7, $t6, 384
    sw $t1, 0($t7)
    addi $t7, $t6, 388
    sw $t1, 0($t7)
    
    addi $t6, $t6, 8
    sw $t1, 0($t6)
    addi $t7, $t6, 128
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)
    addi $t7, $t6, 384
    sw $t1, 0($t7)
    addi $t7, $t6, 512
    sw $t1, 0($t7)
    jr $ra
##################################################################################    
draw_3:
    lw $t0, ADDR_DSPL
    add $t6, $t0, $a1
    move $t1, $a0
    sw $t1, 0($t6)
    addi $t7, $t6, 4
    sw $t1, 0($t7)
    addi $t7, $t6, 132
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)
    addi $t7, $t6, 260
    sw $t1, 0($t7)
    addi $t7, $t6, 388
    sw $t1, 0($t7)
    addi $t7, $t6, 516
    sw $t1, 0($t7)
    addi $t7, $t6, 512
    sw $t1, 0($t7)
    jr $ra
##################################################################################  
draw_2:
    lw $t0, ADDR_DSPL
    add $t6, $t0, $a1
    move $t1, $a0
    sw $t1, 0($t6)
    addi $t7, $t6, 4
    sw $t1, 0($t7)
    addi $t7, $t6, 132
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)
    addi $t7, $t6, 260
    sw $t1, 0($t7)
    addi $t7, $t6, 384
    sw $t1, 0($t7)
    addi $t7, $t6, 516
    sw $t1, 0($t7)
    addi $t7, $t6, 512
    sw $t1, 0($t7)
    jr $ra
################################################################################## 
draw_1:
    lw $t0, ADDR_DSPL
    add $t6, $t0, $a1
    move $t1, $a0
    sw $t1, 0($t6)
    addi $t7, $t6, 128
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)
    addi $t7, $t6, 384
    sw $t1, 0($t7)
    addi $t7, $t6, 512
    sw $t1, 0($t7)
    jr $ra
##################################################################################
draw_0:
    lw $t0, ADDR_DSPL
    add $t6, $t0, $a1
    move $t1, $a0
    sw $t1, 0($t6)
    addi $t7, $t6, 4
    sw $t1, 0($t7)
    addi $t7, $t6, 128
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)
    addi $t7, $t6, 384
    sw $t1, 0($t7)
    addi $t7, $t6, 512
    sw $t1, 0($t7)
    addi $t7, $t6, 516
    sw $t1, 0($t7)
    addi $t6, $t6, 8
    sw $t1, 0($t6)
    addi $t7, $t6, 128
    sw $t1, 0($t7)
    addi $t7, $t6, 256
    sw $t1, 0($t7)
    addi $t7, $t6, 384
    sw $t1, 0($t7)
    addi $t7, $t6, 512
    sw $t1, 0($t7)
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
    bge $t2, 26, wall         # If y == 255 (last row), draw wall

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
   
