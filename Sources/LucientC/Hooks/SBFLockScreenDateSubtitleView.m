//
//  SBFLockScreenDateSubtitleView.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "../include/Hooks.h"

void (*orig_SBFLockScreenDateSubtitleView_didMoveToWindow)(UIView* self, SEL cmd);
void hook_SBFLockScreenDateSubtitleView_didMoveToWindow(UIView* self, SEL cmd) {
	UILabel* dateLabel = [self valueForKey:@"_label"];
	[dateLabel removeFromSuperview];
	return orig_SBFLockScreenDateSubtitleView_didMoveToWindow(self, cmd);
}
