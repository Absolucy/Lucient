//
//  SBFLockScreenDateView.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

void (*orig_SBFLockScreenDateView_didMoveToWindow)(UIView* self, SEL cmd);
void hook_SBFLockScreenDateView_didMoveToWindow(UIView* self, SEL cmd) {
	[self removeFromSuperview];
	return orig_SBFLockScreenDateView_didMoveToWindow(self, cmd);
}
