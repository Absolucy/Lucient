//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MRUNowPlayingView : UIView
@property(nonatomic, retain) UIView* suggestionsView;
@property(assign, nonatomic) long long layout;
@property(assign, nonatomic) long long context;
@property(assign, nonatomic) BOOL showSuggestionsView;
- (UIView*)suggestionsView;
- (BOOL)showSuggestionsView;
- (long long)layout;
- (long long)context;
@end
