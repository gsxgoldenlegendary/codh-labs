.text
.align 2
addi a0,zero,1		#test addi, show in registers file
li s1,0xffff0010		#command right seven segment display 
sw a0,0(s1)
ebreak			#test sw, show in digital lab sim
lw a1,0(s1)		#test lw. show in registers file 
sw a1,0(s1)
LOOP:
add a2,a0,a2		#test add, show in register file
sw a2,0(s1)		
beq a0,a2,LOOP		#test beq, only go to LOOP once
jal zero,LOOP		#test jal, go to LOOP infinitely
