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

#endif /* Hooks_h */
