//
//  SBMediaController.m
//
//
//  Created by Lucy on 6/18/21.
//

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
