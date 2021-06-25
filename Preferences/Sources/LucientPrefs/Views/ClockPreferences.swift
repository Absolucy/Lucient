//
//  ClockPreferences.swift
//
//
//  Created by Lucy on 6/24/21.
//

import SwiftUI

struct ClockPreferences: View {
	@Binding var separatedColors: Bool
	@Preference("maxTimeSize", identifier: identifier) private var maxTimeSize: Double = 160
	@Preference("minTimeSize", identifier: identifier) private var minTimeSize: Double = 72
	@Preference("timeOffset", identifier: identifier) private var timeOffset: Double = 15
	@Preference("timeOnTheRight", identifier: identifier) private var timeOnTheRight = false
	@Preference("timeColorMode", identifier: identifier) private var timeColorMode = ColorMode.secondary
	@Preference("timeColor", identifier: identifier) private var timeColor = Color.primary
	@Preference("time24hr", identifier: identifier) private var time24Hour = false
	@Preference("timeShowAmPm", identifier: identifier) private var timeShowAmPm = false

	var body: some View {
		Section(header: Text("Clock")) {
			Toggle(time24Hour ? "24-hour time" : "12-hour time", isOn: $time24Hour)
			if !time24Hour {
				Toggle("Show AM/PM", isOn: $timeShowAmPm)
			}
			VStack(spacing: 0) {
				Text("Small Clock Position").padding(.vertical, 5)
				Picker(selection: $timeOnTheRight, label: EmptyView()) {
					Text("Left").tag(false)
					Text("Right").tag(true)
				}.pickerStyle(SegmentedPickerStyle()).padding(.bottom, 4)
			}
			if separatedColors {
				Picker(selection: $timeColorMode, label: Text("Color")) {
					Text("Custom").tag(ColorMode.custom)
					Text("Distinctive Color").tag(ColorMode.distinctive)
					Text("Background Primary").tag(ColorMode.primary)
					Text("Background Secondary").tag(ColorMode.secondary)
					Text("Background Color").tag(ColorMode.background)
				}.padding(.vertical, 4)
				if timeColorMode == .custom {
					ColorPicker("Custom Color", selection: $timeColor).padding(.vertical, 4)
				}
			}
			SizeOption(name: "Large Clock Size", option: $maxTimeSize, min: 64, max: 256, defaultOption: 160)
				.padding(.vertical, 4)
			SizeOption(name: "Large Clock Offset", option: $timeOffset, min: 0, max: 128, defaultOption: 15)
				.padding(.vertical, 4)
			SizeOption(name: "Small Clock Size", option: $minTimeSize, min: 32, max: 96, defaultOption: 72)
				.padding(.top, 4)
		}
	}
}
