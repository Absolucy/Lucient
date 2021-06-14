//
//  SBUICallToActionLabel.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

id (*orig_SBUICallToActionLabel_initWithFrame)(UILabel* self, SEL cmd, CGRect frame);
id hook_SBUICallToActionLabel_initWithFrame(UILabel* self, SEL cmd, CGRect frame) {
	return nil;
}
