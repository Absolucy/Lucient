//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "include/Hooks.h"
#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import <objc/runtime.h>

enum LIBHOOKER_ERR
{
	LIBHOOKER_OK = 0,
	LIBHOOKER_ERR_SELECTOR_NOT_FOUND = 1,
	LIBHOOKER_ERR_SHORT_FUNC = 2,
	LIBHOOKER_ERR_BAD_INSN_AT_START = 3,
	LIBHOOKER_ERR_VM = 4,
	LIBHOOKER_ERR_NO_SYMBOL = 5
};

static enum LIBHOOKER_ERR (*LBHookMessage)(Class class, SEL sel, void* replacement, void* old_ptr);
static const char* (*LHStrError)(enum LIBHOOKER_ERR err);
static void (*HookMessageEx)(Class class, SEL sel, IMP imp, IMP* result);

static void* libhooker;
static void* libblackjack;
static void* substrate;
static void* substitute;

extern void initialize_string_table();

void setupHookingLib() {
	if ((libhooker = dlopen("/usr/lib/libhooker.dylib", RTLD_LAZY)) != NULL &&
		(libblackjack = dlopen("/usr/lib/libblackjack.dylib", RTLD_LAZY)) != NULL)
	{
		if ((LBHookMessage = dlsym(libblackjack, "LBHookMessage")) != NULL &&
			(LHStrError = dlsym(libhooker, "LHStrError")) != NULL)
		{
			NSLog(@"[Lucient] using libhooker :)");
			return;
		}
		// Failed to get the proper symbols, clean up
		LBHookMessage = NULL;
		LHStrError = NULL;
		if (libhooker) {
			dlclose(libhooker);
			libhooker = NULL;
		}
		if (libblackjack) {
			dlclose(libblackjack);
			libblackjack = NULL;
		}
	}
	if ((substitute = dlopen("/usr/lib/libsubstitute.dylib", RTLD_LAZY)) != NULL) {
		if ((HookMessageEx = dlsym(substitute, "SubHookMessageEx")) != NULL) {
			NSLog(@"[Lucient] using Substitute");
			return;
		}
		// Failed to get the proper symbols, clean up
		HookMessageEx = NULL;
		if (substitute) {
			dlclose(substitute);
			substitute = NULL;
		}
	}
	if ((substrate = dlopen("/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", RTLD_LAZY)) != NULL) {
		if ((HookMessageEx = dlsym(substrate, "MSHookMessageEx")) != NULL) {
			NSLog(@"[Lucient] using Substrate");
			return;
		}
		// Failed to get the proper symbols, clean up
		HookMessageEx = NULL;
		if (substrate) {
			dlclose(substrate);
			substrate = NULL;
		}
	}
	NSLog(@"[Lucient] failed to load hooking library");
}

void hook(Class cls, SEL sel, void* imp, void** result) {
	if (!(LBHookMessage && LHStrError) && !HookMessageEx)
		setupHookingLib();
	if (LBHookMessage && LHStrError) {
		enum LIBHOOKER_ERR ret = LBHookMessage(cls, sel, imp, result);
		if (ret != LIBHOOKER_OK) {
			const char* err = LHStrError(ret);
			NSLog(@"[Lucient] failed to hook -[%@ %@]: %s", NSStringFromClass(cls), NSStringFromSelector(sel), err);
		}
	} else if (HookMessageEx) {
		HookMessageEx(cls, sel, imp, (IMP*)result);
	} else {
		NSLog(@"[Lucient] no hooking library present???");
	}
}

