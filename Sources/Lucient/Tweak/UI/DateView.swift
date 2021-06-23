//
//  DateView.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import EventKit
import LucientC
import SwiftUI

internal struct DateView: View {
	static var view = DateView()

	private let dateFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "E, MMM d"
		return formatter
	}()

	private let timeFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh:mm"
		return formatter
	}()

	private let timeObserver = NotificationCenter.default.publisher(for: NSNotification.Name("moe.absolucy.lucient.time"))
	private let weatherObserver = NotificationCenter.default
		.publisher(for: NSNotification.Name("moe.absolucy.lucient.weather"))
	private let ekStore = EKEventStore()

	@Preference("fontStyle", identifier: "moe.absolucy.lucient") private var fontStyle = FontStyle.ios
	@Preference("customFont",
	            identifier: "moe.absolucy.lucient") var customFont = "/Library/Lucy/LucientResources.bundle/Roboto.ttf"
	@Preference("colorMode", identifier: "moe.absolucy.lucient") private var colorMode = ColorMode.secondary
	@Preference("color", identifier: "moe.absolucy.lucient") private var customColor = Color.primary
	@Preference("separatedColors", identifier: "moe.absolucy.lucient") private var separatedColors = false

	@Preference("showWeather", identifier: "moe.absolucy.lucient") private var showWeather = true
	@Preference("minTimeSize", identifier: "moe.absolucy.lucient") private var timeSize: Double = 24
	@Preference("dateFontSize", identifier: "moe.absolucy.lucient") private var fontSize: Double = 24
	@Preference("dateOffset", identifier: "moe.absolucy.lucient") private var offset: Double = 0
	@Preference("dateColorMode", identifier: "moe.absolucy.lucient") var dateColorMode = ColorMode.secondary
	@Preference("dateColor", identifier: "moe.absolucy.lucient") var dateCustomColor = Color.primary
	@State private var date = Date()
	@ObservedObject private var shared = SharedData.global

	init() {
		ekStore.requestAccess(to: .event) { _, error in
			if let error = error {
				NSLog("[Lucient] failed to get access to events: \(error)")
			}
		}
		ekStore.requestAccess(to: .reminder) { _, error in
			if let error = error {
				NSLog("[Lucient] failed to get access to reminders: \(error)")
			}
		}
	}

	var body: some View {
		let color = ColorManager.instance.get(
			separatedColors,
			mode: colorMode,
			customMode: dateColorMode,
			color: customColor,
			customColor: dateCustomColor
		)
		let font = FontRegistration.font(size: fontSize, style: fontStyle, custom: customFont)
		VStack(alignment: .leading, spacing: 0) {
			Text(dateFmt.string(from: date))
				.font(font)
				.foregroundColor(color)
				.offset(x: 0, y: CGFloat(offset))
			if showWeather, let temperature = shared.temperature, let image = shared.weatherImage {
				HStack {
					image
						.resizable()
						.scaledToFit()
						.frame(width: CGFloat(fontSize * 2), height: CGFloat(fontSize * 2))
					Text(temperature)
						.font(font)
						.foregroundColor(color)
					Spacer()
				}.offset(x: 0, y: CGFloat(-offset))
			}
		}
		.onReceive(timeObserver) { _ in
			date = Date()
		}
		.onReceive(weatherObserver) { _ in
			shared.updateWeather()
		}
	}
}

@_cdecl("makeDateView")
internal func makeDateView() -> UIViewController? {
	UIHostingController(rootView: DateView.view)
}
