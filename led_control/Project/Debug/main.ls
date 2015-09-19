   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4221                     	bsct
4222  0000               _RecvFlag:
4223  0000 00            	dc.b	0
4224  0001               _RecvCount:
4225  0001 00            	dc.b	0
4226  0002               _UserValidLen:
4227  0002 09            	dc.b	9
4281                     ; 28 main()
4281                     ; 29 {
4283                     	switch	.text
4284  0000               _main:
4288                     ; 31 	System_init();
4290  0000 ad14          	call	_System_init
4292                     ; 34 	HekrModuleControl(ModuleQuery);
4294  0002 a601          	ld	a,#1
4295  0004 cd0000        	call	_HekrModuleControl
4297  0007               L1372:
4298                     ; 39     DataHandle();
4300  0007 ad29          	call	_DataHandle
4302                     ; 43     if(ModuleStatus->Mode == HekrConfig_Mode)
4304  0009 be00          	ldw	x,_ModuleStatus
4305  000b e601          	ld	a,(1,x)
4306  000d a102          	cp	a,#2
4307  000f 26f6          	jrne	L1372
4308                     ; 45 			MCU_ConfigMode();
4310  0011 cd0000        	call	_MCU_ConfigMode
4312  0014 20f1          	jra	L1372
4345                     ; 51 void System_init(void)
4345                     ; 52 {
4346                     	switch	.text
4347  0016               _System_init:
4351                     ; 54 	System_Clock_init();
4353  0016 cd0000        	call	_System_Clock_init
4355                     ; 56 	UART1_Init();
4357  0019 cd0000        	call	_UART1_Init
4359                     ; 58 	HekrInit(UART1_SendChar);
4361  001c ae0000        	ldw	x,#_UART1_SendChar
4362  001f cd0000        	call	_HekrInit
4364                     ; 60 	delay_init(16);
4366  0022 a610          	ld	a,#16
4367  0024 cd0000        	call	_delay_init
4369                     ; 62 	Bright_ModeInit();
4371  0027 cd0000        	call	_Bright_ModeInit
4373                     ; 65 	TIM2_Init();
4375  002a cd0000        	call	_TIM2_Init
4377                     ; 67 	TIM1_Init();
4379  002d cd0000        	call	_TIM1_Init
4381                     ; 68 	_asm("rim");
4384  0030 9a            rim
4386                     ; 69 }
4389  0031 81            	ret
4435                     ; 71 void DataHandle(void)
4435                     ; 72 {
4436                     	switch	.text
4437  0032               _DataHandle:
4439  0032 88            	push	a
4440       00000001      OFST:	set	1
4443                     ; 74   if(RecvFlag)
4445  0033 3d00          	tnz	_RecvFlag
4446  0035 274f          	jreq	L7772
4447                     ; 76     temp = HekrRecvDataHandle(RecvBuffer);
4449  0037 ae0000        	ldw	x,#_RecvBuffer
4450  003a cd0000        	call	_HekrRecvDataHandle
4452  003d 6b01          	ld	(OFST+0,sp),a
4453                     ; 78     if(ModuleStatus->Mode != HekrConfig_Mode)
4455  003f be00          	ldw	x,_ModuleStatus
4456  0041 e601          	ld	a,(1,x)
4457  0043 a102          	cp	a,#2
4458  0045 273d          	jreq	L1003
4459                     ; 81       if(ValidDataUpdate == temp)
4461  0047 7b01          	ld	a,(OFST+0,sp)
4462  0049 a104          	cp	a,#4
4463  004b 2637          	jrne	L1003
4464                     ; 83 				switch(valid_data[0])
4466  004d b600          	ld	a,_valid_data
4468                     ; 104         default:break;
4469  004f 4d            	tnz	a
4470  0050 270d          	jreq	L7472
4471  0052 a002          	sub	a,#2
4472  0054 2719          	jreq	L1572
4473  0056 4a            	dec	a
4474  0057 271d          	jreq	L3572
4475  0059 a003          	sub	a,#3
4476  005b 2721          	jreq	L5572
4477  005d 2025          	jra	L1003
4478  005f               L7472:
4479                     ; 86         case LED_Query:
4479                     ; 87               //保存当前数据
4479                     ; 88               valid_data[1] = led_open_flag;
4481  005f 450001        	mov	_valid_data+1,_led_open_flag
4482                     ; 89               valid_data[3] = bright_set;
4484  0062 450003        	mov	_valid_data+3,_bright_set
4485                     ; 90               valid_data[4] = colour_set;
4487  0065 450004        	mov	_valid_data+4,_colour_set
4488                     ; 92               HekrValidDataUpload(UserValidLen);break;
4490  0068 b602          	ld	a,_UserValidLen
4491  006a cd0000        	call	_HekrValidDataUpload
4495  006d 2015          	jra	L1003
4496  006f               L1572:
4497                     ; 94         case LED_PowerONOFF:
4497                     ; 95               LED_StateControl(valid_data[1]);break;
4499  006f b601          	ld	a,_valid_data+1
4500  0071 cd0000        	call	_LED_StateControl
4504  0074 200e          	jra	L1003
4505  0076               L3572:
4506                     ; 97         case LED_Bright_Control:
4506                     ; 98               bright_set = valid_data[3];
4508  0076 450300        	mov	_bright_set,_valid_data+3
4509                     ; 99               UpdateBright();break;
4511  0079 cd0000        	call	_UpdateBright
4515  007c 2006          	jra	L1003
4516  007e               L5572:
4517                     ; 101         case LED_Colour_Temperature:
4517                     ; 102               colour_set = valid_data[4];
4519  007e 450400        	mov	_colour_set,_valid_data+4
4520                     ; 103               UpdateBright();break;
4522  0081 cd0000        	call	_UpdateBright
4526  0084               L7572:
4527                     ; 104         default:break;
4529  0084               L7003:
4530  0084               L1003:
4531                     ; 108     RecvFlag = 0;			
4533  0084 3f00          	clr	_RecvFlag
4534  0086               L7772:
4535                     ; 110 }
4538  0086 84            	pop	a
4539  0087 81            	ret
4542                     	bsct
4543  0003               L1103_timing_delay:
4544  0003 00            	dc.b	0
4580                     ; 113 @far @interrupt void TIM1_IRQHandler(void)
4580                     ; 114 {
4582                     	switch	.text
4583  0088               f_TIM1_IRQHandler:
4586  0088 3b0002        	push	c_x+2
4587  008b be00          	ldw	x,c_x
4588  008d 89            	pushw	x
4589  008e 3b0002        	push	c_y+2
4590  0091 be00          	ldw	x,c_y
4591  0093 89            	pushw	x
4594                     ; 117   if(clod_bright_update || warm_bright_update)
4596  0094 3d00          	tnz	_clod_bright_update
4597  0096 2604          	jrne	L3303
4599  0098 3d00          	tnz	_warm_bright_update
4600  009a 270d          	jreq	L1303
4601  009c               L3303:
4602                     ; 119     timing_delay++;
4604  009c 3c03          	inc	L1103_timing_delay
4605                     ; 120     if(20 == timing_delay) 
4607  009e b603          	ld	a,L1103_timing_delay
4608  00a0 a114          	cp	a,#20
4609  00a2 2605          	jrne	L1303
4610                     ; 122       CurBrighControl();
4612  00a4 cd0000        	call	_CurBrighControl
4614                     ; 123       timing_delay = 0;
4616  00a7 3f03          	clr	L1103_timing_delay
4617  00a9               L1303:
4618                     ; 126   TIM1_SR1 &= (~0x01);   
4620  00a9 72115255      	bres	_TIM1_SR1,#0
4621                     ; 127 }
4624  00ad 85            	popw	x
4625  00ae bf00          	ldw	c_y,x
4626  00b0 320002        	pop	c_y+2
4627  00b3 85            	popw	x
4628  00b4 bf00          	ldw	c_x,x
4629  00b6 320002        	pop	c_x+2
4630  00b9 80            	iret
4632                     	bsct
4633  0004               L7303_TempFlag:
4634  0004 00            	dc.b	0
4680                     ; 129 @far @interrupt void UART1_Recv_IRQHandler(void)
4680                     ; 130 {
4681                     	switch	.text
4682  00ba               f_UART1_Recv_IRQHandler:
4685       00000001      OFST:	set	1
4686  00ba 88            	push	a
4689                     ; 133   ch = UART1_DR;   
4691  00bb c65231        	ld	a,_UART1_DR
4692  00be 6b01          	ld	(OFST+0,sp),a
4693                     ; 134 	if(ch == HEKR_FRAME_HEADER)
4695  00c0 7b01          	ld	a,(OFST+0,sp)
4696  00c2 a148          	cp	a,#72
4697  00c4 2606          	jrne	L3603
4698                     ; 136 		TempFlag = 1;
4700  00c6 35010004      	mov	L7303_TempFlag,#1
4701                     ; 137 		RecvCount = 0;
4703  00ca 3f01          	clr	_RecvCount
4704  00cc               L3603:
4705                     ; 139 	if(TempFlag)
4707  00cc 3d04          	tnz	L7303_TempFlag
4708  00ce 2720          	jreq	L5603
4709                     ; 141 		RecvBuffer[RecvCount++] = ch;
4711  00d0 b601          	ld	a,_RecvCount
4712  00d2 97            	ld	xl,a
4713  00d3 3c01          	inc	_RecvCount
4714  00d5 9f            	ld	a,xl
4715  00d6 5f            	clrw	x
4716  00d7 97            	ld	xl,a
4717  00d8 7b01          	ld	a,(OFST+0,sp)
4718  00da e700          	ld	(_RecvBuffer,x),a
4719                     ; 142 		if(RecvCount > 4 && RecvCount >= RecvBuffer[1])
4721  00dc b601          	ld	a,_RecvCount
4722  00de a105          	cp	a,#5
4723  00e0 250e          	jrult	L5603
4725  00e2 b601          	ld	a,_RecvCount
4726  00e4 b101          	cp	a,_RecvBuffer+1
4727  00e6 2508          	jrult	L5603
4728                     ; 144 			RecvFlag = 1;
4730  00e8 35010000      	mov	_RecvFlag,#1
4731                     ; 145 			TempFlag = 0;
4733  00ec 3f04          	clr	L7303_TempFlag
4734                     ; 146 			RecvCount = 0;
4736  00ee 3f01          	clr	_RecvCount
4737  00f0               L5603:
4738                     ; 149 }
4741  00f0 84            	pop	a
4742  00f1 80            	iret
4793                     	xdef	f_UART1_Recv_IRQHandler
4794                     	xdef	f_TIM1_IRQHandler
4795                     	xdef	_main
4796                     	xdef	_DataHandle
4797                     	xdef	_System_init
4798                     	xdef	_UserValidLen
4799                     	switch	.ubsct
4800  0000               _RecvBuffer:
4801  0000 000000000000  	ds.b	20
4802                     	xdef	_RecvBuffer
4803                     	xdef	_RecvCount
4804                     	xdef	_RecvFlag
4805                     	xref	_Bright_ModeInit
4806                     	xref	_MCU_ConfigMode
4807                     	xref	_CurBrighControl
4808                     	xref	_UpdateBright
4809                     	xref	_LED_StateControl
4810                     	xref.b	_led_open_flag
4811                     	xref.b	_colour_set
4812                     	xref.b	_bright_set
4813                     	xref.b	_warm_bright_update
4814                     	xref.b	_clod_bright_update
4815                     	xref	_TIM1_Init
4816                     	xref	_TIM2_Init
4817                     	xref	_HekrValidDataUpload
4818                     	xref	_HekrModuleControl
4819                     	xref	_HekrRecvDataHandle
4820                     	xref	_HekrInit
4821                     	xref.b	_ModuleStatus
4822                     	xref.b	_valid_data
4823                     	xref	_UART1_SendChar
4824                     	xref	_UART1_Init
4825                     	xref	_delay_init
4826                     	xref	_System_Clock_init
4827                     	xref.b	c_x
4828                     	xref.b	c_y
4848                     	end
