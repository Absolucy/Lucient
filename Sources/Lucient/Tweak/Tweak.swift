//
//  Tweak.swift
//
//
//  Created by Lucy on 6/21/21.
//

import Foundation

@_cdecl("isEnabled")
public dynamic func isEnabled() -> Bool {
	guard let defaults = UserDefaults(suiteName: "/var/mobile/Library/Preferences/moe.absolucy.lucient.plist") else {
		return true
	}
	guard let enabled = defaults.object(forKey: "enabled") as? Bool? else {
		return true
	}
	return enabled ?? true
}
