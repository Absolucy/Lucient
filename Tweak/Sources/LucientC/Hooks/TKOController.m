//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Tweak.h"

void (*orig_TKOController_insertNotificationRequest)(TKOController* self, SEL cmd, id req);
void hook_TKOController_insertNotificationRequest(TKOController* self, SEL cmd, id req) {
	orig_TKOController_insertNotificationRequest(self, cmd, req);
	updateTako(self);
}

void (*orig_TKOController_removeNotificationRequest)(TKOController* self, SEL cmd, id req);
void hook_TKOController_removeNotificationRequest(TKOController* self, SEL cmd, id req) {
	orig_TKOController_removeNotificationRequest(self, cmd, req);
	updateTako(self);
}

void (*orig_TKOController_removeAllNotifications)(TKOController* self, SEL cmd);
void hook_TKOController_removeAllNotifications(TKOController* self, SEL cmd) {
	orig_TKOController_removeAllNotifications(self, cmd);
	updateTako(self);
}
