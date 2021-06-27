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

// This is super duper ugly but idk how to improve it
id (*orig_CSCoverSheetView_initWithFrame)(CSCoverSheetView* self, SEL cmd, CGRect frame);
id hook_CSCoverSheetView_initWithFrame(CSCoverSheetView* self, SEL cmd, CGRect frame) {
	id orig = orig_CSCoverSheetView_initWithFrame(self, cmd, frame);
	
	// Set the global cover sheet view
	if (!coverSheetView)
		coverSheetView = self;

	// Set up the date/weather/reminder view
	if (!dateView) {
		dateView = makeDateView();
		dateView.view.backgroundColor = UIColor.clearColor;
	}
	// Give it our frame
	dateView.view.frame = self.frame;
	dateView.view.translatesAutoresizingMaskIntoConstraints = NO;
	// Add it as a subview
	[self addSubview:dateView.view];
	// Constrain it
	[NSLayoutConstraint activateConstraints:@[
		[dateView.view.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:30.0],
		[dateView.view.topAnchor constraintEqualToAnchor:self.topAnchor constant:175.0],
		[dateView.view.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor constant:-30]
	]];

	// Set up the clock view
	if (!timeView) {
		timeView = makeTimeView();
		timeView.view.backgroundColor = UIColor.clearColor;
	}
	// Give it our frame
	timeView.view.translatesAutoresizingMaskIntoConstraints = NO;
	timeView.view.frame = self.frame;
	// Add it as a subview
	[self addSubview:timeView.view];
	// Set up the various constraints
	if (!timeConstraintCx) {
		timeConstraintCx = [timeView.view.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
		timeConstraintCx.active = true;
	}
	if (!timeConstraintCy) {
		timeConstraintCy = [timeView.view.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
		timeConstraintCy.active = true;
	}
	if (!timeConstraintDateLeft)
		timeConstraintDateLeft = [timeView.view.leftAnchor constraintEqualToAnchor:dateView.view.leftAnchor];
	if(!timeConstraintRight)
		timeConstraintRight = [timeView.view.rightAnchor constraintEqualToAnchor:self.rightAnchor];
	if (!timeConstraintDateTop)
		timeConstraintDateTop = [timeView.view.topAnchor constraintEqualToAnchor:dateView.view.topAnchor constant:-32];
	if (!timeConstraintDateBottom)
		timeConstraintDateBottom = [timeView.view.bottomAnchor constraintEqualToAnchor:dateView.view.topAnchor];
	return orig;
}
