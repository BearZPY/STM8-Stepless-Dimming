   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4286                     ; 18 void Bright_ModeInit(void)
4286                     ; 19 {
4288                     	switch	.text
4289  0000               _Bright_ModeInit:
4291  0000 88            	push	a
4292       00000001      OFST:	set	1
4295                     ; 20   u8 count = 0;
4297  0001 0f01          	clr	(OFST+0,sp)
4298                     ; 22   count = ReadEEPROM(COUNT_BYTE);
4300  0003 4f            	clr	a
4301  0004 cd0000        	call	_ReadEEPROM
4303  0007 6b01          	ld	(OFST+0,sp),a
4304                     ; 23   if(count < 4)
4306  0009 7b01          	ld	a,(OFST+0,sp)
4307  000b a104          	cp	a,#4
4308  000d 240a          	jruge	L1572
4309                     ; 25     count++;
4311  000f 0c01          	inc	(OFST+0,sp)
4312                     ; 26     WriteEEPROM(COUNT_BYTE,count);
4314  0011 7b01          	ld	a,(OFST+0,sp)
4315  0013 97            	ld	xl,a
4316  0014 4f            	clr	a
4317  0015 95            	ld	xh,a
4318  0016 cd0000        	call	_WriteEEPROM
4320  0019               L1572:
4321                     ; 28   delay_ms(500);
4323  0019 ae01f4        	ldw	x,#500
4324  001c cd0000        	call	_delay_ms
4326                     ; 29   delay_ms(500);
4328  001f ae01f4        	ldw	x,#500
4329  0022 cd0000        	call	_delay_ms
4331                     ; 30   delay_ms(500);
4333  0025 ae01f4        	ldw	x,#500
4334  0028 cd0000        	call	_delay_ms
4336                     ; 32   WriteEEPROM(COUNT_BYTE,0x00);
4338  002b 5f            	clrw	x
4339  002c 4f            	clr	a
4340  002d 95            	ld	xh,a
4341  002e cd0000        	call	_WriteEEPROM
4343                     ; 34 	switch(count)
4345  0031 7b01          	ld	a,(OFST+0,sp)
4347                     ; 53   default:
4347                     ; 54           break;
4348  0033 4a            	dec	a
4349  0034 270b          	jreq	L3172
4350  0036 4a            	dec	a
4351  0037 2718          	jreq	L5172
4352  0039 4a            	dec	a
4353  003a 2725          	jreq	L7172
4354  003c 4a            	dec	a
4355  003d 2732          	jreq	L1272
4356  003f 2069          	jra	L5572
4357  0041               L3172:
4358                     ; 36   case 1: bright_set = ReadEEPROM(BrightMode1);
4360  0041 a601          	ld	a,#1
4361  0043 cd0000        	call	_ReadEEPROM
4363  0046 b700          	ld	_bright_set,a
4364                     ; 37           colour_set = ReadEEPROM(ColourMode1);
4366  0048 a602          	ld	a,#2
4367  004a cd0000        	call	_ReadEEPROM
4369  004d b700          	ld	_colour_set,a
4370                     ; 38           break;
4372  004f 2059          	jra	L5572
4373  0051               L5172:
4374                     ; 39   case 2: bright_set = ReadEEPROM(BrightMode2);
4376  0051 a603          	ld	a,#3
4377  0053 cd0000        	call	_ReadEEPROM
4379  0056 b700          	ld	_bright_set,a
4380                     ; 40           colour_set = ReadEEPROM(ColourMode2);
4382  0058 a604          	ld	a,#4
4383  005a cd0000        	call	_ReadEEPROM
4385  005d b700          	ld	_colour_set,a
4386                     ; 41           break;
4388  005f 2049          	jra	L5572
4389  0061               L7172:
4390                     ; 42   case 3: bright_set = ReadEEPROM(BrightMode3);
4392  0061 a605          	ld	a,#5
4393  0063 cd0000        	call	_ReadEEPROM
4395  0066 b700          	ld	_bright_set,a
4396                     ; 43           colour_set = ReadEEPROM(ColourMode3);
4398  0068 a606          	ld	a,#6
4399  006a cd0000        	call	_ReadEEPROM
4401  006d b700          	ld	_colour_set,a
4402                     ; 44           break;
4404  006f 2039          	jra	L5572
4405  0071               L1272:
4406                     ; 48   case 4: HekrModuleControl(HekrConfig);
4408  0071 a604          	ld	a,#4
4409  0073 cd0000        	call	_HekrModuleControl
4411                     ; 49           WriteEEPROM(BrightMode1,0x32);WriteEEPROM(ColourMode1,0x80);
4413  0076 ae0032        	ldw	x,#50
4414  0079 a601          	ld	a,#1
4415  007b 95            	ld	xh,a
4416  007c cd0000        	call	_WriteEEPROM
4420  007f ae0080        	ldw	x,#128
4421  0082 a602          	ld	a,#2
4422  0084 95            	ld	xh,a
4423  0085 cd0000        	call	_WriteEEPROM
4425                     ; 50           WriteEEPROM(BrightMode2,0x32);WriteEEPROM(ColourMode2,0x00);
4427  0088 ae0032        	ldw	x,#50
4428  008b a603          	ld	a,#3
4429  008d 95            	ld	xh,a
4430  008e cd0000        	call	_WriteEEPROM
4434  0091 5f            	clrw	x
4435  0092 a604          	ld	a,#4
4436  0094 95            	ld	xh,a
4437  0095 cd0000        	call	_WriteEEPROM
4439                     ; 51           WriteEEPROM(BrightMode3,0x32);WriteEEPROM(ColourMode3,0xFF);
4441  0098 ae0032        	ldw	x,#50
4442  009b a605          	ld	a,#5
4443  009d 95            	ld	xh,a
4444  009e cd0000        	call	_WriteEEPROM
4448  00a1 ae00ff        	ldw	x,#255
4449  00a4 a606          	ld	a,#6
4450  00a6 95            	ld	xh,a
4451  00a7 cd0000        	call	_WriteEEPROM
4453                     ; 52           break;
4455  00aa               L3272:
4456                     ; 53   default:
4456                     ; 54           break;
4458  00aa               L5572:
4459                     ; 56   UpdateBright();
4461  00aa cd0000        	call	_UpdateBright
4463                     ; 57 }
4466  00ad 84            	pop	a
4467  00ae 81            	ret
4480                     	xref	_HekrModuleControl
4481                     	xref	_UpdateBright
4482                     	xref.b	_colour_set
4483                     	xref.b	_bright_set
4484                     	xref	_delay_ms
4485                     	xref	_WriteEEPROM
4486                     	xref	_ReadEEPROM
4487                     	xdef	_Bright_ModeInit
4506                     	end
