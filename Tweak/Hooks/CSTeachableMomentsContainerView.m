//
//  CSTeachableMomentsContainerView.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

void (*orig_CSTeachableMomentsContainerView_didMoveToWindow)(UIView* self, SEL cmd);
void hook_CSTeachableMomentsContainerView_didMoveToWindow(UIView* self, SEL cmd) {
	[self removeFromSuperview];
	return orig_CSTeachableMomentsContainerView_didMoveToWindow(self, cmd);
}