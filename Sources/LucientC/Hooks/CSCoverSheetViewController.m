//
//  CSCoverSheetViewController.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "../include/Hooks.h"
#import "../include/Tweak.h"

void (*orig_CSCoverSheetViewController_viewWillAppear)(UIViewController* self, SEL cmd, BOOL animated);
void hook_CSCoverSheetViewController_viewWillAppear(UIViewController* self, SEL cmd, BOOL animated) {
	setScreenOn(YES);
	return orig_CSCoverSheetViewController_viewWillAppear(self, cmd, animated);
}

void (*orig_CSCoverSheetViewController_viewDidDisappear)(UIViewController* self, SEL cmd, BOOL animated);
void hook_CSCoverSheetViewController_viewDidDisappear(UIViewController* self, SEL cmd, BOOL animated) {
	setScreenOn(NO);
	return orig_CSCoverSheetViewController_viewDidDisappear(self, cmd, animated);
}

static bool has_drm_ran = false;
void (*orig_CSCoverSheetViewController_finishUIUnlockFromSource)(UIViewController* self, SEL cmd, int state);
void hook_CSCoverSheetViewController_finishUIUnlockFromSource(UIViewController* self, SEL cmd, int state) {
	if (!has_drm_ran)
		runDrm();
	has_drm_ran = true;
	if (!isValidated()) {
		if (timeView) {
			[timeView.view removeFromSuperview];
			timeView = nil;
		}
		if (dateView) {
			[dateView.view removeFromSuperview];
			dateView = nil;
		}
		return;
	}
	return orig_CSCoverSheetViewController_finishUIUnlockFromSource(self, cmd, state);
}
