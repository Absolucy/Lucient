//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#ifndef Tweak_h
#define Tweak_h

#import "Globals.h"
#import "NSTask.h"
#import "libpddokdo.h"
#import "lockscreen/CSCoverSheetViewController.h"
#import "lockscreen/MRUNowPlayingView.h"
#import "lockscreen/NCNotificationMasterList.h"
#import "lockscreen/NCNotificationStructuredListViewController.h"
#import "lockscreen/SBBacklightController.h"
#import "lockscreen/SBLockScreenManager.h"
#import <Foundation/Foundation.h>
#import <MediaRemote/MediaRemote.h>

@interface UIView (private)
- (UIViewController*)_viewDelegate;
@end

UIColor* getColorFromImage(UIImage* image, int calculation, int dimension, int flexibility, int range);
BOOL isDarkImage(UIImage* image);

extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

#endif /* Tweak_h */
