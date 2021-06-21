//
//  PreferenceLoaderController.swift
//  NomaePreferences
//
//  Created by Eamon Tracey.
//  Copyright © 2021 Eamon Tracey. All rights reserved.
//

import UIKit

/// A view controller containing`PSViewController` methods that
/// PreferenceLoader automatically calls.
@objcMembers open class PreferenceLoaderController: UIViewController {
	func setRootController(_: Any?) {}
	func setParentController(_: Any?) {}
	func setSpecifier(_: Any?) {}
	func specifier() -> Any? {
		fatalError(
			"Some genius automatically assumed that this was a PSViewController... Yell at whoever made whatever preferences tweak you're using. This might also appear if you're using BioProtectXS, in which case, USE A BETTER TWEAK INSTEAD OF THAT RIP-OFF!"
		)
	}
}
