//
//  12TimeView.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import SwiftUI
import UIKit

internal struct TimeView: View {
	static var view = TimeView()

	private let minuteFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "mm"
		return formatter
	}()

	private let timeObserver = NotificationCenter.default.publisher(for: NSNotification.Name("moe.absolucy.lucient.time"))

	@Preference("fontStyle", identifier: "moe.absolucy.lucient") private var fontStyle = FontStyle.ios
	@Preference("customFont",
	            identifier: "moe.absolucy.lucient") var customFont = "/Library/Lucy/LucientResources.bundle/Roboto.ttf"
	@Preference("colorMode", identifier: "moe.absolucy.lucient") private var colorMode = ColorMode.secondary
	@Preference("color", identifier: "moe.absolucy.lucient") private var customColor = Color.primary
	@Preference("separatedColors", identifier: "moe.absolucy.lucient") private var separatedColors = false

	@Preference("minTimeSize", identifier: "moe.absolucy.lucient") var minFontSize: Double = 24
	@Preference("maxTimeSize", identifier: "moe.absolucy.lucient") var maxFontSize: Double = 160
	@Preference("timeOffset", identifier: "moe.absolucy.lucient") var timeOffset: Double = 15
	@Preference("timeOnTheRight", identifier: "moe.absolucy.lucient") private var timeOnTheRight = false
	@Preference("timeColorMode", identifier: "moe.absolucy.lucient") var timeColorMode = ColorMode.secondary
	@Preference("timeColor", identifier: "moe.absolucy.lucient") var timeCustomColor = Color.primary
	@Preference("time24hr", identifier: "moe.absolucy.lucient") var time24Hour = false
	@State private var date = Date()
	@State private var hourFmt: DateFormatter = {
		let is24Hr: Bool = {
			guard let defaults = UserDefaults(suiteName: "/var/mobile/Library/Preferences/moe.absolucy.lucient.plist")
			else { return false }
			return defaults.object(forKey: "time24hr") as? Bool ?? false
		}()
		let formatter = DateFormatter()
		formatter.dateFormat = is24Hr ? "hh" : "HH"
		return formatter
	}()

	@State private var minFmt: DateFormatter = {
		let is24Hr: Bool = {
			guard let defaults = UserDefaults(suiteName: "/var/mobile/Library/Preferences/moe.absolucy.lucient.plist")
			else { return false }
			return defaults.object(forKey: "time24hr") as? Bool ?? false
		}()
		let formatter = DateFormatter()
		formatter.dateFormat = is24Hr ? "HH:mm" : "hh:mm a"
		return formatter
	}()

	@ObservedObject private var shared = SharedData.global

	var body: some View {
		let color = ColorManager.instance.get(
			separatedColors,
			mode: colorMode,
			customMode: timeColorMode,
			color: customColor,
			customColor: timeCustomColor
		)
		let font = FontRegistration.font(
			size: shared.timeMinimized ? minFontSize : maxFontSize,
			style: fontStyle,
			custom: customFont
		)
		VStack(alignment: .center, spacing: 0) {
			if shared.timeMinimized && !timeOnTheRight {
				Text(minFmt.string(from: date))
					.font(font)
					.lineLimit(1)
					.foregroundColor(color)
			} else {
				Text(hourFmt.string(from: date))
					.font(font)
					.lineLimit(1)
					.foregroundColor(color)
					.offset(x: 0, y: CGFloat(timeOffset))

				Text(minuteFmt.string(from: date))
					.font(font)
					.lineLimit(1)
					.foregroundColor(color)
					.offset(x: 0, y: CGFloat(-timeOffset))
			}
		}.onReceive(timeObserver) { _ in
			date = Date()
		}.onChange(of: time24Hour) { newValue in
			hourFmt.dateFormat = newValue ? "HH" : "hh"
			minFmt.dateFormat = newValue ? "HH:mm" : "hh:mm a"
		}
		.padding(.trailing)
	}
}

@_cdecl("makeTimeView")
internal func makeTimeView() -> UIViewController? {
	UIHostingController(rootView: TimeView.view)
}
