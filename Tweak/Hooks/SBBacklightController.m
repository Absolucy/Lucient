//
//  SBBacklightController.m
//  Thanos
//
//  Created by Aspen on 6/14/21.
//

#import "Hooks.h"

void (*orig_SBBacklightController_turnOnScreenFullyWithBacklightSource)(UIView* self, SEL cmd, long long arg1);
void hook_SBBacklightController_turnOnScreenFullyWithBacklightSource(UIView* self, SEL cmd, long long arg1) {
	updateData(YES);
	return orig_SBBacklightController_turnOnScreenFullyWithBacklightSource(self, cmd, arg1);
}
