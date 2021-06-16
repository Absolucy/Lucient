//
//  SBLockScreenManager.m
//  Thanos
//
//  Created by Aspen on 6/14/21.
//

#import "../Tweak.h"
#import "Hooks.h"

void (*orig_SBLockScreenManager_lockUIFromSource)(UIView* self, SEL cmd, int arg1, id withOptions);
void hook_SBLockScreenManager_lockUIFromSource(UIView* self, SEL cmd, int arg1, id withOptions) {
	setScreenOn(NO);
	return orig_SBLockScreenManager_lockUIFromSource(self, cmd, arg1, withOptions);
}
