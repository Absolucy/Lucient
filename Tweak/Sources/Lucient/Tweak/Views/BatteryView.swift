//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


import SwiftUI
import UIKit

struct BatteryView: View {
	@Preference("settings", identifier: "moe.absolucy.lucient") private var settings = Settings()
	@State var batteryState: UIDevice.BatteryState
	@State var batteryLevel: Int
	let observer = NotificationCenter.default.publisher(for: NSNotification.Name("moe.absolucy.lucient.battery"))
		.receive(on: RunLoop.main)

	init() {
		let device = UIDevice.current
		device.isBatteryMonitoringEnabled = true
		_batteryState = State(initialValue: device.batteryState)
		_batteryLevel = State(initialValue: Int(lroundf(device.batteryLevel * 100)))
	}

	var body: some View {
		let color = ColorManager.instance.get(
			settings.batterySettings.usingFontSettings,
			mode: settings.globalFontSettings.colorMode,
			customMode: settings.batterySettings.fontSettings.colorMode,
			color: settings.globalFontSettings.customColor,
			customColor: settings.batterySettings.fontSettings.customColor
		)
		let font = FontRegistration.font(
			size: settings.batterySettings.fontSize,
			style: settings.batterySettings.usingFontSettings ? settings.batterySettings.fontSettings.style : settings
				.globalFontSettings.style,
			custom: settings.batterySettings.usingFontSettings ? settings.batterySettings.fontSettings.customFont : settings
				.globalFontSettings.customFont
		)
		VStack {
			switch batteryState {
			case UIDevice.BatteryState.full:
				Text("Charged")
					.font(font)
					.foregroundColor(color)
			case UIDevice.BatteryState.charging:
				Text("\(batteryLevel)% · Charging")
					.font(font)
					.foregroundColor(color)
			default:
				Text("\(batteryLevel)%")
					.font(font)
					.foregroundColor(color)
			}
		}
		.padding()
		.if(!settings.batterySettings.enabled, transform: { $0.hidden() })
		.offset(x: 0, y: CGFloat(settings.batterySettings.offset))
		.onReceive(observer) { _ in
			let device = UIDevice.current
			batteryState = device.batteryState
			batteryLevel = Int(lroundf(device.batteryLevel * 100))
		}
	}
}

@_cdecl("makeBatteryView")
internal func makeBatteryView() -> UIViewController! {
	UIHostingController(rootView: BatteryView())
}
