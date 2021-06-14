//
//  Hooks.h
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#ifndef Hooks_h
#define Hooks_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface CSCoverSheetView : UIView
@end

@interface CSCoverSheetViewController : UIViewController
- (void)setPasscodeLockVisible:(BOOL)arg1 animated:(BOOL)arg2;
- (void)activatePage:(unsigned long long)arg1 animated:(BOOL)arg2 withCompletion:(/*^block*/ id)arg3;
@end

@interface CSQuickActionsViewController : UIViewController
@end

@interface CSProudLockViewController : UIViewController
@end

@interface CSQuickActionsButton : UIControl
@end

@interface NCNotificationStructuredListViewController : UIViewController
- (BOOL)hasVisibleContent;
@end

// the actual hooks

extern CSCoverSheetView* coverSheetView;
extern UIViewController* thanosDateView;
extern UIViewController* thanosTimeView;

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

#endif /* Hooks_h */
