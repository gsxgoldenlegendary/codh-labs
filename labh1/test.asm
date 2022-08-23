.text
  	lw 	s1,a			#cycle const
  	add 	a2,zero,zero		#outcycle counter
  	li 	s0,0xffff000c		#output
 	li	s2,0xffff0008
 	li	s3,1
 	lui 	a4,%hi(a)		#cycle pointer
 	addi 	a4,a4,%lo(a)
 	addi	a4,a4,4
 beginOutputCycle:
 	beq 	s1,a2,endOutputCycle		#judge incycle
 	lw 	a1,0(a4)			#get element from array
 	sw	s3,0(s2)
 	sw	a1,0(s0)
 	addi 	a4,a4,4			#add outcycle pointer 
 	addi	a2,a2,1			#add outcycle counterer
 	jal	zero,beginOutputCycle
 endOutputCycle:
 .data
 a:
 	.word	1
 	.word	65