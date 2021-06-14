//
//  Tweak.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Hooks/Hooks.h"

extern void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP* result);

void hook(Class cls, SEL sel, void* imp, void** result) {
	NSLog(@"[Thanos] hooking [%@ %@]", NSStringFromClass(cls), NSStringFromSelector(sel));
	MSHookMessageEx(cls, sel, (IMP)imp, (IMP*)result);
}

__attribute__((constructor)) __attribute__((used)) static void initTweakFunc() {
	hook(objc_getClass("CSCoverSheetView"), @selector(initWithFrame:),
				 (void*)&hook_CSCoverSheetView_initWithFrame, (void**)&orig_CSCoverSheetView_initWithFrame);
	hook(objc_getClass("CSCoverSheetView"), @selector(didMoveToWindow),
		 (void*)&hook_CSCoverSheetView_didMoveToWindow, (void**)&orig_CSCoverSheetView_didMoveToWindow);
	hook(objc_getClass("SBUIProudLockIconView"), @selector(didMoveToWindow),
		 (void*)&hook_SBUIProudLockIconView_didMoveToWindow, (void**)&orig_SBUIProudLockIconView_didMoveToWindow);
	hook(objc_getClass("SBFLockScreenDateView"), @selector(didMoveToWindow),
		 (void*)&hook_SBFLockScreenDateView_didMoveToWindow, (void**)&orig_SBFLockScreenDateView_didMoveToWindow);
	hook(objc_getClass("SBFLockScreenDateSubtitleView"), @selector(didMoveToWindow),
		 (void*)&hook_SBFLockScreenDateSubtitleView_didMoveToWindow, (void**)&orig_SBFLockScreenDateSubtitleView_didMoveToWindow);
	hook(objc_getClass("SBFLockScreenDateSubtitleDateView"), @selector(didMoveToWindow),
		 (void*)&hook_SBFLockScreenDateSubtitleDateView_didMoveToWindow, (void**)&orig_SBFLockScreenDateSubtitleDateView_didMoveToWindow);
	hook(objc_getClass("NCNotificationListSectionRevealHintView"), @selector(initWithFrame:),
		 (void*)&hook_NCNotificationListSectionRevealHintView_initWithFrame, (void**)&orig_NCNotificationListSectionRevealHintView_initWithFrame);
	hook(objc_getClass("CSQuickActionsButton"), @selector(initWithFrame:),
		 (void*)&hook_CSQuickActionsButton_initWithFrame, (void**)&orig_CSQuickActionsButton_initWithFrame);
	hook(objc_getClass("CSTeachableMomentsContainerView"), @selector(didMoveToWindow),
		 (void*)&hook_CSTeachableMomentsContainerView_didMoveToWindow, (void**)&orig_CSTeachableMomentsContainerView_didMoveToWindow);
	hook(objc_getClass("SBUICallToActionLabel"), @selector(initWithFrame:),
		 (void*)&hook_SBUICallToActionLabel_initWithFrame, (void**)&orig_SBUICallToActionLabel_initWithFrame);
	hook(objc_getClass("UIViewController"), @selector(_canShowWhileLocked),
				 (void*)&hook_UIViewController_canShowWhileLocked, (void**)&orig_UIViewController_canShowWhileLocked);
	hook(objc_getClass("NCNotificationStructuredListViewController"), @selector(hasVisibleContent),
		 (void*)&hook_NCNotificationStructuredListViewController_hasVisibleContent, (void**)&orig_NCNotificationStructuredListViewController_hasVisibleContent);
	hook(objc_getClass("CSCombinedListViewController"), @selector(_listViewDefaultContentInsets),
		 (void*)&hook_CSCombinedListViewController_listViewDefaultContentInsets, (void**)&orig_CSCombinedListViewController_listViewDefaultContentInsets);
	hook(objc_getClass("CSCoverSheetViewController"), @selector(viewWillAppear:),
		 (void*)&hook_CSCoverSheetViewController_viewWillAppear, (void**)&orig_CSCoverSheetViewController_viewWillAppear);
}
