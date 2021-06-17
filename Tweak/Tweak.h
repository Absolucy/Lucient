//
//  Tweak.h
//  Lucient
//
//  Created by Lucy on 6/16/21.
//

#ifndef Tweak_h
#define Tweak_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

extern void setNotifsVisible(BOOL);
extern void setScreenOn(BOOL);

#endif /* Tweak_h */
