
# Xep hau tren ban co vuong sao cho chung khong an duoc nhau#

.data
	size_string: .asciiz "Nhap kich co ban co: "
	solution_string: .asciiz "Giai phap cua bai toan:\n"
	solution: .asciiz "Solution: "
	Default: .asciiz "Khong co cach xep nao thoa man.\n\n"
	continue: .asciiz "Ban muon tim trong ban co khac khong?\n 1.Tiep tuc nao! \n 2.Met rui @_@ tam dung nhe!\n"
	choice: .asciiz " Nhan so lua chon: "
	ketthuc: .asciiz "Thank you for your attention ^_^ See you soon.\n"
.text
main: 
	
	la $a0, size_string                   
	li $v0, 4			#in chuoi
	syscall                               

	li $v0, 5		 #input N
	syscall                     

	ble $v0,$0,main
	addi $s1, $v0, 0               #$s1 = N

	la $a0, solution_string       #in chuoi         
	li $v0, 4
	syscall                              

	sub $sp, $sp, $s1                     #cap phat N byte tren stack
	addi $s2, $sp, 0                      #$s2 = vi tri luu tru array


#tránh luu de len nhau trong stack
	addi $t0, $zero, 4                    #$t0 = 4 (moi word 4 byte)
	div $s1, $t0                          
	mfhi $t3                              # $t3 = N mod 4
	sub $t0, $t0, $t3                     # $t0 = 4 - (N mod 4)
	sub $sp, $sp, $t0                     # ha vi tri con tro xuong 4 - (N mod 4) byte trong stack
                         
#goi solve
	addi $a0, $zero,1                    #$a0 <-- tham s? t?ng sô hàng 
	addi $t4,$zero,0		# hien so luong cach xep
	jal solve                             #goi solve
	
	
	beq $t4,$zero,exception
	
	j Request            #Menu lua chon cho user

exception:
	li $v0,4
	la $a0,Default
	syscall
Request:
	li $v0,4
	la $a0,continue
	syscall
	
	la $a0,choice
	syscall
	
	li $v0,5
	syscall
	add $t1,$v0,$zero
	
	li $v0,11
	la $a0,10
	syscall
	
	beq $t1,1,main
	
	li $v0,4
	la $a0,ketthuc
	syscall
	
endPro:
	li $v0, 10                            
	syscall 		 #end

#----------> SOLVE <--------------

solve:
	addi $sp, $sp, -12                      #mo rong stack
	sw $ra, 0($sp)				#luu dia chi tra ve
	sw $s3, 4($sp)				#luu hang dang xet
	sw $s0, 8($sp)                          #luu cot dang xet
	
	add $s3, $a0, $zero  			#$s3 la hang dang xet
		
check:  
	ble $s3, $s1, recursion                 #dieu kien d?ng de quy $s3>$s1
	
#in ra so cach dat quan hau	
	addi $t4,$t4,1				
	li $v0,4
	la $a0,solution
	syscall
	
	li $v0,	1
	add $a0,$zero,$t4
	syscall

	li $v0, 11
	li $a0, 10                            
	syscall

#in vi tri cua quan hau tren ban co	
	addi $t0, $zero, 1 
                  
loopPrint:
	add $t1, $t0, $s2
	lb $a1, 0($t1)
	li $t2,1
	
	jal loopspace

print:
	add $a0,$a1,$zero
	li $v0,1
	syscall	
	
	li $v0, 11
	li $a0, 10                            
	syscall 
	
	addi $t0, $t0, 1
	ble $t0, $s1, loopPrint
		
	li $v0, 11
	li $a0, 10                            
	syscall 	                      
	
	j end                #ket thuc mot cach xep
loopspace: # in dau cach
	li $v0,11
	li $a0,32
	syscall
	
	addi $t2,$t2,1
	ble $t2,$a1,loopspace
	jr $ra

end:	
	#lay lai cac gia tri cua buoc truoc do		
	lw $s0, 8($sp)                     	# $s0 la vi tri cua cot duoc xet
	lw $s3, 4($sp)				# $s3 la hang can xet
	lw $ra, 0($sp) 				#lay dia chi tro ve buoc de quy truoc do
	addi $sp, $sp, 12	#nang satck lên 
	
	jr $ra			#nhay ve recursion truoc do, tang $s0 de xet cot thoa man khac cho hang $s3	
	
recursion:
    	addi $s0, $zero, 1                 #$s0 = j = 1, vi tri cot dang xet
        
loop:
	add $a0, $s3, $zero		#$a0 <-- hang dang xet
	add $a1, $s0, $zero                #$a1 <-- vi tri cot
	jal isSafe		#goi ham isSafe kiem tra vi tri dat an toan
	beq $v0, $zero,endloop
		add $t0, $s2, $s3              # position[i]                 
		sb $s0, 0($t0)                 
		addi $a0, $s3, 1               #$a0 <-- i+1
		jal solve                      #goisolve
	endloop:
	addi $s0, $s0, 1                   #j++
	ble $s0, $s1, loop                 #j<=N
	j end
	
#---------> isSafe <----------
isSafe:

	addi $t0, $zero, 1                    # $t0 = 1
loopSafe:
    beq $t0, $a0, returnTrue                # neu hang $t0 < hang $a0  thi lap
	add $t1, $t0, $s2		
	lb $t1, 0($t1)                        #$t1 bang vi tri cot cua hang truoc hang dang xet
	beq $t1, $a1, returnFalse             #neu cot bang nhau loai
	sub $t2, $a0, $t0                     #  i-k = |A(k)-j| thi loai(i là xet,k<i là hang tren hang i)
	sub $t3, $a1, $t1                     #  A(k)là cot tuong ung voi hang k, j la cot ung voi i
	beq $t2, $t3, returnFalse             # i-k = j-A(k)
	sub $t3, $t1, $a1                     #        
	beq $t2, $t3, returnFalse             # i-k = A(k)-j
	addi $t0, $t0, 1                      # k++
	j loopSafe
	
returnTrue:	
	addi $v0, $zero, 1                    #return true
	j endSafe
returnFalse:
	addi $v0, $zero, 0                    #return false	
	
endSafe:
	jr $ra

