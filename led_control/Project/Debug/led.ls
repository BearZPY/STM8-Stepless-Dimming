   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4221                     	bsct
4222  0000               _clod_bright_update:
4223  0000 00            	dc.b	0
4224  0001               _warm_bright_update:
4225  0001 00            	dc.b	0
4226  0002               _cur_clod_bright:
4227  0002 0000          	dc.w	0
4228  0004               _cur_warm_bright:
4229  0004 0000          	dc.w	0
4230  0006               _goal_clod_bright:
4231  0006 0000          	dc.w	0
4232  0008               _goal_warm_bright:
4233  0008 0000          	dc.w	0
4234  000a               _bright_set:
4235  000a 00            	dc.b	0
4236  000b               _colour_set:
4237  000b 00            	dc.b	0
4299                     ; 15 void LED_WarmWhiteBrightSet(u16 dat)
4299                     ; 16 {
4301                     	switch	.text
4302  0000               _LED_WarmWhiteBrightSet:
4304  0000 89            	pushw	x
4305       00000000      OFST:	set	0
4308                     ; 17   TIM2_CH2_Duty(dat >> 8,dat);
4310  0001 9f            	ld	a,xl
4311  0002 97            	ld	xl,a
4312  0003 7b01          	ld	a,(OFST+1,sp)
4313  0005 95            	ld	xh,a
4314  0006 cd0000        	call	_TIM2_CH2_Duty
4316                     ; 18 }
4319  0009 85            	popw	x
4320  000a 81            	ret
4356                     ; 20 void LED_ClodWhiteBrightSet(u16 dat)
4356                     ; 21 {
4357                     	switch	.text
4358  000b               _LED_ClodWhiteBrightSet:
4360  000b 89            	pushw	x
4361       00000000      OFST:	set	0
4364                     ; 22   TIM2_CH3_Duty(dat >> 8,dat);
4366  000c 9f            	ld	a,xl
4367  000d 97            	ld	xl,a
4368  000e 7b01          	ld	a,(OFST+1,sp)
4369  0010 95            	ld	xh,a
4370  0011 cd0000        	call	_TIM2_CH3_Duty
4372                     ; 23 }
4375  0014 85            	popw	x
4376  0015 81            	ret
4463                     	xref	_TIM2_CH3_Duty
4464                     	xref	_TIM2_CH2_Duty
4465                     	xdef	_LED_ClodWhiteBrightSet
4466                     	xdef	_LED_WarmWhiteBrightSet
4467                     	xdef	_colour_set
4468                     	xdef	_bright_set
4469                     	xdef	_goal_warm_bright
4470                     	xdef	_goal_clod_bright
4471                     	xdef	_cur_warm_bright
4472                     	xdef	_cur_clod_bright
4473                     	xdef	_warm_bright_update
4474                     	xdef	_clod_bright_update
4493                     	end
