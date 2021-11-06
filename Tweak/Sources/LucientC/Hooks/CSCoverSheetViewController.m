//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "../include/Globals.h"
#import "../include/Hooks.h"
#import "../include/Tweak.h"

extern UIViewController* makeLsView(void);
extern UIViewController* makeBatteryView(void);

void (*orig_CSCoverSheetViewController_viewWillAppear)(UIViewController* self, SEL cmd, BOOL animated);
void hook_CSCoverSheetViewController_viewWillAppear(UIViewController* self, SEL cmd, BOOL animated) {
	setScreenOn(YES);
	// Set up the date/weather/reminder view
	if (!lucientView) {
		lucientView = makeLsView();
		lucientView.view.backgroundColor = UIColor.clearColor;
		lucientView.view.userInteractionEnabled = NO;
		lucientView.view.translatesAutoresizingMaskIntoConstraints = NO;
	}
	// Remove it from the superview if it has one.
	[lucientView removeFromParentViewController];
	[lucientView.view removeFromSuperview];
	// Give it our frame
	lucientView.view.frame = self.view.frame;
	// Add it as a subview
	[self addChildViewController:lucientView];
	[self.view addSubview:lucientView.view];
	// Constrain it
	CGFloat half = ([[UIScreen mainScreen] bounds].size.height / 3) * 2;
	[NSLayoutConstraint activateConstraints:@[
		[lucientView.view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
		[lucientView.view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
		[lucientView.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
		[lucientView.view.heightAnchor constraintEqualToConstant:half],
	]];

	// Set up the battery view
	if (!batteryView) {
		batteryView = makeBatteryView();
		batteryView.view.backgroundColor = UIColor.clearColor;
		batteryView.view.userInteractionEnabled = NO;
		batteryView.view.translatesAutoresizingMaskIntoConstraints = NO;
	}
	// Remove it from the superview if it has one.
	[batteryView removeFromParentViewController];
	[batteryView.view removeFromSuperview];
	// Give it our frame
	batteryView.view.frame = self.view.frame;
	// Add it as a subview
	[self addChildViewController:batteryView];
	[self.view addSubview:batteryView.view];
	// Constrain it
	[NSLayoutConstraint activateConstraints:@[
		[batteryView.view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
		[batteryView.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
	]];
	return orig_CSCoverSheetViewController_viewWillAppear(self, cmd, animated);
}

void (*orig_CSCoverSheetViewController_viewDidDisappear)(UIViewController* self, SEL cmd, BOOL animated);
void hook_CSCoverSheetViewController_viewDidDisappear(UIViewController* self, SEL cmd, BOOL animated) {
	setScreenOn(NO);
	if (lucientView) {
		[lucientView.view removeFromSuperview];
		[lucientView removeFromParentViewController];
		lucientView = nil;
	}
	if (batteryView) {
		[batteryView.view removeFromSuperview];
		[batteryView removeFromParentViewController];
		batteryView = nil;
	}
	return orig_CSCoverSheetViewController_viewDidDisappear(self, cmd, animated);
}
