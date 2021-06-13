//
//  CSCoverSheetViewController.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"
#import "Thanos-Swift.h"

CSCoverSheetView* coverSheetView = nil;
UIViewController* thanosTimeView = nil;
UIViewController* thanosDateView = nil;

static id (*orig_CSCoverSheetView_initWithFrame)(CSCoverSheetView* self, SEL cmd, CGRect frame);
static id hook_CSCoverSheetView_initWithFrame(CSCoverSheetView* self, SEL cmd, CGRect frame) {
	if (!coverSheetView) {
		coverSheetView = self;
	}
	return orig_CSCoverSheetView_initWithFrame(self, cmd, frame);
}

static void (*orig_CSCoverSheetView_didMoveToWindow)(CSCoverSheetView* self, SEL cmd);
static void hook_CSCoverSheetView_didMoveToWindow(CSCoverSheetView* self, SEL cmd) {
	orig_CSCoverSheetView_didMoveToWindow(self, cmd);
	if (!thanosTimeView) {
	}
}
