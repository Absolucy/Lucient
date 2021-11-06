//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


import EventKit
import SwiftUI

struct EventView: View {
	@EnvironmentObject var settings: Settings

	/// Calender formatter, used to format when an event will occur
	@ObservedObject private var calFmt = DateTimeFormatter(fmt: "HH:mm")

	/// Duration formatter, used to format how long it is til an event
	private let durationFmt: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.day, .hour, .minute]
		formatter.unitsStyle = .full
		formatter.maximumUnitCount = 1
		return formatter
	}()

	/// The actual event.
	var event: EKEvent

	var body: some View {
		let color = ColorManager.instance.get(
			settings.dateSettings.usingFontSettings,
			mode: settings.globalFontSettings.colorMode,
			customMode: settings.dateSettings.fontSettings.colorMode,
			color: settings.globalFontSettings.customColor,
			customColor: settings.dateSettings.fontSettings.customColor
		)
		let font = FontRegistration.font(
			size: settings.dateSettings.fontSize,
			style: settings.dateSettings.usingFontSettings ? settings.dateSettings.fontSettings.style : settings
				.globalFontSettings.style,
			custom: settings.dateSettings.usingFontSettings ? settings.dateSettings.fontSettings.customFont : settings
				.globalFontSettings.customFont
		)
		let string: String = {
			var string = durationFmt.string(from: Date().distance(to: event.startDate))!
			if let title = event.title {
				string.append(": \(title)")
			}
			if let location = event.location {
				string.append(contentsOf: " @ \(location)")
			}
			return string
		}()
		VStack(alignment: .leading) {
			Text(string)
				.font(font)
				.foregroundColor(color)
				.lineLimit(settings.miscSettings.cutOffReminders ? 1 : nil)
				.align(alignment: settings.dateSettings.alignment)
			Label("\(calFmt.string(from: event.startDate)) - \(calFmt.string(from: event.endDate))", systemImage: "calendar")
				.font(font)
				.foregroundColor(color)
				.align(alignment: settings.dateSettings.alignment)
		}.multilineTextAlignment(settings.dateSettings.alignment.ui())
	}
}
