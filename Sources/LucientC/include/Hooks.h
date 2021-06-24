//
//  Hooks.h
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#ifndef Hooks_h
#define Hooks_h

#import "CSCoverSheetView.h"
#import "OtherCrap.h"
#import "Tweak.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// the actual hooks

extern id (*orig_CSCoverSheetView_initWithFrame)(CSCoverSheetView* self, SEL cmd, CGRect frame);
extern id hook_CSCoverSheetView_initWithFrame(CSCoverSheetView* self, SEL cmd, CGRect frame);

extern void (*orig_CSCoverSheetView_didMoveToWindow)(CSCoverSheetView* self, SEL cmd);
extern void hook_CSCoverSheetView_didMoveToWindow(CSCoverSheetView* self, SEL cmd);

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

extern id (*orig_CSQuickActionsButton_initWithFrame)(UIView* self, SEL cmd, CGRect frame);
extern id hook_CSQuickActionsButton_initWithFrame(UIView* self, SEL cmd, CGRect frame);

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

extern void (*orig_CSCoverSheetViewController_finishUIUnlockFromSource)(UIViewController* self, SEL cmd, int state);
extern void hook_CSCoverSheetViewController_finishUIUnlockFromSource(UIViewController* self, SEL cmd, int state);

extern BOOL (*orig_MRUNowPlayingView_showSuggestionsView)(UIView* self, SEL cmd);
extern BOOL hook_MRUNowPlayingView_showSuggestionsView(UIView* self, SEL cmd);

extern void (*orig_MRUNowPlayingView_setShowSuggestionsView)(UIView* self, SEL cmd, BOOL arg1);
extern void hook_MRUNowPlayingView_setShowSuggestionsView(UIView* self, SEL cmd, BOOL arg1);

#endif /* Hooks_h */
