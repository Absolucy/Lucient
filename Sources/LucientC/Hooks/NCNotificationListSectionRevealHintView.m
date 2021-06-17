//
//  NCNotificationListSectionRevealHintView.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "../include/Hooks.h"

id (*orig_NCNotificationListSectionRevealHintView_initWithFrame)(UIView* self, SEL cmd, CGRect frame);
id hook_NCNotificationListSectionRevealHintView_initWithFrame(UIView* self, SEL cmd, CGRect frame) {
	return nil;
}
