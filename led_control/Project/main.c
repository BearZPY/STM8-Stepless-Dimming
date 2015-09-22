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

//���ڽ�������
u8 RecvFlag = 0;
u8 RecvCount = 0;
u8 RecvBuffer[20];

//ʵ�������û����ݳ���
u8 UserValidLen = 9;

void System_init(void);
void DataHandle(void);

main()
{
	//ϵͳ��ʼ��
	System_init();

	//��ѯhekrģ��״̬
	HekrModuleControl(ModuleQuery);
	
	while (1)
	{
		// ͸��Э�����ݴ���
    DataHandle();
		
		// ���ESPģ�����������ģʽ 
    // �޼������Ҳ������ģʽ
    if(ModuleStatus->Mode == HekrConfig_Mode)
		{
			MCU_ConfigMode();
		}
	}
}


void System_init(void)
{
	//ϵͳʱ�ӳ�ʼ�� �ڲ�16M
	System_Clock_init();
  //���ڳ�ʼ�� 9600
	UART1_Init();
	//���ڷ��ͺ�����
	HekrInit(UART1_SendChar);
	//16M��Ƶ�ӳٳ�ʼ��
	delay_init(16);
	//ͨ���ϵ����ѡ��ģʽ �����ȳ�ʼ���ӳ� ����
	Bright_ModeInit();

	//PWM ��ʼ��
	TIM2_Init();
	//���ȵ�����ʱ��
	TIM1_Init();
	_asm("rim");
}
 
void DataHandle(void)
{
	u8 temp;
  if(RecvFlag)
  {
    temp = HekrRecvDataHandle(RecvBuffer);
		// ��������ģʽ�²�������յ����û�����
    if(ModuleStatus->Mode != HekrConfig_Mode)
    {
      //�û���Ч���ݸ���
      if(ValidDataUpdate == temp)
      {
				switch(valid_data[0])
				{
        // ��ѯ�޼������״̬
        case LED_Query:
              //���浱ǰ����
              valid_data[1] = led_open_flag;
              valid_data[3] = bright_set;
              valid_data[4] = colour_set;
              //�ϴ��û�����
              HekrValidDataUpload(UserValidLen);break;
        // �޼������״̬���ؿ���
        case LED_PowerONOFF:
              LED_StateControl(valid_data[1]);break;
        // �����ȿ���
        case LED_Bright_Control:
              bright_set = valid_data[3];
              if(led_open_flag == 1)UpdateBright();
              break;
        // ɫ�¿���
        case LED_Colour_Temperature:
              colour_set = valid_data[4];
              if(led_open_flag == 1)UpdateBright();
              break;
        default:break;
        }
      }
    }
    RecvFlag = 0;			
  }			
}
 

@far @interrupt void TIM1_IRQHandler(void)
{
  static u8 timing_delay = 0;

  if(clod_bright_update || warm_bright_update)
  {
    timing_delay++;
    if(20 == timing_delay) 
    {
      CurBrighControl();
      timing_delay = 0;
    }
  }
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
