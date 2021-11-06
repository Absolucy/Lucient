//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Tweak.h"

void (*orig_LastLookManager_setIsActive)(id self, SEL cmd, BOOL isActive);
void hook_LastLookManager_setIsActive(id self, SEL cmd, BOOL isActive) {
	setAodOn(isActive);
	return orig_LastLookManager_setIsActive(self, cmd, isActive);
}
