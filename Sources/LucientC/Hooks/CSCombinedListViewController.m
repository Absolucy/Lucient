//
//  CSCombinedListViewController.m
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

#import "../include/Hooks.h"

UIEdgeInsets (*orig_CSCombinedListViewController_listViewDefaultContentInsets)(UIViewController* self, SEL cmd);
UIEdgeInsets hook_CSCombinedListViewController_listViewDefaultContentInsets(UIViewController* self, SEL cmd) {
	UIEdgeInsets orig = orig_CSCombinedListViewController_listViewDefaultContentInsets(self, cmd);
	orig.top += 64;
	return orig;
}
