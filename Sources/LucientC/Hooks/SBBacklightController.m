//
//  SBBacklightController.m
//  Thanos
//
//  Created by Aspen on 6/14/21.
//

#import "../include/Hooks.h"
#import "../include/Tweak.h"

void (*orig_SBBacklightController_turnOnScreenFullyWithBacklightSource)(UIView* self, SEL cmd, long long arg1);
void hook_SBBacklightController_turnOnScreenFullyWithBacklightSource(UIView* self, SEL cmd, long long arg1) {
	setScreenOn(YES);
	removeIfInvalid();
	return orig_SBBacklightController_turnOnScreenFullyWithBacklightSource(self, cmd, arg1);
}
