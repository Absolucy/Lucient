//
//  Tweak.h
//  Lucient
//
//  Created by Lucy on 6/16/21.
//

#ifndef Tweak_h
#define Tweak_h

#import "CSCoverSheetView.h"
#import "Globals.h"
#import "NSTask.h"
#import "blake3.h"
#import "drm.h"
#import "libpddokdo.h"
#import "string_table.h"
#import <Foundation/Foundation.h>

extern void setNotifsVisible(BOOL);
extern void setMusicVisible(BOOL);
extern void setScreenOn(BOOL);
extern void showActivationWindow(void);
extern void runDrm(void);
extern BOOL isValidated(void);
extern BOOL isEnabled(void);

UIColor* getColorFromImage(UIImage* image, int calculation, int dimension, int flexibility, int range);
UIImage* lockScreenWallpaper();

#endif /* Tweak_h */
