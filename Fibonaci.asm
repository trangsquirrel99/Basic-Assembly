.data
	Nhap1: .asciiz " Tinh so hang Fibonacci thu : "
	Nhap2: .asciiz " So hang thu "
	Nhap3: .asciiz " cua day Fibonacci la :"
	

.text
.globl main
main:
	li $v0,4
	la $a0,Nhap1
	syscall
	
	li $v0,5
	syscall
	move $a0,$v0
	jal fibonacci
	
	move $t0,$a0
	move $t1,$v0
	li $v0,4
	la $a0,Nhap2
	syscall
	
	li $v0,1
	move $a0,$t0
	syscall
	
	li $v0,4
	la $a0,Nhap3
	syscall
	
	li $v0,1
	move $a0,$t1
	syscall
	
	li $v0,10
	syscall
.text
.globl fibonacci
fibonacci:
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $a0,4($sp)
	
	slti $t0,$a0,1
	beq $t0,$zero,L1
	li $v0,0
	addi $sp,$sp,12
	jr $ra

	L1: 
	 slti $t0,$a0,2
	 beq $t0,$zero,L2
	 li $v0,1
	 addi $sp,$sp,12
	 jr $ra
	L2:
	 addi $a0,$a0,-1
	 jal fibonacci
	 sw $v0,8($sp)
	 
	 lw $a0,4($sp)
	 addi $a0,$a0,-2
	 jal fibonacci
	 lw $t0,8($sp)
	 add $v0,$v0,$t0
	
	 lw $ra,0($sp)
	 lw $a0,4($sp)
	 addi $sp,$sp,12
	 jr $ra
	
	
