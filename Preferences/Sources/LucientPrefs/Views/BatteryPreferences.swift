//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

struct BatteryPreferences: View {
	@Binding var batterySettings: BatterySettings

	var body: some View {
		Section(header: Text("Battery")) {
			Toggle("Enabled", isOn: $batterySettings.enabled)
				.padding(.vertical, 5)
			if batterySettings.enabled {
				SizeOption(name: "Font Size", option: $batterySettings.fontSize, min: 8, max: 64, defaultOption: 16)
					.padding(.vertical, 5)
				SizeOption(name: "Offset", option: $batterySettings.offset, min: -128, max: 16, defaultOption: 0)
					.padding(.vertical, 5)
				Toggle("Custom Style", isOn: $batterySettings.usingFontSettings).padding(.vertical, 4)
					.onTapGesture(count: 5) {
						batterySettings.usingFontSettings = false
					}
					.padding(.vertical, 5)
				if batterySettings.usingFontSettings {
					StyleOption(fontSettings: $batterySettings.fontSettings)
						.padding(.vertical, 5)
				}
			}
		}
	}
}
