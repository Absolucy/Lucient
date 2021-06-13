//
//  CSQuickActionsButton.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

static id (*orig_CSQuickActionsButton_initWithFrame)(UIView* self, SEL cmd, CGRect frame);
static id hook_CSQuickActionsButton_initWithFrame(UIView* self, SEL cmd, CGRect frame) {
	return nil;
}
