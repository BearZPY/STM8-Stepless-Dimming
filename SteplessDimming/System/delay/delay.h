#ifndef  __DELAY_H
#define  __DELAY_H


void delay_init(unsigned char clk); //��ʱ������ʼ��
void delay_us(unsigned int nus);  //us����ʱ����,���65536us
void delay_ms(unsigned int nms);  //ms����ʱ����

#endif
