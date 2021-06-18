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

	private let fmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh\nmm"
		return formatter
	}()

	private let timeObserver = NotificationCenter.default.publisher(for: NSNotification.Name("moe.absolucy.lucient.time"))

	@Preference("appearance", identifier: "moe.absolucy.lucient") var appearance = 0
	@State private var date = Date()

	private func font() -> Font {
		_ = FontRegistration.register
		if appearance == 2 {
			return Font.custom("Roboto", size: 128)
		} else {
			return Font.system(size: 128, weight: .thin, design: .rounded)
		}
	}

	var body: some View {
		Text(fmt.string(from: date))
			.font(font())
			.multilineTextAlignment(.center)
			.onReceive(timeObserver) { _ in
				date = Date()
			}
	}
}

@_cdecl("makeTimeView")
public dynamic func makeTimeView() -> UIViewController? {
	UIHostingController(rootView: TimeView.view)
}
