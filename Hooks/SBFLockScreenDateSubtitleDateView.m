//
//  SBFLockScreenDateSubtitleDateView.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

void (*orig_SBFLockScreenDateSubtitleDateView_didMoveToWindow)(UIView* self, SEL cmd);
void hook_SBFLockScreenDateSubtitleDateView_didMoveToWindow(UIView* self, SEL cmd) {
	UILabel* lunarLabel = [self valueForKey:@"_alternateDateLabel"];
	[lunarLabel removeFromSuperview];
	return orig_SBFLockScreenDateSubtitleDateView_didMoveToWindow(self, cmd);
}
