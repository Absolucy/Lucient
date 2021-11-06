//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Tweak.h"

void (*orig_AXNManager_insertNotificationRequest)(AXNManager* self, SEL cmd, id req);
void hook_AXNManager_insertNotificationRequest(AXNManager* self, SEL cmd, id req) {
	orig_AXNManager_insertNotificationRequest(self, cmd, req);
	updateAxon(self);
}

void (*orig_AXNManager_removeNotificationRequest)(AXNManager* self, SEL cmd, id req);
void hook_AXNManager_removeNotificationRequest(AXNManager* self, SEL cmd, id req) {
	orig_AXNManager_removeNotificationRequest(self, cmd, req);
	updateAxon(self);
}

void (*orig_AXNManager_clearAll)(AXNManager* self, SEL cmd);
void hook_AXNManager_clearAll(AXNManager* self, SEL cmd) {
	orig_AXNManager_clearAll(self, cmd);
	updateAxon(self);
}

void (*orig_AXNManager_clearAll1)(AXNManager* self, SEL cmd, NSString* bundle);
void hook_AXNManager_clearAll1(AXNManager* self, SEL cmd, NSString* bundle) {
	orig_AXNManager_clearAll1(self, cmd, bundle);
	updateAxon(self);
}
