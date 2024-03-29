//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

struct LittleTimeView: View {
	@EnvironmentObject var settings: Settings
	/// The current time/date
	@Binding var date: Date

	var body: some View {
		let color = ColorManager.instance.get(
			settings.timeSettings.usingFontSettings,
			mode: settings.globalFontSettings.colorMode,
			customMode: settings.timeSettings.fontSettings.colorMode,
			color: settings.globalFontSettings.customColor,
			customColor: settings.timeSettings.fontSettings.customColor
		)
		let font = FontRegistration.font(
			size: settings.timeSettings.smallFontSize,
			style: settings.timeSettings.usingFontSettings
				? settings.timeSettings.fontSettings.style
				: settings.globalFontSettings.style,
			custom: settings.timeSettings.usingFontSettings
				? settings.timeSettings.fontSettings.customFont
				: settings.globalFontSettings.customFont
		)
		Text(settings.timeSettings.leftFmt.string(from: date))
			.minimumScaleFactor(0.1)
			.font(font)
			.foregroundColor(color)
	}
}

struct LittleTimeView_Previews: PreviewProvider {
	static var previews: some View {
		LittleTimeView(date: .constant(Date()))
	}
}
