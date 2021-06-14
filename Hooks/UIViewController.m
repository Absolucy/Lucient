//
//  UIViewController.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

BOOL (*orig_UIViewController_canShowWhileLocked)(UIViewController* self, SEL cmd);
BOOL hook_UIViewController_canShowWhileLocked(UIViewController* self, SEL cmd) {
	return YES;
}
