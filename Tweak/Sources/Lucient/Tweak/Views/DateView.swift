//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


import SwiftUI

struct DateView: View {
	@EnvironmentObject var settings: Settings
	/// The current time/date
	@Binding var date: Date

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
		Text(settings.dateSettings.fmt.string(from: date))
			.font(font)
			.foregroundColor(color)
			.multilineTextAlignment(settings.dateSettings.alignment.ui())
	}
}
