//
//  CSCoverSheetViewController.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "Hooks.h"

extern UIViewController* makeDateView(void);
extern UIViewController* makeTimeView(void);

CSCoverSheetView* coverSheetView = nil;
UIViewController* thanosDateView = nil;
UIViewController* thanosTimeView = nil;

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
	
	if (!thanosTimeView) {
		thanosTimeView = makeTimeView();
		thanosTimeView.view.backgroundColor = UIColor.clearColor;
	}
	thanosTimeView.view.frame = self.frame;
	thanosTimeView.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:thanosTimeView.view];
	[NSLayoutConstraint activateConstraints:@[
		[thanosTimeView.view.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
		[thanosTimeView.view.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
	]];
	
	if (!thanosDateView) {
		thanosDateView = makeDateView();
		thanosDateView.view.backgroundColor = UIColor.clearColor;
	}
	thanosDateView.view.frame = self.frame;
	thanosDateView.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:thanosDateView.view];
	[NSLayoutConstraint activateConstraints:@[
		[thanosDateView.view.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:30.0],
		[thanosDateView.view.bottomAnchor constraintEqualToAnchor:thanosTimeView.view.topAnchor constant:-32.0]
	]];
}
