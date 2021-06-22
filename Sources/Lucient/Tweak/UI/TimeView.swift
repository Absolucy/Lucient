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

	private let hourFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh"
		return formatter
	}()

	private let minuteFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "mm"
		return formatter
	}()

	private let minFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh:mm"
		return formatter
	}()

	private let timeObserver = NotificationCenter.default.publisher(for: NSNotification.Name("moe.absolucy.lucient.time"))

	@Preference("fontStyle", identifier: "moe.absolucy.lucient") private var fontStyle = FontStyle.ios
	@Preference("customFont",
	            identifier: "moe.absolucy.lucient") var customFont = "/Library/Lucy/LucientResources.bundle/Roboto.ttf"
	@Preference("colorMode", identifier: "moe.absolucy.lucient") private var colorMode = ColorMode.background
	@Preference("color", identifier: "moe.absolucy.lucient") private var customColor = Color.primary
	@Preference("separatedColors", identifier: "moe.absolucy.lucient") private var separatedColors = false

	@Preference("minTimeSize", identifier: "moe.absolucy.lucient") var minFontSize: Double = 24
	@Preference("maxTimeSize", identifier: "moe.absolucy.lucient") var maxFontSize: Double = 160
	@Preference("timeOffset", identifier: "moe.absolucy.lucient") var timeOffset: Double = 15
	@Preference("timeOnTheRight", identifier: "moe.absolucy.lucient") private var timeOnTheRight = false
	@Preference("timeColorMode", identifier: "moe.absolucy.lucient") var timeColorMode = ColorMode.background
	@Preference("timeColor", identifier: "moe.absolucy.lucient") var timeCustomColor = Color.primary
	@State private var date = Date()
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
		}
		.padding(.trailing)
	}
}

@_cdecl("makeTimeView")
public dynamic func makeTimeView() -> UIViewController? {
	UIHostingController(rootView: TimeView.view)
}
