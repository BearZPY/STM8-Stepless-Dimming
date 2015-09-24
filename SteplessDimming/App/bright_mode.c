#include "bright_mode.h"
#include "stm8_eeprom.h"
#include "delay.h"
#include "led.h"
#include "hekr_protocol.h"

// EEPROM Data ��ַ
#define COUNT_BYTE   0x00
#define BrightMode1  0x01
#define ColourMode1  0x02
#define BrightMode2  0x03
#define ColourMode2  0x04
#define BrightMode3  0x05
#define ColourMode3  0x06



void Bright_ModeInit(void)
{
  u8 count = 0;
  //ģʽ�ж�
  count = ReadEEPROM(COUNT_BYTE);
  if(count < 4)
  {
    count++;
    WriteEEPROM(COUNT_BYTE,count);
  }
  delay_ms(500);delay_ms(500);
  delay_ms(500);delay_ms(500);
  delay_ms(500);delay_ms(500);
  delay_ms(500);delay_ms(500);
  delay_ms(500);delay_ms(500);
  //����λ��0
  WriteEEPROM(COUNT_BYTE,0x00);
	//ģʽѡ�� �趨��ʼֵ
	switch(count)
	{
  case 1: bright_set = ReadEEPROM(BrightMode1);
          colour_set = ReadEEPROM(ColourMode1);
          break;
  case 2: bright_set = ReadEEPROM(BrightMode2);
          colour_set = ReadEEPROM(ColourMode2);
          break;
  case 3: bright_set = ReadEEPROM(BrightMode3);
          colour_set = ReadEEPROM(ColourMode3);
          break;
  // ����ģ�����ָ�� ʹESP��������ģʽ
  // ͬʱ����Ҳ��������ģʽ  
  // �ָ�Ԥ��ģʽ��ֵ
  case 4: HekrModuleControl(HekrConfig);
          WriteEEPROM(BrightMode1,0x32);WriteEEPROM(ColourMode1,0x80);
          WriteEEPROM(BrightMode2,0x32);WriteEEPROM(ColourMode2,0x00);
          WriteEEPROM(BrightMode3,0x32);WriteEEPROM(ColourMode3,0xFF);
          break;
  default:
          break;
  }
  UpdateBright();
}
