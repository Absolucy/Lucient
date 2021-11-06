//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal extension UserDefaults {
	static var lucientSettings: Settings {
		get {
			guard let defaults = UserDefaults(suiteName: "/var/mobile/Library/Preferences/moe.absolucy.lucient.plist"),
			      let json = defaults.string(forKey: "settings"),
			      let jsonData = json.data(using: .utf8),
			      let settings = try? JSONDecoder().decode(Settings.self, from: jsonData)
			else {
				return Settings()
			}
			return settings
		}
		set {
			guard let defaults = UserDefaults(suiteName: "/var/mobile/Library/Preferences/moe.absolucy.lucient.plist"),
			      let jsonData = try? JSONEncoder().encode(newValue),
			      let json = String(data: jsonData, encoding: .utf8)
			else {
				return
			}
			defaults.set(json, forKey: "settings")
			defaults.synchronize()
		}
	}
}