__attribute__((constructor)) void initTweakFunc() {
	if (!isEnabled())
		return;
	hook(objc_getClass("SBUIProudLockIconView"), @selector(didMoveToWindow),
		 (void*)&hook_SBUIProudLockIconView_didMoveToWindow, (void**)&orig_SBUIProudLockIconView_didMoveToWindow);
	hook(objc_getClass("SBFLockScreenDateView"), @selector(didMoveToWindow),
		 (void*)&hook_SBFLockScreenDateView_didMoveToWindow, (void**)&orig_SBFLockScreenDateView_didMoveToWindow);
	hook(objc_getClass("SBFLockScreenDateSubtitleView"), @selector(didMoveToWindow),
		 (void*)&hook_SBFLockScreenDateSubtitleView_didMoveToWindow,
		 (void**)&orig_SBFLockScreenDateSubtitleView_didMoveToWindow);
	hook(objc_getClass("SBFLockScreenDateSubtitleDateView"), @selector(didMoveToWindow),
		 (void*)&hook_SBFLockScreenDateSubtitleDateView_didMoveToWindow,
		 (void**)&orig_SBFLockScreenDateSubtitleDateView_didMoveToWindow);
	hook(objc_getClass("NCNotificationListSectionRevealHintView"), @selector(initWithFrame:),
		 (void*)&hook_NCNotificationListSectionRevealHintView_initWithFrame,
		 (void**)&orig_NCNotificationListSectionRevealHintView_initWithFrame);
	hook(objc_getClass("CSQuickActionsButton"), @selector(didMoveToWindow),
		 (void*)&hook_CSQuickActionsButton_didMoveToWindow, (void**)&orig_CSQuickActionsButton_didMoveToWindow);
	hook(objc_getClass("CSTeachableMomentsContainerView"), @selector(didMoveToWindow),
		 (void*)&hook_CSTeachableMomentsContainerView_didMoveToWindow,
		 (void**)&orig_CSTeachableMomentsContainerView_didMoveToWindow);
	hook(objc_getClass("SBUICallToActionLabel"), @selector(initWithFrame:),
		 (void*)&hook_SBUICallToActionLabel_initWithFrame, (void**)&orig_SBUICallToActionLabel_initWithFrame);
	hook(objc_getClass("UIViewController"), @selector(_canShowWhileLocked),
		 (void*)&hook_UIViewController_canShowWhileLocked, (void**)&orig_UIViewController_canShowWhileLocked);
	hook(objc_getClass("NCNotificationStructuredListViewController"), @selector(hasVisibleContent),
		 (void*)&hook_NCNotificationStructuredListViewController_hasVisibleContent,
		 (void**)&orig_NCNotificationStructuredListViewController_hasVisibleContent);
	hook(objc_getClass("CSCombinedListViewController"), @selector(_listViewDefaultContentInsets),
		 (void*)&hook_CSCombinedListViewController_listViewDefaultContentInsets,
		 (void**)&orig_CSCombinedListViewController_listViewDefaultContentInsets);
	hook(objc_getClass("CSCoverSheetViewController"), @selector(viewWillAppear:),
		 (void*)&hook_CSCoverSheetViewController_viewWillAppear,
		 (void**)&orig_CSCoverSheetViewController_viewWillAppear);
	hook(objc_getClass("CSCoverSheetViewController"), @selector(viewDidDisappear:),
		 (void*)&hook_CSCoverSheetViewController_viewDidDisappear,
		 (void**)&orig_CSCoverSheetViewController_viewDidDisappear);
	hook(objc_getClass("SBLockScreenManager"), @selector(lockUIFromSource:withOptions:),
		 (void*)&hook_SBLockScreenManager_lockUIFromSource, (void**)&orig_SBLockScreenManager_lockUIFromSource);
	hook(objc_getClass("SBBacklightController"), @selector(turnOnScreenFullyWithBacklightSource:),
		 (void*)&hook_SBBacklightController_turnOnScreenFullyWithBacklightSource,
		 (void**)&orig_SBBacklightController_turnOnScreenFullyWithBacklightSource);
	hook(objc_getClass("SBMediaController"), @selector(setNowPlayingInfo:),
		 (void*)&hook_SBMediaController_setNowPlayingInfo, (void**)&orig_SBMediaController_setNowPlayingInfo);
	hook(objc_getClass("NCNotificationMasterList"), @selector(scrollViewDidScroll:),
		 (void*)&hook_NCNotificationMasterList_scrollViewDidScroll,
		 (void**)&orig_NCNotificationMasterList_scrollViewDidScroll);
	Class MRUNowPlayingView;
	if ((MRUNowPlayingView = objc_getClass("MRUNowPlayingView")) != nil) {
		hook(MRUNowPlayingView, @selector(showSuggestionsView), (void*)&hook_MRUNowPlayingView_showSuggestionsView,
			 (void**)&orig_MRUNowPlayingView_showSuggestionsView);
		hook(MRUNowPlayingView, @selector(setShowSuggestionsView:),
			 (void*)&hook_MRUNowPlayingView_setShowSuggestionsView,
			 (void**)&orig_MRUNowPlayingView_setShowSuggestionsView);
	}
	Class LastLookManager;
	if ((LastLookManager = objc_getClass("LastLookManager")) != nil) {
		hook(LastLookManager, @selector(setIsActive:), (void*)&hook_LastLookManager_setIsActive,
			 (void**)&orig_LastLookManager_setIsActive);
	}
	Class AXNManager;
	if ((AXNManager = objc_getClass("AXNManager")) != nil) {
		hook(AXNManager, @selector(insertNotificationRequest:), (void*)&hook_AXNManager_insertNotificationRequest,
			 (void**)&orig_AXNManager_insertNotificationRequest);
		hook(AXNManager, @selector(removeNotificationRequest:), (void*)&hook_AXNManager_removeNotificationRequest,
			 (void**)&orig_AXNManager_removeNotificationRequest);
		hook(AXNManager, @selector(clearAll), (void*)&hook_AXNManager_clearAll, (void**)&orig_AXNManager_clearAll);
		hook(AXNManager, @selector(clearAll:), (void*)&hook_AXNManager_clearAll1, (void**)&orig_AXNManager_clearAll1);
	}
	Class TKOController;
	if ((TKOController = objc_getClass("TKOController")) != nil) {
		hook(TKOController, @selector(insertNotificationRequest:), (void*)&hook_TKOController_insertNotificationRequest,
			 (void**)&orig_TKOController_insertNotificationRequest);
		hook(TKOController, @selector(removeNotificationRequest:), (void*)&hook_TKOController_removeNotificationRequest,
			 (void**)&orig_TKOController_removeNotificationRequest);
		hook(TKOController, @selector(removeAllNotifications), (void*)&hook_TKOController_removeAllNotifications,
			 (void**)&orig_TKOController_removeAllNotifications);
	}
	Class TKOGroupView;
	if ((TKOGroupView = objc_getClass("TKOGroupView")) != nil) {
		hook(TKOGroupView, @selector(show), (void*)&hook_TKOGroupView_show, (void**)&orig_TKOGroupView_show);
		hook(TKOGroupView, @selector(hide), (void*)&hook_TKOGroupView_hide, (void**)&orig_TKOGroupView_hide);
		hook(TKOGroupView, @selector(update), (void*)&hook_TKOGroupView_update, (void**)&orig_TKOGroupView_update);
	}
}

__attribute__((destructor)) static void cleanup() {
	if (libhooker) {
		LHStrError = NULL;
		dlclose(libhooker);
		libhooker = NULL;
	}
	if (libblackjack) {
		LBHookMessage = NULL;
		dlclose(libblackjack);
		libblackjack = NULL;
	}
	HookMessageEx = NULL;
	if (substitute) {
		dlclose(substitute);
		substitute = NULL;
	}
	if (substrate) {
		dlclose(substrate);
		substrate = NULL;
	}
}
