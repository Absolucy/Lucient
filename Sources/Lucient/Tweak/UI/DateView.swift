//
//  DateView.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import SwiftUI
import LucientC

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
	private let timeObserver = NotificationCenter.default.publisher(for: NSNotification.Name("me.aspenuwu.lucient.time"))
	private let weatherObserver = NotificationCenter.default
		.publisher(for: NSNotification.Name("me.aspenuwu.lucient.weather"))

	@State private var date = Date()
	@ObservedObject private var shared = SharedData.global

	var body: some View {
		VStack(alignment: .leading) {
			if shared.notifsVisible {
				Text(timeFmt.string(from: date))
					.font(.system(size: 72, weight: .light, design: .rounded))
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
				.font(.system(size: 24, weight: .light, design: .rounded))
			if let temperature = shared.temperature, let image = shared.weatherImage {
				HStack {
					image
						.resizable()
						.scaledToFit()
						.frame(width: 48, height: 48)
					Text(temperature)
						.font(.system(size: 24, weight: .light, design: .rounded))
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

struct DateView_Previews: PreviewProvider {
	static var previews: some View {
		DateView()
	}
}
