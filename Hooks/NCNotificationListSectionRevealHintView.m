//
//  NCNotificationListSectionRevealHintView.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

static id (*orig_NCNotificationListSectionRevealHintView_initWithFrame)(UIView* self, SEL cmd, CGRect frame);
static id hook_NCNotificationListSectionRevealHintView_initWithFrame(UIView* self, SEL cmd, CGRect frame) {
	return nil;
}
