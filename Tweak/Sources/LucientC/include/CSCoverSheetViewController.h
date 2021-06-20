//
//  CSCoverSheetViewController.h
//  Lucient
//
//  Created by Lucy on 6/17/21.
//

#ifndef CSCoverSheetViewController_h
#define CSCoverSheetViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CSCoverSheetViewController : UIViewController
- (void)setPasscodeLockVisible:(BOOL)arg1 animated:(BOOL)arg2;
- (void)activatePage:(unsigned long long)arg1 animated:(BOOL)arg2 withCompletion:(/*^block*/ id)arg3;
@end

#endif /* CSCoverSheetViewController_h */
