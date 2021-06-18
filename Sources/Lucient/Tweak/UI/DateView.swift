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

	@Preference("appearance", identifier: "moe.absolucy.lucient") var appearance = 1
	@State private var date = Date()
	@ObservedObject private var shared = SharedData.global

	private func font(_ size: CGFloat) -> Font {
		_ = FontRegistration.register
		if appearance == 2 {
			return Font.custom("Roboto-Regular", size: size)
		} else {
			return Font.system(size: size, weight: .light, design: .rounded)
		}
	}

	var body: some View {
		VStack(alignment: .leading) {
			if shared.notifsVisible {
				Text(timeFmt.string(from: date))
					.font(font(72))
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
				.font(font(24))
			if let temperature = shared.temperature, let image = shared.weatherImage {
				HStack {
					image
						.resizable()
						.scaledToFit()
						.frame(width: 48, height: 48)
					Text(temperature)
						.font(font(24))
					Spacer()
				}
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
