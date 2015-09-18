#include "delay.h"
volatile unsigned char  fac_us=0;
//CLK ϵͳʱ�� 24/16/8/2 M 
void delay_init(unsigned char clk)
{
	if(clk>16)
		fac_us=(16-4)/4;//24Mhzʱ,stm8���19������Ϊ1us
	else if(clk>4)
		fac_us=(clk-4)/4; 
	else 
		fac_us=1;
}

void delay_us(unsigned int nus)
{  
	#asm
	PUSH A            //1T,ѹջ
	DELAY_XUS:         
	LD A,_fac_us      //1T,fac_us���ص��ۼ���A
	DELAY_US_1:      
	NOP               //1T,nop��ʱ
	DEC A             //1T,A--
	JRNE DELAY_US_1   //������0,����ת(2T)��DELAY_US_1����  ִ��,������0,����ת(1T).
	NOP               //1T,nop��ʱ 
	DECW X            //1T,x--
	JRNE DELAY_XUS    // ������0,����ת(2T)��DELAY_XUS����  ִ��,������0,����ת(1T).
	POP A             //1T,��ջ
	#endasm
}

void delay_ms(unsigned int nms) 
{ 
	unsigned char t; 
	if(nms>65) 
	{ 
		t=nms/65; 
		while(t--)delay_us(65000); 
		nms=nms%65; 
	} 
	delay_us(nms*1000); 
}
