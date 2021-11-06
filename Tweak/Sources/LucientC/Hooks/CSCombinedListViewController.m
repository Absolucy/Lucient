//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Hooks.h"
#import "../include/Tweak.h"

UIEdgeInsets (*orig_CSCombinedListViewController_listViewDefaultContentInsets)(UIViewController* self, SEL cmd);
UIEdgeInsets hook_CSCombinedListViewController_listViewDefaultContentInsets(UIViewController* self, SEL cmd) {
	UIEdgeInsets orig = orig_CSCombinedListViewController_listViewDefaultContentInsets(self, cmd);
	if (isStupidTinyPhone())
		orig.top = ([[UIScreen mainScreen] bounds].size.height / 2);
	else
		orig.top = ([[UIScreen mainScreen] bounds].size.height / 3);
	return orig;
}
