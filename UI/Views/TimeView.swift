//
//  12TimeView.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import SwiftUI
import UIKit

struct TimeView: View {
	private let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh\nmm"
		return formatter
	}()

	private let observer = NotificationCenter.default.publisher(for: Notification.Name("me.aspenuwu.thanos.lsvis"))

	@State private var size: CGFloat = 128
	@State private var date = Date()
	@State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	private func updateTimeDate() {
		date = Date()
	}

	private func startTimer() {
		timer = timer.upstream.autoconnect()
	}

	private func stopTimer() {
		timer.upstream.connect().cancel()
	}

	var body: some View {
		Text(formatter.string(from: date))
			.font(.system(size: size, weight: .thin, design: .rounded))
			.multilineTextAlignment(.center)
			.onReceive(timer) { _ in
				updateTimeDate()
			}
			.onReceive(observer) { obj in
				guard let visible = obj.object as? Bool else { return }
				if visible {
					startTimer()
				} else {
					stopTimer()
				}
			}
	}
}

@_cdecl("makeTimeView")
public dynamic func makeTimeView() -> UIViewController? {
	UIHostingController(rootView: TimeView())
}

struct TimeView_Previews: PreviewProvider {
	static var previews: some View {
		TimeView()
			.previewDevice("iPhone 11")
	}
}
