//
//  SBLockScreenManager.m
//  Thanos
//
//  Created by Aspen on 6/14/21.
//

#import "../include/Hooks.h"
#import "../include/Tweak.h"

void (*orig_SBLockScreenManager_lockUIFromSource)(UIView* self, SEL cmd, int arg1, id withOptions);
void hook_SBLockScreenManager_lockUIFromSource(UIView* self, SEL cmd, int arg1, id withOptions) {
	setScreenOn(NO);
	removeIfInvalid();
	return orig_SBLockScreenManager_lockUIFromSource(self, cmd, arg1, withOptions);
}
