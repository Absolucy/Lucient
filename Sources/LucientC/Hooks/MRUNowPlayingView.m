//
//  MRUNowPlayingView.m
//
//
//  Created by Lucy on 6/23/21.
//

#include "../include/Tweak.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

BOOL (*orig_MRUNowPlayingView_showSuggestionsView)(UIView* self, SEL cmd);
BOOL hook_MRUNowPlayingView_showSuggestionsView(UIView* self, SEL cmd) {
	BOOL orig = orig_MRUNowPlayingView_showSuggestionsView(self, cmd);
	setMusicSuggestionsVisible(orig);
	return orig;
}

void (*orig_MRUNowPlayingView_setShowSuggestionsView)(UIView* self, SEL cmd, BOOL arg1);
void hook_MRUNowPlayingView_setShowSuggestionsView(UIView* self, SEL cmd, BOOL arg1) {
	setMusicSuggestionsVisible(arg1);
	orig_MRUNowPlayingView_setShowSuggestionsView(self, cmd, arg1);
}
