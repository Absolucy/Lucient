//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Tweak.h"

void (*orig_TKOGroupView_show)(TKOGroupView* self, SEL cmd);
void hook_TKOGroupView_show(TKOGroupView* self, SEL cmd) {
	orig_TKOGroupView_show(self, cmd);
	updateTako([objc_getClass("TKOController") sharedInstance]);
}

void (*orig_TKOGroupView_hide)(TKOGroupView* self, SEL cmd);
void hook_TKOGroupView_hide(TKOGroupView* self, SEL cmd) {
	orig_TKOGroupView_hide(self, cmd);
	updateTako([objc_getClass("TKOController") sharedInstance]);
}

void (*orig_TKOGroupView_update)(TKOGroupView* self, SEL cmd);
void hook_TKOGroupView_update(TKOGroupView* self, SEL cmd) {
	orig_TKOGroupView_update(self, cmd);
	updateTako([objc_getClass("TKOController") sharedInstance]);
}
