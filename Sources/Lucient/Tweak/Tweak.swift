//
//  Tweak.swift
//
//
//  Created by Lucy on 6/21/21.
//

import Foundation
import LucientC

@_cdecl("isEnabled")
internal func isEnabled() -> Bool {
	guard let defaults = UserDefaults(suiteName: "/var/mobile/Library/Preferences/moe.absolucy.lucient.plist") else {
		return true
	}
	guard let enabled = defaults.object(forKey: "enabled") as? Bool? else {
		return true
	}
	return enabled ?? true
}

@_cdecl("removeIfInvalid")
internal func removeIfInvalid() {
	#if DRM
		if !DRM.ticketAuthorized() {
			dateView?.view?.removeFromSuperview()
			dateView = nil
			timeView?.view?.removeFromSuperview()
			timeView = nil
		}
	#endif
}
