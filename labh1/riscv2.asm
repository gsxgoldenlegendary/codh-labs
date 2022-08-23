.text
 	lw 	s1,a			#cycle const
 	add 	a2,zero,zero		#outcycle counter
 	la	a4,a			#outcycle pointer	
 	addi	a4,a4,4
 beginOutCycle:
 	beq 	s1,a2,endOutCycle	#judge outcycle
 	addi 	a3,a2,1			#incycle counter
 	addi 	a5,a4,4			#incycle pointer
 beginInCycle:
 	beq 	s1,a3,endInCycle		#judge incycle
 	lw 	a6,0(a4)			#get element from array
 	lw	a7,0(a5)			#get element from array
 	bgeu	a7,a6,noMove
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
 	li 	s0,0xffff000c		#output
 	li	s2,0xffff0008
 	li	s3,1
 	add 	a2,zero,zero		#outcycle counter
 	la	a4,a
 	addi	a4,a4,4
 	sw	s3,0(s2)
 beginOutputCycle:
 	beq 	s1,a2,endOutputCycle		#judge incycle
 	lw 	a1,0(a4)			#get element from array
 	sw	a1,0(s0)
 	addi 	a4,a4,4			#add outcycle pointer 
 	addi	a2,a2,1			#add outcycle counterer
 	jal	zero,beginOutputCycle
 endOutputCycle:
 	
.data
a:
	.word	256
	.word	256
	.word	255
	.word	254
	.word	253
	.word	252
	.word	251
	.word	250
	.word	249
	.word	248
	.word	247
	.word	246
	.word	245
	.word	244
	.word	243
	.word	242
	.word	241
	.word	240
	.word	239
	.word	238
	.word	237
	.word	236
	.word	235
	.word	234
	.word	233
	.word	232
	.word	231
	.word	230
	.word	229
	.word	228
	.word	227
	.word	226
	.word	225
	.word	224
	.word	223
	.word	222
	.word	221
	.word	220
	.word	219
	.word	218
	.word	217
	.word	216
	.word	215
	.word	214
	.word	213
	.word	212
	.word	211
	.word	210
	.word	209
	.word	208
	.word	207
	.word	206
	.word	205
	.word	204
	.word	203
	.word	202
	.word	201
	.word	200
	.word	199
	.word	198
	.word	197
	.word	196
	.word	195
	.word	194
	.word	193
	.word	192
	.word	191
	.word	190
	.word	189
	.word	188
	.word	187
	.word	186
	.word	185
	.word	184
	.word	183
	.word	182
	.word	181
	.word	180
	.word	179
	.word	178
	.word	177
	.word	176
	.word	175
	.word	174
	.word	173
	.word	172
	.word	171
	.word	170
	.word	169
	.word	168
	.word	167
	.word	166
	.word	165
	.word	164
	.word	163
	.word	162
	.word	161
	.word	160
	.word	159
	.word	158
	.word	157
	.word	156
	.word	155
	.word	154
	.word	153
	.word	152
	.word	151
	.word	150
	.word	149
	.word	148
	.word	147
	.word	146
	.word	145
	.word	144
	.word	143
	.word	142
	.word	141
	.word	140
	.word	139
	.word	138
	.word	137
	.word	136
	.word	135
	.word	134
	.word	133
	.word	132
	.word	131
	.word	130
	.word	129
	.word	128
	.word	127
	.word	126
	.word	125
	.word	124
	.word	123
	.word	122
	.word	121
	.word	120
	.word	119
	.word	118
	.word	117
	.word	116
	.word	115
	.word	114
	.word	113
	.word	112
	.word	111
	.word	110
	.word	109
	.word	108
	.word	107
	.word	106
	.word	105
	.word	104
	.word	103
	.word	102
	.word	101
	.word	100
	.word	99
	.word	98
	.word	97
	.word	96
	.word	95
	.word	94
	.word	93
	.word	92
	.word	91
	.word	90
	.word	89
	.word	88
	.word	87
	.word	86
	.word	85
	.word	84
	.word	83
	.word	82
	.word	81
	.word	80
	.word	79
	.word	78
	.word	77
	.word	76
	.word	75
	.word	74
	.word	73
	.word	72
	.word	71
	.word	70
	.word	69
	.word	68
	.word	67
	.word	66
	.word	65
	.word	64
	.word	63
	.word	62
	.word	61
	.word	60
	.word	59
	.word	58
	.word	57
	.word	56
	.word	55
	.word	54
	.word	53
	.word	52
	.word	51
	.word	50
	.word	49
	.word	48
	.word	47
	.word	46
	.word	45
	.word	44
	.word	43
	.word	42
	.word	41
	.word	40
	.word	39
	.word	38
	.word	37
	.word	36
	.word	35
	.word	34
	.word	33
	.word	32
	.word	31
	.word	30
	.word	29
	.word	28
	.word	27
	.word	26
	.word	25
	.word	24
	.word	23
	.word	22
	.word	21
	.word	20
	.word	19
	.word	18
	.word	17
	.word	16
	.word	15
	.word	14
	.word	13
	.word	12
	.word	11
	.word	10
	.word	9
	.word	8
	.word	7
	.word	6
	.word	5
	.word	4
	.word	3
	.word	2
	.word	1
