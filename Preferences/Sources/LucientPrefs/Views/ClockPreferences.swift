//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

struct ClockPreferences: View {
	@Binding var timeSettings: TimeSettings

	var body: some View {
		Section(header: Text("Clock")) {
			Toggle("Always Use Small Clock", isOn: $timeSettings.alwaysSmall)
				.padding(.vertical, 5)
				.onTapGesture(count: 2) {
					timeSettings.alwaysSmall = false
				}
			if FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/LastLook.dylib")
				&& timeSettings.alwaysSmall
			{
				Toggle("Always Use Small Clock In AOD", isOn: $timeSettings.alwaysSmallInAod)
					.padding(.vertical, 5)
					.onTapGesture(count: 2) {
						timeSettings.alwaysSmallInAod = false
					}
			}
			if !timeSettings.alwaysSmall {
				VStack(spacing: 0) {
					Text("Large Clock Format").padding(.vertical, 5)
					Picker(selection: $timeSettings.is24hr, label: EmptyView()) {
						Text("12-hour").tag(false)
						Text("24-hour").tag(true)
					}.padding(.vertical, 5)
				}
				.pickerStyle(SegmentedPickerStyle()).padding(.vertical, 5)
				.onTapGesture(count: 2) {
					timeSettings.is24hr = false
				}
			}
			VStack(spacing: 0) {
				Text("Small Clock Style").padding(.vertical, 5)
				Picker(selection: $timeSettings.mode, label: EmptyView()) {
					Text("Wide").tag(ClockMode.wide)
					Text("Tall").tag(ClockMode.tall)
				}
				.pickerStyle(SegmentedPickerStyle()).padding(.vertical, 5)
				.onTapGesture(count: 2) {
					timeSettings.mode = .wide
				}
			}.padding(.vertical, 5)
			VStack(spacing: 0) {
				Text("Small Clock Format").padding(.bottom, 5)
				if timeSettings.mode == .wide {
					TextField("nsdateformatter.com for guide", text: $timeSettings.leftFmt.format)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.onTapGesture(count: 2) {
							timeSettings.leftFmt.format = "hh:mm"
						}
						.padding(.bottom, 5)
					HStack {
						Spacer()
						Text(timeSettings.leftFmt.string(from: Date()))
							.font(.caption)
						Spacer()
					}.padding(.top, 5)
				} else {
					TextField("nsdateformatter.com for guide", text: $timeSettings.rightFmt.format)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.onTapGesture(count: 2) {
							timeSettings.rightFmt.format = "h mm"
						}
						.padding(.bottom, 5)
					HStack {
						Spacer()
						VStack(alignment: .center, spacing: 0) {
							let timeThings = timeSettings.rightFmt.string(from: Date()).split(separator: " ")
							ForEach(0 ..< timeThings.count) { idx in
								Text(String(timeThings[idx]))
							}.font(.caption)
						}
						Spacer()
					}.padding(.top, 5)
				}
			}.padding(.vertical, 5)
			if !timeSettings.alwaysSmall {
				SizeOption(name: "Large Clock Size", option: $timeSettings.bigFontSize, min: 64, max: 256, defaultOption: {
					isStupidTinyPhone() ? 100 : 160
				}())
					.padding(.vertical, 4)
				SizeOption(name: "Large Clock Spacing", option: $timeSettings.bigSpacing, min: 0, max: 128, defaultOption: 15)
					.padding(.vertical, 4)
				SizeOption(name: "Large Clock Offset", option: $timeSettings.bigOffset, min: -200, max: 200, defaultOption: 0)
					.padding(.vertical, 4)
			}
			SizeOption(name: "Small Clock Size", option: $timeSettings.smallFontSize, min: 32, max: 96, defaultOption: {
				isStupidTinyPhone() ? 48 : 72
			}())
				.padding(.vertical, 4)
			SizeOption(
				name: "Small Clock Offset",
				option: $timeSettings.smallOffset,
				min: -200,
				max: 200,
				defaultOption: 0
			)
			.padding(.vertical, 4)
			Toggle("Custom Style", isOn: $timeSettings.usingFontSettings).padding(.vertical, 4)
				.onTapGesture(count: 2) {
					timeSettings.usingFontSettings = false
				}
			if timeSettings.usingFontSettings {
				StyleOption(fontSettings: $timeSettings.fontSettings)
					.padding(.vertical, 4)
			}
		}
	}
}
