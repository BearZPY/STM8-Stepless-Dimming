   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4221                     	bsct
4222  0000               _RecvFlag:
4223  0000 00            	dc.b	0
4224  0001               _RecvCount:
4225  0001 00            	dc.b	0
4226  0002               _DateHandleFlag:
4227  0002 00            	dc.b	0
4306                     ; 26 main()
4306                     ; 27 {
4308                     	switch	.text
4309  0000               _main:
4311  0000 88            	push	a
4312       00000001      OFST:	set	1
4315                     ; 29 	u8 UserValidLen = 9;
4317  0001 a609          	ld	a,#9
4318  0003 6b01          	ld	(OFST+0,sp),a
4319                     ; 31 	System_init();
4321  0005 ad3f          	call	_System_init
4323                     ; 34 	HekrValidDataUpload(UserValidLen);
4325  0007 7b01          	ld	a,(OFST+0,sp)
4326  0009 cd0000        	call	_HekrValidDataUpload
4328                     ; 36 	HekrModuleControl(ModuleQuery);
4330  000c a601          	ld	a,#1
4331  000e cd0000        	call	_HekrModuleControl
4333  0011               L3472:
4334                     ; 40 		if(RecvFlag && !DateHandleFlag)
4336  0011 3d00          	tnz	_RecvFlag
4337  0013 270a          	jreq	L7472
4339  0015 3d02          	tnz	_DateHandleFlag
4340  0017 2606          	jrne	L7472
4341                     ; 42 			DateHandleFlag = 1;
4343  0019 35010002      	mov	_DateHandleFlag,#1
4344                     ; 43 			RecvFlag = 0;
4346  001d 3f00          	clr	_RecvFlag
4347  001f               L7472:
4348                     ; 45 		if(DateHandleFlag)
4350  001f 3d02          	tnz	_DateHandleFlag
4351  0021 27ee          	jreq	L3472
4352                     ; 47 			temp = HekrRecvDataHandle(RecvBuffer);
4354  0023 ae0000        	ldw	x,#_RecvBuffer
4355  0026 cd0000        	call	_HekrRecvDataHandle
4357  0029 6b01          	ld	(OFST+0,sp),a
4358                     ; 48 			if(ValidDataUpdate == temp)
4360  002b 7b01          	ld	a,(OFST+0,sp)
4361  002d a104          	cp	a,#4
4362  002f 2605          	jrne	L3572
4363                     ; 52 				UART1_SendChar(valid_data[0]);
4365  0031 b600          	ld	a,_valid_data
4366  0033 cd0000        	call	_UART1_SendChar
4368  0036               L3572:
4369                     ; 54 			if(HekrModuleStateUpdate == temp)
4371  0036 7b01          	ld	a,(OFST+0,sp)
4372  0038 a106          	cp	a,#6
4373  003a 2606          	jrne	L5572
4374                     ; 58 				UART1_SendChar(ModuleStatus->CMD);
4376  003c 92c600        	ld	a,[_ModuleStatus.w]
4377  003f cd0000        	call	_UART1_SendChar
4379  0042               L5572:
4380                     ; 60 			DateHandleFlag = 0;			
4382  0042 3f02          	clr	_DateHandleFlag
4383  0044 20cb          	jra	L3472
4416                     ; 66 void System_init(void)
4416                     ; 67 {
4417                     	switch	.text
4418  0046               _System_init:
4422                     ; 68 	System_Clock_init();
4424  0046 cd0000        	call	_System_Clock_init
4426                     ; 69 	UART1_Init();
4428  0049 cd0000        	call	_UART1_Init
4430                     ; 70 	delay_init(16);
4432  004c a610          	ld	a,#16
4433  004e cd0000        	call	_delay_init
4435                     ; 71 	Bright_ModeInit();
4437  0051 cd0000        	call	_Bright_ModeInit
4439                     ; 72 	HekrInit(UART1_SendChar);
4441  0054 ae0000        	ldw	x,#_UART1_SendChar
4442  0057 cd0000        	call	_HekrInit
4444                     ; 73 	TIM2_Init();
4446  005a cd0000        	call	_TIM2_Init
4448                     ; 74 	TIM1_Init();
4450  005d cd0000        	call	_TIM1_Init
4452                     ; 75 	_asm("rim");
4455  0060 9a            rim
4457                     ; 76 }
4460  0061 81            	ret
4484                     ; 81 @far @interrupt void TIM1_IRQHandler(void)
4484                     ; 82 {
4486                     	switch	.text
4487  0062               f_TIM1_IRQHandler:
4492                     ; 84   TIM1_SR1 &= (~0x01);   
4494  0062 72115255      	bres	_TIM1_SR1,#0
4495                     ; 85 }
4498  0066 80            	iret
4500                     	bsct
4501  0003               L7772_TempFlag:
4502  0003 00            	dc.b	0
4548                     ; 87 @far @interrupt void UART1_Recv_IRQHandler(void)
4548                     ; 88 {
4549                     	switch	.text
4550  0067               f_UART1_Recv_IRQHandler:
4553       00000001      OFST:	set	1
4554  0067 88            	push	a
4557                     ; 91   ch = UART1_DR;   
4559  0068 c65231        	ld	a,_UART1_DR
4560  006b 6b01          	ld	(OFST+0,sp),a
4561                     ; 92 	if(ch == HEKR_FRAME_HEADER)
4563  006d 7b01          	ld	a,(OFST+0,sp)
4564  006f a148          	cp	a,#72
4565  0071 2606          	jrne	L3203
4566                     ; 94 		TempFlag = 1;
4568  0073 35010003      	mov	L7772_TempFlag,#1
4569                     ; 95 		RecvCount = 0;
4571  0077 3f01          	clr	_RecvCount
4572  0079               L3203:
4573                     ; 97 	if(TempFlag)
4575  0079 3d03          	tnz	L7772_TempFlag
4576  007b 2720          	jreq	L5203
4577                     ; 99 		RecvBuffer[RecvCount++] = ch;
4579  007d b601          	ld	a,_RecvCount
4580  007f 97            	ld	xl,a
4581  0080 3c01          	inc	_RecvCount
4582  0082 9f            	ld	a,xl
4583  0083 5f            	clrw	x
4584  0084 97            	ld	xl,a
4585  0085 7b01          	ld	a,(OFST+0,sp)
4586  0087 e700          	ld	(_RecvBuffer,x),a
4587                     ; 100 		if(RecvCount > 4 && RecvCount >= RecvBuffer[1])
4589  0089 b601          	ld	a,_RecvCount
4590  008b a105          	cp	a,#5
4591  008d 250e          	jrult	L5203
4593  008f b601          	ld	a,_RecvCount
4594  0091 b101          	cp	a,_RecvBuffer+1
4595  0093 2508          	jrult	L5203
4596                     ; 102 			RecvFlag = 1;
4598  0095 35010000      	mov	_RecvFlag,#1
4599                     ; 103 			TempFlag = 0;
4601  0099 3f03          	clr	L7772_TempFlag
4602                     ; 104 			RecvCount = 0;
4604  009b 3f01          	clr	_RecvCount
4605  009d               L5203:
4606                     ; 107 }
4609  009d 84            	pop	a
4610  009e 80            	iret
4661                     	xdef	f_UART1_Recv_IRQHandler
4662                     	xdef	f_TIM1_IRQHandler
4663                     	xdef	_main
4664                     	xdef	_System_init
4665                     	xdef	_DateHandleFlag
4666                     	switch	.ubsct
4667  0000               _RecvBuffer:
4668  0000 000000000000  	ds.b	20
4669                     	xdef	_RecvBuffer
4670                     	xdef	_RecvCount
4671                     	xdef	_RecvFlag
4672                     	xref	_Bright_ModeInit
4673                     	xref	_TIM1_Init
4674                     	xref	_TIM2_Init
4675                     	xref	_HekrValidDataUpload
4676                     	xref	_HekrModuleControl
4677                     	xref	_HekrRecvDataHandle
4678                     	xref	_HekrInit
4679                     	xref.b	_ModuleStatus
4680                     	xref.b	_valid_data
4681                     	xref	_UART1_SendChar
4682                     	xref	_UART1_Init
4683                     	xref	_delay_init
4684                     	xref	_System_Clock_init
4704                     	end
