//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


import Foundation
import LucientC

@_cdecl("isEnabled")
internal func isEnabled() -> Bool {
	UserDefaults.lucientSettings.enabled
}

@_cdecl("hideQuickActions")
internal func hideQuickActions() -> Bool {
	UserDefaults.lucientSettings.stockSettings.hideQuickActions
}

@_cdecl("hideLock")
internal func hideLock() -> Bool {
	UserDefaults.lucientSettings.stockSettings.hideLock
}

@_cdecl("isStupidTinyPhone")
internal func isStupidTinyPhone() -> Bool {
	let screen = UIScreen.main
	let size = screen.bounds.size
	let value = min(size.height, size.width) * screen.scale
	return value < 820
}
