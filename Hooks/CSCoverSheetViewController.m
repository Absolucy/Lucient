//
//  CSCoverSheetViewController.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

extern void updateData(void);

void (*orig_CSCoverSheetViewController_viewWillAppear)(UIViewController* self, SEL cmd, BOOL animated);
void hook_CSCoverSheetViewController_viewWillAppear(UIViewController* self, SEL cmd, BOOL animated) {
	updateData();
	return orig_CSCoverSheetViewController_viewWillAppear(self, cmd, animated);
}
