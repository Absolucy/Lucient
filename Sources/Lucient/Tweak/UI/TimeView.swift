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

	private let hourFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh"
		return formatter
	}()
	private let minuteFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "mm"
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
		VStack(alignment: .center, spacing: 0) {
			Text(hourFmt.string(from: date))
				.font(font())
				.lineLimit(1)
				.offset(x: 0, y: 15)
				.onReceive(timeObserver) { _ in
					date = Date()
				}
			Text(minuteFmt.string(from: date))
				.font(font())
				.lineLimit(1)
				.offset(x: 0, y: -15)
				.onReceive(timeObserver) { _ in
					date = Date()
				}
		}
	}
}

@_cdecl("makeTimeView")
public dynamic func makeTimeView() -> UIViewController? {
	UIHostingController(rootView: TimeView.view)
}
