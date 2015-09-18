/* MAIN.C file
 * 
 * 
 */

#include "stm8s103f.h"
#include "sys.h"
#include "delay.h"
#include "stm8_uart.h"
#include "hekr_protocol.h"
#include "stm8_eeprom.h"
#include "stm8_tim2pwm.h"
#include "stm8_tim1.h"
#include "led.h"
#include "bright_mode.h"

u8 RecvFlag = 0;
u8 RecvCount = 0;
u8 RecvBuffer[20];
u8 DateHandleFlag = 0;


void System_init(void);


main()
{
	u8 temp;
	u8 UserValidLen = 9;
	
	System_init();
	
	// 上传有效数据
	HekrValidDataUpload(UserValidLen);
	// 配置及查询hekr模块状态
	HekrModuleControl(ModuleQuery);
	
	while (1)
	{
		if(RecvFlag && !DateHandleFlag)
		{
			DateHandleFlag = 1;
			RecvFlag = 0;
		}
		if(DateHandleFlag)
		{
			temp = HekrRecvDataHandle(RecvBuffer);
			if(ValidDataUpdate == temp)
			{
				//接收的数据保存在 valid_data 数组里
				//User Code
				UART1_SendChar(valid_data[0]);
			}
			if(HekrModuleStateUpdate == temp)
			{
				//接收的数据保存在 ModuleStatus 指针里
				//User Code
				UART1_SendChar(ModuleStatus->CMD);
			}
			DateHandleFlag = 0;			
		}			
	}
}


void System_init(void)
{
	System_Clock_init();
	UART1_Init();
	delay_init(16);
	Bright_ModeInit();
	HekrInit(UART1_SendChar);
	TIM2_Init();
	TIM1_Init();
	_asm("rim");
}
 
 
 
 
@far @interrupt void TIM1_IRQHandler(void)
{
	
  TIM1_SR1 &= (~0x01);   
}
 
@far @interrupt void UART1_Recv_IRQHandler(void)
{
  unsigned char ch;
	static unsigned char TempFlag = 0;
  ch = UART1_DR;   
	if(ch == HEKR_FRAME_HEADER)
	{
		TempFlag = 1;
		RecvCount = 0;
	}
	if(TempFlag)
	{
		RecvBuffer[RecvCount++] = ch;
		if(RecvCount > 4 && RecvCount >= RecvBuffer[1])
		{
			RecvFlag = 1;
			TempFlag = 0;
			RecvCount = 0;
		}
	}
}
