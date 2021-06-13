//
//  SBUIProudLockIconView.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

static void (*orig_SBUIProudLockIconView_didMoveToWindow)(UIView* self, SEL cmd);
static void hook_SBUIProudLockIconView_didMoveToWindow(UIView* self, SEL cmd) {
	[[self superview] setHidden:YES];
	return orig_SBUIProudLockIconView_didMoveToWindow(self, cmd);
}
