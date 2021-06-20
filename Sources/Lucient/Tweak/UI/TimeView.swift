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

	@Preference("appearance", identifier: "moe.absolucy.lucient") var appearance = 1
	@Preference("maxFontSize", identifier: "moe.absolucy.lucient") var fontSize: Double = 160
	@Preference("customFont",
	            identifier: "moe.absolucy.lucient") var customFont = "/Library/Lucy/LucientResources.bundle/Roboto.ttf"
	@State private var date = Date()

	private func font() -> Font {
		_ = FontRegistration.register
		if appearance == 2 {
			return Font.custom("Roboto-Regular", size: CGFloat(fontSize))
		} else if appearance == 3, let fontName = FontRegistration.register(url: URL(fileURLWithPath: customFont)) {
			return Font.custom(fontName, size: CGFloat(fontSize))
		} else {
			return Font.system(size: CGFloat(fontSize), weight: .thin, design: .rounded)
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
