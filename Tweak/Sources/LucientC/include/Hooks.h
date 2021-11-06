//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#ifndef Hooks_h
#define Hooks_h

#import "Tweak.h"
#import "compat/Axon.h"
#import "lockscreen/NCNotificationStructuredListViewController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// the actual hooks

extern void (*orig_SBUIProudLockIconView_didMoveToWindow)(UIView* self, SEL cmd);
extern void hook_SBUIProudLockIconView_didMoveToWindow(UIView* self, SEL cmd);

extern void (*orig_SBFLockScreenDateView_didMoveToWindow)(UIView* self, SEL cmd);
extern void hook_SBFLockScreenDateView_didMoveToWindow(UIView* self, SEL cmd);

extern void (*orig_SBFLockScreenDateSubtitleView_didMoveToWindow)(UIView* self, SEL cmd);
extern void hook_SBFLockScreenDateSubtitleView_didMoveToWindow(UIView* self, SEL cmd);

extern void (*orig_SBFLockScreenDateSubtitleDateView_didMoveToWindow)(UIView* self, SEL cmd);
extern void hook_SBFLockScreenDateSubtitleDateView_didMoveToWindow(UIView* self, SEL cmd);

extern id (*orig_NCNotificationListSectionRevealHintView_initWithFrame)(UIView* self, SEL cmd, CGRect frame);
extern id hook_NCNotificationListSectionRevealHintView_initWithFrame(UIView* self, SEL cmd, CGRect frame);

extern id (*orig_CSQuickActionsButton_didMoveToWindow)(UIView* self, SEL cmd);
extern id hook_CSQuickActionsButton_didMoveToWindow(UIView* self, SEL cmd);

extern void (*orig_CSTeachableMomentsContainerView_didMoveToWindow)(UIView* self, SEL cmd);
extern void hook_CSTeachableMomentsContainerView_didMoveToWindow(UIView* self, SEL cmd);

extern id (*orig_SBUICallToActionLabel_initWithFrame)(UILabel* self, SEL cmd, CGRect frame);
extern id hook_SBUICallToActionLabel_initWithFrame(UILabel* self, SEL cmd, CGRect frame);

extern BOOL (*orig_UIViewController_canShowWhileLocked)(UIViewController* self, SEL cmd);
extern BOOL hook_UIViewController_canShowWhileLocked(UIViewController* self, SEL cmd);

extern BOOL (*orig_NCNotificationStructuredListViewController_hasVisibleContent)(
	NCNotificationStructuredListViewController* self, SEL cmd);
extern BOOL hook_NCNotificationStructuredListViewController_hasVisibleContent(
	NCNotificationStructuredListViewController* self, SEL cmd);

extern UIEdgeInsets (*orig_CSCombinedListViewController_listViewDefaultContentInsets)(UIViewController* self, SEL cmd);
extern UIEdgeInsets hook_CSCombinedListViewController_listViewDefaultContentInsets(UIViewController* self, SEL cmd);

extern void (*orig_CSCoverSheetViewController_viewWillAppear)(UIViewController* self, SEL cmd, BOOL animated);
extern void hook_CSCoverSheetViewController_viewWillAppear(UIViewController* self, SEL cmd, BOOL animated);

extern void (*orig_CSCoverSheetViewController_viewDidDisappear)(UIViewController* self, SEL cmd, BOOL animated);
extern void hook_CSCoverSheetViewController_viewDidDisappear(UIViewController* self, SEL cmd, BOOL animated);

extern void (*orig_SBLockScreenManager_lockUIFromSource)(UIView* self, SEL cmd, int arg1, id withOptions);
extern void hook_SBLockScreenManager_lockUIFromSource(UIView* self, SEL cmd, int arg1, id withOptions);

extern void (*orig_SBBacklightController_turnOnScreenFullyWithBacklightSource)(UIView* self, SEL cmd, long long arg1);
extern void hook_SBBacklightController_turnOnScreenFullyWithBacklightSource(UIView* self, SEL cmd, long long arg1);

extern void (*orig_SBMediaController_setNowPlayingInfo)(NSObject* self, SEL cmd, id arg1);
extern void hook_SBMediaController_setNowPlayingInfo(NSObject* self, SEL cmd, id arg1);

extern BOOL (*orig_MRUNowPlayingView_showSuggestionsView)(MRUNowPlayingView* self, SEL cmd);
extern BOOL hook_MRUNowPlayingView_showSuggestionsView(MRUNowPlayingView* self, SEL cmd);

extern void (*orig_MRUNowPlayingView_setShowSuggestionsView)(MRUNowPlayingView* self, SEL cmd, BOOL arg1);
extern void hook_MRUNowPlayingView_setShowSuggestionsView(MRUNowPlayingView* self, SEL cmd, BOOL arg1);

extern void (*orig_NCNotificationMasterList_scrollViewDidScroll)(NSObject* self, SEL cmd, UIScrollView* scrollView);
extern void hook_NCNotificationMasterList_scrollViewDidScroll(NSObject* self, SEL cmd, UIScrollView* scrollView);

extern void (*orig_LastLookManager_setIsActive)(id self, SEL cmd, BOOL isActive);
extern void hook_LastLookManager_setIsActive(id self, SEL cmd, BOOL isActive);

extern void (*orig_AXNManager_insertNotificationRequest)(AXNManager* self, SEL cmd, id req);
extern void hook_AXNManager_insertNotificationRequest(AXNManager* self, SEL cmd, id req);

extern void (*orig_AXNManager_removeNotificationRequest)(AXNManager* self, SEL cmd, id req);
extern void hook_AXNManager_removeNotificationRequest(AXNManager* self, SEL cmd, id req);

extern void (*orig_AXNManager_clearAll)(AXNManager* self, SEL cmd);
extern void hook_AXNManager_clearAll(AXNManager* self, SEL cmd);

extern void (*orig_AXNManager_clearAll1)(AXNManager* self, SEL cmd, NSString* bundle);
extern void hook_AXNManager_clearAll1(AXNManager* self, SEL cmd, NSString* bundle);

extern void (*orig_TKOController_insertNotificationRequest)(TKOController* self, SEL cmd, id req);
extern void hook_TKOController_insertNotificationRequest(TKOController* self, SEL cmd, id req);

extern void (*orig_TKOController_removeNotificationRequest)(TKOController* self, SEL cmd, id req);
extern void hook_TKOController_removeNotificationRequest(TKOController* self, SEL cmd, id req);

extern void (*orig_TKOController_removeAllNotifications)(TKOController* self, SEL cmd);
extern void hook_TKOController_removeAllNotifications(TKOController* self, SEL cmd);

void (*orig_TKOGroupView_show)(TKOGroupView* self, SEL cmd);
void hook_TKOGroupView_show(TKOGroupView* self, SEL cmd);

void (*orig_TKOGroupView_hide)(TKOGroupView* self, SEL cmd);
void hook_TKOGroupView_hide(TKOGroupView* self, SEL cmd);

void (*orig_TKOGroupView_update)(TKOGroupView* self, SEL cmd);
void hook_TKOGroupView_update(TKOGroupView* self, SEL cmd);
#endif /* Hooks_h */
