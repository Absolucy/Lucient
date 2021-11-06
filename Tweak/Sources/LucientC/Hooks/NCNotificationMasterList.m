//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Hooks.h"

void (*orig_NCNotificationMasterList_scrollViewDidScroll)(NSObject* self, SEL cmd, UIScrollView* scrollView);
void hook_NCNotificationMasterList_scrollViewDidScroll(NSObject* self, SEL cmd, UIScrollView* scrollView) {
	orig_NCNotificationMasterList_scrollViewDidScroll(self, cmd, scrollView);
	setNotificationsOffset(scrollView.contentOffset.y + scrollView.contentInset.top);
}
