//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TKOView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property(nonatomic, retain) NSMutableArray* cellsInfo;
@end

@interface TKOGroupView : UIView
@property(nonatomic, retain) NSMutableArray* iconsView;
@property(nonatomic) BOOL isVisible;
@end

@interface TKOController : NSObject
@property(nonatomic, weak) TKOView* view;
@property(nonatomic, retain) TKOGroupView* groupView;
+ (TKOController*)sharedInstance;
- (void)insertNotificationRequest:(id)req;
- (void)removeNotificationRequest:(id)req;
- (void)removeAllNotifications;
- (void)hideAllNotifications;
@end
