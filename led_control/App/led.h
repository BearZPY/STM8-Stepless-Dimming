#ifndef _LED_H_
#define _LED_H_

#include "sys.h"

extern u8 clod_bright_update;
extern u8 warm_bright_update;

extern u16 cur_clod_bright;
extern u16 cur_warm_bright;
extern u16 goal_clod_bright;
extern u16 goal_warm_bright;

extern u8 bright_set;
extern u8 colour_set;

void LED_WarmWhiteBrightSet(u16 dat);
void LED_ClodWhiteBrightSet(u16 dat);

#endif
