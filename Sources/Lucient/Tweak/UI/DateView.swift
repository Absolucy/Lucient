//
//  DateView.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

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

	@Preference("appearance", identifier: "moe.absolucy.lucient") private var style = 2
	@Preference("showWeather", identifier: "moe.absolucy.lucient") private var showWeather = true
	@Preference("minTimeSize", identifier: "moe.absolucy.lucient") private var timeSize: Double = 24
	@Preference("dateFontSize", identifier: "moe.absolucy.lucient") private var fontSize: Double = 24
	@Preference("dateOffset", identifier: "moe.absolucy.lucient") private var offset: Double = 2
	@Preference("customFont",
	            identifier: "moe.absolucy.lucient") var customFont = "/Library/Lucy/LucientResources.bundle/Roboto.ttf"
	@State private var date = Date()
	@ObservedObject private var shared = SharedData.global

	private func font(_ size: Double) -> Font {
		_ = FontRegistration.register
		if style == 2 {
			return Font.custom("Roboto-Regular", size: CGFloat(size))
		} else if style == 3, let fontName = FontRegistration.register(url: URL(fileURLWithPath: customFont)) {
			return Font.custom(fontName, size: CGFloat(size))
		} else {
			return Font.system(size: CGFloat(size), weight: .light, design: .rounded)
		}
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			if shared.timeMinimized {
				Text(timeFmt.string(from: date))
					.font(font(timeSize))
					.padding(.bottom, 5)
					.animation(.easeInOut)
					.transition(
						.offset(
							x: coverSheetView.center.x - dateView.view.frame.maxX,
							y: coverSheetView.center.y - dateView.view.frame.maxY
						)
					)
			}
			Text(dateFmt.string(from: date))
				.font(font(fontSize))
				.offset(x: 0, y: CGFloat(offset))
			if showWeather, let temperature = shared.temperature, let image = shared.weatherImage {
				HStack {
					image
						.resizable()
						.scaledToFit()
						.frame(width: CGFloat(fontSize * 2), height: CGFloat(fontSize * 2))
					Text(temperature)
						.font(font(fontSize))
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
public dynamic func makeDateView() -> UIViewController? {
	UIHostingController(rootView: DateView.view)
}
