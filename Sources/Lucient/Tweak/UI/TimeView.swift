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

	private let minFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh:mm"
		return formatter
	}()

	private let timeObserver = NotificationCenter.default.publisher(for: NSNotification.Name("moe.absolucy.lucient.time"))

	@Preference("appearance", identifier: "moe.absolucy.lucient") var style = 1
	@Preference("minTimeSize", identifier: "moe.absolucy.lucient") var minFontSize: Double = 24
	@Preference("maxTimeSize", identifier: "moe.absolucy.lucient") var maxFontSize: Double = 160
	@Preference("timeOffset", identifier: "moe.absolucy.lucient") var timeOffset: Double = 15
	@Preference("timeOnTheRight", identifier: "moe.absolucy.lucient") private var timeOnTheRight = false
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
			return Font.system(size: CGFloat(size), weight: .thin, design: .rounded)
		}
	}

	var body: some View {
		VStack(alignment: .center, spacing: 0) {
			if shared.timeMinimized && !timeOnTheRight {
				Text(minFmt.string(from: date))
					.font(font(minFontSize))
					.lineLimit(1)
			} else {
				Text(hourFmt.string(from: date))
					.font(font((shared.timeMinimized && timeOnTheRight) ? minFontSize : maxFontSize))
					.lineLimit(1)
					.offset(x: 0, y: CGFloat(timeOffset))

				Text(minuteFmt.string(from: date))
					.font(font((shared.timeMinimized && timeOnTheRight) ? minFontSize : maxFontSize))
					.lineLimit(1)
					.offset(x: 0, y: CGFloat(-timeOffset))
			}
		}.onReceive(timeObserver) { _ in
			date = Date()
		}
		.padding(.trailing)
	}
}

@_cdecl("makeTimeView")
public dynamic func makeTimeView() -> UIViewController? {
	UIHostingController(rootView: TimeView.view)
}
