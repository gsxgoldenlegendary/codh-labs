.text
 	lw 	s1,64(zero)		#cycle const
 	add 	a2,zero,zero		#outcycle counter
 	addi	a4,zero,64		#outcycle pointer	
	addi	a4,a4,4
 beginOutCycle:
 	beq 	s1,a2,endOutCycle	#judge outcycle
 	addi 	a3,a2,1			#incycle counter
 	addi 	a5,a4,4			#incycle pointer
 beginInCycle:
 	beq 	s1,a3,endInCycle		#judge incycle
 	lw 	a6,0(a4)			#get element from array
 	lw	a7,0(a5)			#get element from array
 	blt	a6,a7,noMove
 	sw	a6,0(a5)			#move elements
 	sw	a7,0(a4)
 noMove:
 	addi 	a5,a5,4			#add incycle pointer 
 	addi	a3,a3,1			#add incycle counterer
 	jal	zero,beginInCycle	
 endInCycle:
 	addi 	a4,a4,4			#add outcycle pointer 
 	addi	a2,a2,1			#add outcycle counterer
 	jal	zero,beginOutCycle	
 endOutCycle:
 
 	addi 	s0,zero,8		#output
 	addi	s2,zero,12
 	addi	s3,zero,1
 	add 	a2,zero,zero		#outcycle counter
 	addi	a4,zero,64
 	addi	a4,a4,4
 beginOutputCycle:
 	beq 	s1,a2,endOutputCycle		#judge incycle
 	lw 	a1,0(a4)			#get element from array
 	sw	a1,0(s0)
OutputValid:
 	lw	a7,0(s2)
 	beq	a7,zero,OutputValid	
OutputReady:
 	lw	a7,0(s2)
 	beq	a7,s3,OutputReady
 	addi 	a4,a4,4			#add outcycle pointer 
 	addi	a2,a2,1			#add outcycle counterer
 	jal	zero,beginOutputCycle
 endOutputCycle:
 	
