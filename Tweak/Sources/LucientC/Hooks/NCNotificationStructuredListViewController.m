//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Hooks.h"

extern void setNotifsVisible(bool visible);

BOOL(*orig_NCNotificationStructuredListViewController_hasVisibleContent)
(NCNotificationStructuredListViewController* self, SEL cmd);
BOOL hook_NCNotificationStructuredListViewController_hasVisibleContent(NCNotificationStructuredListViewController* self,
																	   SEL cmd) {
	BOOL orig = orig_NCNotificationStructuredListViewController_hasVisibleContent(self, cmd);
	setNotifsVisible(orig);
	return orig;
}
