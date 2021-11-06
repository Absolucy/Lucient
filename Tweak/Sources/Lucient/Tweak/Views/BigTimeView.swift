//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


import SwiftUI

struct BigTimeView: View {
	@EnvironmentObject var settings: Settings
	/// The current time/date
	@Binding var date: Date
	/// Formats the hour text
	@StateObject private var hourFmt = DateTimeFormatter(fmt: "HH")
	/// Formats the minute text
	@StateObject private var minuteFmt = DateTimeFormatter(fmt: "mm")

	var body: some View {
		let color = ColorManager.instance.get(
			settings.timeSettings.usingFontSettings,
			mode: settings.globalFontSettings.colorMode,
			customMode: settings.timeSettings.fontSettings.colorMode,
			color: settings.globalFontSettings.customColor,
			customColor: settings.timeSettings.fontSettings.customColor
		)
		let font = FontRegistration.font(
			size: settings.timeSettings.bigFontSize,
			style: settings.timeSettings.usingFontSettings
				? settings.timeSettings.fontSettings.style
				: settings.globalFontSettings.style,
			custom: settings.timeSettings.usingFontSettings
				? settings.timeSettings.fontSettings.customFont
				: settings.globalFontSettings.customFont
		)
		VStack(alignment: .center, spacing: 0) {
			Text(hourFmt.string(from: date))
				.offset(x: 0, y: CGFloat(settings.timeSettings.bigSpacing))
			Text(minuteFmt.string(from: date))
				.offset(x: 0, y: CGFloat(-settings.timeSettings.bigSpacing))
		}
		.minimumScaleFactor(0.1)
		.font(font)
		.foregroundColor(color)
		.onAppear {
			hourFmt.format = settings.timeSettings.is24hr ? "HH" : "hh"
		}
		.onChange(of: settings.timeSettings.is24hr) { newValue in
			hourFmt.format = newValue ? "HH" : "hh"
		}
	}
}
