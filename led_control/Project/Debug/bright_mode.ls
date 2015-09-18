   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4285                     ; 18 void Bright_ModeInit(void)
4285                     ; 19 {
4287                     	switch	.text
4288  0000               _Bright_ModeInit:
4290  0000 88            	push	a
4291       00000001      OFST:	set	1
4294                     ; 20   u8 count = 0;
4296  0001 0f01          	clr	(OFST+0,sp)
4297                     ; 21   count = ReadEEPROM(COUNT_BYTE);
4299  0003 4f            	clr	a
4300  0004 cd0000        	call	_ReadEEPROM
4302  0007 6b01          	ld	(OFST+0,sp),a
4303                     ; 22   if(count < 4)
4305  0009 7b01          	ld	a,(OFST+0,sp)
4306  000b a104          	cp	a,#4
4307  000d 240a          	jruge	L1572
4308                     ; 24     count++;
4310  000f 0c01          	inc	(OFST+0,sp)
4311                     ; 25     WriteEEPROM(COUNT_BYTE,count);
4313  0011 7b01          	ld	a,(OFST+0,sp)
4314  0013 97            	ld	xl,a
4315  0014 4f            	clr	a
4316  0015 95            	ld	xh,a
4317  0016 cd0000        	call	_WriteEEPROM
4319  0019               L1572:
4320                     ; 27   delay_ms(500);
4322  0019 ae01f4        	ldw	x,#500
4323  001c cd0000        	call	_delay_ms
4325                     ; 28   delay_ms(500);
4327  001f ae01f4        	ldw	x,#500
4328  0022 cd0000        	call	_delay_ms
4330                     ; 29   delay_ms(500);
4332  0025 ae01f4        	ldw	x,#500
4333  0028 cd0000        	call	_delay_ms
4335                     ; 31   WriteEEPROM(COUNT_BYTE,0x00);
4337  002b 5f            	clrw	x
4338  002c 4f            	clr	a
4339  002d 95            	ld	xh,a
4340  002e cd0000        	call	_WriteEEPROM
4342                     ; 33 	switch(count)
4344  0031 7b01          	ld	a,(OFST+0,sp)
4346                     ; 46   default:
4346                     ; 47           break;
4347  0033 4a            	dec	a
4348  0034 270b          	jreq	L3172
4349  0036 4a            	dec	a
4350  0037 2718          	jreq	L5172
4351  0039 4a            	dec	a
4352  003a 2725          	jreq	L7172
4353  003c 4a            	dec	a
4354  003d 2732          	jreq	L1272
4355  003f 2035          	jra	L5572
4356  0041               L3172:
4357                     ; 35   case 1: bright_set = ReadEEPROM(BrightMode1);
4359  0041 a601          	ld	a,#1
4360  0043 cd0000        	call	_ReadEEPROM
4362  0046 b700          	ld	_bright_set,a
4363                     ; 36           colour_set = ReadEEPROM(ColourMode1);
4365  0048 a602          	ld	a,#2
4366  004a cd0000        	call	_ReadEEPROM
4368  004d b700          	ld	_colour_set,a
4369                     ; 37           break;
4371  004f 2025          	jra	L5572
4372  0051               L5172:
4373                     ; 38   case 2: bright_set = ReadEEPROM(BrightMode2);
4375  0051 a603          	ld	a,#3
4376  0053 cd0000        	call	_ReadEEPROM
4378  0056 b700          	ld	_bright_set,a
4379                     ; 39           colour_set = ReadEEPROM(ColourMode2);
4381  0058 a604          	ld	a,#4
4382  005a cd0000        	call	_ReadEEPROM
4384  005d b700          	ld	_colour_set,a
4385                     ; 40           break;
4387  005f 2015          	jra	L5572
4388  0061               L7172:
4389                     ; 41   case 3: bright_set = ReadEEPROM(BrightMode3);
4391  0061 a605          	ld	a,#5
4392  0063 cd0000        	call	_ReadEEPROM
4394  0066 b700          	ld	_bright_set,a
4395                     ; 42           colour_set = ReadEEPROM(ColourMode3);
4397  0068 a606          	ld	a,#6
4398  006a cd0000        	call	_ReadEEPROM
4400  006d b700          	ld	_colour_set,a
4401                     ; 43           break;
4403  006f 2005          	jra	L5572
4404  0071               L1272:
4405                     ; 44   case 4: HekrModuleControl(HekrConfig);
4407  0071 a604          	ld	a,#4
4408  0073 cd0000        	call	_HekrModuleControl
4410                     ; 45           break;
4412  0076               L3272:
4413                     ; 46   default:
4413                     ; 47           break;
4415  0076               L5572:
4416                     ; 49 }
4419  0076 84            	pop	a
4420  0077 81            	ret
4433                     	xref	_HekrModuleControl
4434                     	xref.b	_colour_set
4435                     	xref.b	_bright_set
4436                     	xref	_delay_ms
4437                     	xref	_WriteEEPROM
4438                     	xref	_ReadEEPROM
4439                     	xdef	_Bright_ModeInit
4458                     	end
