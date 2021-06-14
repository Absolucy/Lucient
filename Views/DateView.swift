//
//  DateView.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import SwiftUI

struct DateView: View {
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "E, MMM d"
		return formatter
	}()
	private let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh:mm"
		return formatter
	}()
	private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	private let weatherTimer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
	
	@State private var date = Date()
	@ObservedObject private var shared = SharedData.global
	
	private func updateTimeDate() {
		date = Date()
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			if shared.notifsVisible {
				Text(timeFormatter.string(from: date))
					.font(.system(size: 72, weight: .light, design: .rounded))
					.padding(.bottom, 5)
			}
			Text(dateFormatter.string(from: date))
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
		.onReceive(timer) { _ in
			updateTimeDate()
		}
		.onReceive(weatherTimer) { _ in
			shared.updateWeatherData()
		}
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
