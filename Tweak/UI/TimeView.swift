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

	private let bigFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh\nmm"
		return formatter
	}()

	private let smallFmt: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh:mm"
		return formatter
	}()

	@State private var size: CGFloat = 128
	@State private var date = Date()

	func updateTimeDate() {
		date = Date()
	}

	var body: some View {
		Text(bigFmt.string(from: date))
			.font(.system(size: size, weight: .thin, design: .rounded))
			.multilineTextAlignment(.center)
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
