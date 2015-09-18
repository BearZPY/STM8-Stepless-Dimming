#include "led.h"
#include "stm8_tim2pwm.h"

u8 clod_bright_update = 0;
u8 warm_bright_update = 0;

u16 cur_clod_bright = 0;
u16 cur_warm_bright = 0;
u16 goal_clod_bright = 0;
u16 goal_warm_bright = 0;

u8 bright_set = 0;
u8 colour_set = 0;

void LED_WarmWhiteBrightSet(u16 dat)
{
  TIM2_CH2_Duty(dat >> 8,dat);
}

void LED_ClodWhiteBrightSet(u16 dat)
{
  TIM2_CH3_Duty(dat >> 8,dat);
}

