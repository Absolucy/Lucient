//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Hooks.h"
#import "../include/Tweak.h"
#import <MediaRemote/MediaRemote.h>

void (*orig_SBMediaController_setNowPlayingInfo)(NSObject* self, SEL cmd, id arg1);
void hook_SBMediaController_setNowPlayingInfo(NSObject* self, SEL cmd, id arg1) {
	orig_SBMediaController_setNowPlayingInfo(self, cmd, arg1);
	if (!isEnabled())
		return;
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
	  if (information) {
		  NSDictionary* dict = (__bridge NSDictionary*)information;
		  if (dict)
			  setMusicVisible(YES);
	  } else {
		  setMusicVisible(NO);
	  }
	});
}
