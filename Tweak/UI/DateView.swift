//
//  DateView.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import SwiftUI

internal struct DateView: View {
	static var view = DateView()

	private let fmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "E, MMM d"
		return formatter
	}()

	private let timeObserver = NotificationCenter.default.publisher(for: NSNotification.Name("me.aspenuwu.lucient.time"))
	private let weatherObserver = NotificationCenter.default.publisher(for: NSNotification.Name("me.aspenuwu.lucient.weather"))

	@State private var date = Date()
	@ObservedObject private var shared = SharedData.global

	var body: some View {
		VStack(alignment: .leading) {
			Text(fmt.string(from: date))
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
		.animation(.easeInOut)
		.transition(.move(edge: .top))
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
