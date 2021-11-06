//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

struct DatePreferences: View {
	@Binding var dateSettings: DateSettings
	@Binding var miscSettings: MiscSettings

	var body: some View {
		Section(header: Text("Date / Weather")) {
			VStack {
				Text("Date Format").padding(.bottom, 5)
				TextField("nsdateformatter.com for guide", text: $dateSettings.fmt.format)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.onTapGesture(count: 2) {
						dateSettings.fmt.format = "E, MMM d"
					}
					.padding(.bottom, 5)
				HStack {
					Spacer()
					Text(dateSettings.fmt.string(from: Date()))
						.font(.caption)
					Spacer()
				}.padding(.top, 5)
			}.padding(.bottom, 5)
			Toggle("Show Weather", isOn: $miscSettings.weatherEnabled)
				.padding(.vertical, 5)
				.onTapGesture(count: 2) {
					miscSettings.weatherEnabled = true
				}
			Toggle("Show Reminders", isOn: $miscSettings.remindersEnabled)
				.padding(.vertical, 5)
				.onTapGesture(count: 2) {
					miscSettings.remindersEnabled = true
				}
			if miscSettings.remindersEnabled {
				Toggle("Cut Off Long Reminders", isOn: $miscSettings.cutOffReminders)
					.padding(.vertical, 5)
					.onTapGesture(count: 2) {
						miscSettings.cutOffReminders = true
					}
			}
			SizeOption(name: "Font Size", option: $dateSettings.fontSize, min: 16, max: 64, defaultOption: {
				isStupidTinyPhone() ? 16 : 24
			}())
				.padding(.vertical, 5)
			SizeOption(name: "Offset", option: $dateSettings.offset, min: -128, max: 128, defaultOption: 0)
				.padding(.vertical, 5)
			if miscSettings.weatherEnabled && miscSettings.remindersEnabled {
				SizeOption(
					format: "%.0f s",
					name: "Weather/Reminder Flip Timer",
					option: $miscSettings.reminderFlipTimer,
					min: 1,
					max: 15,
					defaultOption: 5
				)
				.padding(.vertical, 5)
			}
			if miscSettings.weatherEnabled {
				SizeOption(
					format: "%.0f s",
					name: "Weather Refresh Timer",
					option: $miscSettings.weatherRefreshTimer,
					min: 15,
					max: 300,
					defaultOption: 90
				)
				.padding(.vertical, 5)
			}
			Toggle("Custom Style", isOn: $dateSettings.usingFontSettings)
				.padding(.vertical, 4)
				.onTapGesture(count: 2) {
					dateSettings.usingFontSettings = false
				}
			if dateSettings.usingFontSettings {
				StyleOption(fontSettings: $dateSettings.fontSettings)
					.padding(.vertical, 4)
			}
		}
	}
}
