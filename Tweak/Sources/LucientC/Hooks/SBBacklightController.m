//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Hooks.h"
#import "../include/Tweak.h"

void (*orig_SBBacklightController_turnOnScreenFullyWithBacklightSource)(UIView* self, SEL cmd, long long arg1);
void hook_SBBacklightController_turnOnScreenFullyWithBacklightSource(UIView* self, SEL cmd, long long arg1) {
	setScreenOn(YES);
	return orig_SBBacklightController_turnOnScreenFullyWithBacklightSource(self, cmd, arg1);
}
