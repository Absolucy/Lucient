//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include "../include/Tweak.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static dispatch_once_t thingy;

BOOL (*orig_MRUNowPlayingView_showSuggestionsView)(MRUNowPlayingView* self, SEL cmd);
BOOL hook_MRUNowPlayingView_showSuggestionsView(MRUNowPlayingView* self, SEL cmd) {
	BOOL orig = orig_MRUNowPlayingView_showSuggestionsView(self, cmd);
	if ([NSStringFromClass([self.superview.superview class]) isEqualToString:@"CSMediaControlsView"]) {
		dispatch_once(&thingy, ^() {
		  mruNowPlayingView = self;
		});
		setMusicSuggestionsVisible(orig);
	}
	return orig;
}

void (*orig_MRUNowPlayingView_setShowSuggestionsView)(MRUNowPlayingView* self, SEL cmd, BOOL arg1);
void hook_MRUNowPlayingView_setShowSuggestionsView(MRUNowPlayingView* self, SEL cmd, BOOL arg1) {
	if ([NSStringFromClass([self.superview.superview class]) isEqualToString:@"CSMediaControlsView"]) {
		dispatch_once(&thingy, ^() {
		  mruNowPlayingView = self;
		});
		setMusicSuggestionsVisible(arg1);
	}
	orig_MRUNowPlayingView_setShowSuggestionsView(self, cmd, arg1);
}
