#include "sys.h"

void System_Clock_init(void)
{
	//�趨HSI 16M
	CLK_SWR = 0xE1; 
	//CPU 0 ��Ƶ ϵͳ 0��Ƶ
	CLK_CKDIVR = 0x00; 

}
