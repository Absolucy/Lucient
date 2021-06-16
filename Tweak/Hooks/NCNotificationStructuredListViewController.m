//
//  NCNotificationStructuredListViewController.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

extern void setNotifsVisible(bool visible);

BOOL(*orig_NCNotificationStructuredListViewController_hasVisibleContent)
(NCNotificationStructuredListViewController* self, SEL cmd);
BOOL hook_NCNotificationStructuredListViewController_hasVisibleContent(NCNotificationStructuredListViewController* self,
																	   SEL cmd) {
	BOOL orig = orig_NCNotificationStructuredListViewController_hasVisibleContent(self, cmd);
	setNotifsVisible(orig);
	return orig;
}
