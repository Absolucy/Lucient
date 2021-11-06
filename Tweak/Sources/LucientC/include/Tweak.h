//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#ifndef Tweak_h
#define Tweak_h

#import "Globals.h"
#import "NSTask.h"
#import "compat/Axon.h"
#import "compat/Tako.h"
#import "libpddokdo.h"
#import "lockscreen/CSCoverSheetViewController.h"
#import "lockscreen/MRUNowPlayingView.h"
#import "lockscreen/NCNotificationStructuredListViewController.h"
#import "popups.h"
#import <Foundation/Foundation.h>

@interface UIView (private)
- (UIViewController*)_viewDelegate;
@end

extern void setNotifsVisible(BOOL);
extern void setMusicVisible(BOOL);
extern void setMusicSuggestionsVisible(BOOL);
extern void setScreenOn(BOOL);
extern void setAodOn(BOOL);
extern BOOL isEnabled(void);
extern void removeIfInvalid(void);
extern BOOL isStupidTinyPhone(void);
extern void setNotificationsOffset(CGFloat);
extern BOOL hideQuickActions(void);
extern BOOL hideLock(void);
extern void updateAxon(AXNManager*);
extern void updateTako(TKOController*);

UIColor* getColorFromImage(UIImage* image, int calculation, int dimension, int flexibility, int range);
BOOL isDarkImage(UIImage* image);

extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

#endif /* Tweak_h */
