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
