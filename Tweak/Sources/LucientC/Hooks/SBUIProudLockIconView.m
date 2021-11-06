//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Tweak.h"

void (*orig_SBUIProudLockIconView_didMoveToWindow)(UIView* self, SEL cmd);
void hook_SBUIProudLockIconView_didMoveToWindow(UIView* self, SEL cmd) {
	[[self superview] setHidden:hideLock()];
	return orig_SBUIProudLockIconView_didMoveToWindow(self, cmd);
}
