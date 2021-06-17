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

	private let timeObserver = NotificationCenter.default.publisher(for: NSNotification.Name("me.aspenuwu.lucient.time"))

	@State private var size: CGFloat = 128
	@State private var date = Date()

	var body: some View {
		Text(fmt.string(from: date))
			.font(.system(size: size, weight: .thin, design: .rounded))
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

struct TimeView_Previews: PreviewProvider {
	static var previews: some View {
		TimeView()
			.previewDevice("iPhone 11")
	}
}
