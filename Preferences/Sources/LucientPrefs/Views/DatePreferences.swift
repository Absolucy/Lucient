//
//  DatePreferences.swift
//
//
//  Created by Lucy on 6/24/21.
//

import SwiftUI

struct DatePreferences: View {
	@Binding var separatedColors: Bool
	@Preference("showWeather", identifier: identifier) private var showWeather = true
	@Preference("dateFontSize", identifier: identifier) private var dateFontSize: Double = 24
	@Preference("dateOffset", identifier: identifier) private var dateOffset: Double = 0
	@Preference("dateColorMode", identifier: identifier) private var dateColorMode = ColorMode.secondary
	@Preference("dateColor", identifier: identifier) private var dateColor = Color.primary

	var body: some View {
		Section(header: Text("Date / Weather")) {
			Toggle("Show Weather", isOn: $showWeather)
				.padding(.bottom, 4)
			if separatedColors {
				Picker(selection: $dateColorMode, label: Text("Color")) {
					Text("Custom").tag(ColorMode.custom)
					Text("Distinctive Color").tag(ColorMode.distinctive)
					Text("Background Primary").tag(ColorMode.primary)
					Text("Background Secondary").tag(ColorMode.secondary)
					Text("Background Color").tag(ColorMode.background)
				}.padding(.vertical, 4)
				if dateColorMode == .custom {
					ColorPicker("Custom Color", selection: $dateColor).padding(.vertical, 4)
				}
			}
			SizeOption(name: "Font Size", option: $dateFontSize, min: 16, max: 64, defaultOption: 24)
				.padding(.vertical, 4)
			SizeOption(name: "Offset", option: $dateOffset, min: 0, max: 128, defaultOption: 2)
				.padding(.top, 4)
		}
	}
}
