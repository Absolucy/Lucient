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

	private let screenObserver = NotificationCenter.default.publisher(for: Notification.Name("me.aspenuwu.thanos.screen"))
	private let oneSecondObserver = NotificationCenter.default.publisher(for: Notification.Name("me.aspenuwu.thanos.1s"))
	private let tenSecondObserver = NotificationCenter.default.publisher(for: Notification.Name("me.aspenuwu.thanos.10s"))

	@State private var date = Date()
	@ObservedObject private var shared = SharedData.global

	func updateTimeDate() {
		date = Date()
	}

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
	}
}

@_cdecl("makeDateView")
public dynamic func makeDateView() -> UIViewController? {
	UIHostingController(rootView: DateView())
}

struct DateView_Previews: PreviewProvider {
	static var previews: some View {
		DateView()
	}
}
