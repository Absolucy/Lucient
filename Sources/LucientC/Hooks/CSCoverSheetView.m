//
//  CSCoverSheetViewController.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "../include/Globals.h"
#import "../include/Hooks.h"
#import "../include/Tweak.h"

extern UIViewController* makeDateView(void);
extern UIViewController* makeTimeView(void);

id (*orig_CSCoverSheetView_initWithFrame)(CSCoverSheetView* self, SEL cmd, CGRect frame);
id hook_CSCoverSheetView_initWithFrame(CSCoverSheetView* self, SEL cmd, CGRect frame) {
	if (!coverSheetView) {
		coverSheetView = self;
	}
	return orig_CSCoverSheetView_initWithFrame(self, cmd, frame);
}

void (*orig_CSCoverSheetView_didMoveToWindow)(CSCoverSheetView* self, SEL cmd);
void hook_CSCoverSheetView_didMoveToWindow(CSCoverSheetView* self, SEL cmd) {
	orig_CSCoverSheetView_didMoveToWindow(self, cmd);

	if (!isValidated()) {
		if (timeView) {
			[timeView.view removeFromSuperview];
			timeView = nil;
		}
		if (dateView) {
			[dateView.view removeFromSuperview];
			dateView = nil;
		}
		return;
	}

	if (!dateView) {
		dateView = makeDateView();
		dateView.view.backgroundColor = UIColor.clearColor;
	}
	dateView.view.frame = self.frame;
	dateView.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:dateView.view];
	[NSLayoutConstraint activateConstraints:@[
		[dateView.view.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:30.0],
		[dateView.view.topAnchor constraintEqualToAnchor:self.topAnchor constant:175.0]
	]];

	if (!timeView) {
		timeView = makeTimeView();
		timeView.view.backgroundColor = UIColor.clearColor;
	}
	timeView.view.translatesAutoresizingMaskIntoConstraints = NO;
	timeView.view.frame = self.frame;
	[self addSubview:timeView.view];
	timeConstraintCx = [timeView.view.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
	timeConstraintCy = [timeView.view.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
	timeConstraintCx.active = true;
	timeConstraintCy.active = true;
	timeConstraintDateLeft = [timeView.view.leftAnchor constraintEqualToAnchor:dateView.view.leftAnchor];
	timeConstraintRight = [timeView.view.rightAnchor constraintEqualToAnchor:self.rightAnchor];
	timeConstraintDateTop = [timeView.view.topAnchor constraintEqualToAnchor:dateView.view.topAnchor constant:-32];
	timeConstraintDateBottom = [timeView.view.bottomAnchor constraintEqualToAnchor:dateView.view.topAnchor];
}
