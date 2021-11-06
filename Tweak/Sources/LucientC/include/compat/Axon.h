//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AXNView : UIView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, retain) NSMutableArray* list;
@end

@interface AXNManager : NSObject
@property(nonatomic, weak) AXNView* view;
+ (AXNManager*)sharedInstance;
- (void)insertNotificationRequest:(id)req;
- (void)removeNotificationRequest:(id)req;
- (void)clearAll:(NSString*)bundleIdentifier;
- (void)clearAll;
@end
